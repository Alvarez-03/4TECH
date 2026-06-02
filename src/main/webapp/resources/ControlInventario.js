function filtrarInventario() {
    const input = document.getElementById("inputBusqueda");
    const filtro = input.value.toLowerCase();
    const tabla = document.getElementById("tablaCuerpoInventario");
    const filas = tabla.getElementsByTagName("tr");

    let coincidencias = 0;

    for (let i = 0; i < filas.length; i++) {
        // Ignorar la fila de "Sin resultados" si existe
        if (filas[i].id === "msg-vacio-inv") continue;

        const texto = filas[i].innerText.toLowerCase();
        if (texto.includes(filtro)) {
            filas[i].style.display = "";
            coincidencias++;
        } else {
            filas[i].style.display = "none";
        }
    }

    // Manejo de mensaje vacío
    let msgVacio = document.getElementById("msg-vacio-inv");
    if (coincidencias === 0) {
        if (!msgVacio) {
            msgVacio = document.createElement("tr");
            msgVacio.id = "msg-vacio-inv";
            msgVacio.innerHTML = `<td colspan="6" class="px-6 py-10 text-center text-gray-400">No se encontraron productos que coincidan con "${input.value}"</td>`;
            tabla.appendChild(msgVacio);
        }
    } else if (msgVacio) {
        msgVacio.remove();
    }
}

function confirmarEliminarProducto(id) {
    Swal.fire({
        title: '¿Eliminar producto?',
        text: "Esta acción no se puede deshacer y afectará el stock.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            // Usamos URLSearchParams para coherencia con tus otros servlets
            const params = new URLSearchParams();
            params.append('accion', 'eliminar');
            params.append('producto_id', id);

            fetch('SvInventario', {
                method: 'POST',
                body: params
            })
                .then(response => {
                    if(response.ok) {
                        Swal.fire('¡Eliminado!', 'El producto ha sido borrado.', 'success')
                            .then(() => location.reload());
                    } else {
                        Swal.fire('Error', 'No se pudo eliminar el producto.', 'error');
                    }
                });
        }
    });
}