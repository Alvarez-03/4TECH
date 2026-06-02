
function confirmarCambioEstado(id, estadoActual) {
    const esActivo = estadoActual.toUpperCase() === 'ACTIVO';
    const nuevoEstadoNom = esActivo ? 'desactivar' : 'activar';
    const colorConfirm = esActivo ? '#f97316' : '#22c55e'; // Naranja o Verde

    Swal.fire({
        title: `¿Confirmas ${nuevoEstadoNom} al colaborador?`,
        text: `El usuario quedará con estado ${esActivo ? 'INACTIVO' : 'ACTIVO'}.`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: colorConfirm,
        cancelButtonColor: '#6b7280',
        confirmButtonText: `Sí, ${nuevoEstadoNom}`,
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            ejecutarCambioEstado(id, estadoActual);
        }
    });
}

function ejecutarCambioEstado(id, estado) {
    // Usamos URLSearchParams para que el Servlet lo reciba como parámetros normales
    const params = new URLSearchParams();
    params.append('accion', 'cambiarEstado');
    params.append('id', id);
    params.append('estado', estado);

    fetch('SvEmpleados', {
        method: 'POST',
        body: params
    })
        .then(response => {
            if (response.ok) {
                Swal.fire({
                    icon: 'success',
                    title: 'Estado actualizado',
                    showConfirmButton: false,
                    timer: 1500
                }).then(() => {
                    // Recargamos para ver los cambios en la tabla
                    window.location.href = "SvEmpleados";
                });
            } else {
                throw new Error('Error en el servidor');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'No se pudo cambiar el estado del colaborador', 'error');
        });
}

function filtrarEmpleados() {
    // 1. Obtener el valor del input y pasarlo a minúsculas
    const input = document.getElementById("inputBusqueda");
    const filtro = input.value.toLowerCase();

    // 2. Obtener todas las filas del cuerpo de la tabla
    const tabla = document.getElementById("tablaEmpleados");
    const filas = tabla.getElementsByTagName("tr");

    // 3. Recorrer cada fila
    for (let i = 0; i < filas.length; i++) {
        const celdas = filas[i].getElementsByTagName("td");
        let coincidencia = false;

        // Saltamos la fila si es la de "No hay resultados" (si existe)
        if (celdas.length < 2) continue;

        // 4. Revisar el contenido de cada celda de la fila actual
        for (let j = 0; j < celdas.length; j++) {
            const textoCelda = celdas[j].textContent || celdas[j].innerText;
            if (textoCelda.toLowerCase().indexOf(filtro) > -1) {
                coincidencia = true;
                break; // Si ya encontramos el texto en una celda, pasamos a la siguiente fila
            }
        }

        // 5. Mostrar u ocultar la fila según el resultado
        if (coincidencia) {
            filas[i].style.display = ""; // Mostrar
        } else {
            filas[i].style.display = "none"; // Ocultar
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