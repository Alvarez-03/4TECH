function filtrarEmpresas() {
    const input = document.getElementById("inputBusqueda");
    const filtro = input.value.toLowerCase();

    const tabla = document.getElementById("tablaEmpresas");
    const filas = tabla.getElementsByTagName("tr");

    for (let i = 0; i < filas.length; i++) {
        let coincidencia = false;
        const celdas = filas[i].getElementsByTagName("td");


        if (celdas.length < 2) continue;

        for (let j = 0; j < celdas.length; j++) {
            const textoCelda = celdas[j].textContent || celdas[j].innerText;
            if (textoCelda.toLowerCase().indexOf(filtro) > -1) {
                coincidencia = true;
                break;
            }
        }

        if (coincidencia) {
            filas[i].style.display = "";
        } else {
            filas[i].style.display = "none";
        }
    }

    const filasVisibles = Array.from(filas).filter(f => f.style.display !== "none");
    let mensajeError = document.getElementById("mensajeBusquedaVacia");

    if (filasVisibles.length === 0) {
        if (!mensajeError) {
            mensajeError = document.createElement("tr");
            mensajeError.id = "mensajeBusquedaVacia";
            mensajeError.innerHTML = `<td colspan="6" class="px-6 py-10 text-center text-gray-400">
            No se encontraron empleados que coincidan con "${filtro}"
        </td>`;
            tabla.appendChild(mensajeError);
        }
    } else if (mensajeError) {
        mensajeError.remove();
    }
}