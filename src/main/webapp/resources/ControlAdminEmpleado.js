/**
 * Confirma y ejecuta el cambio de estado de un colaborador
 * @param {number} id - ID del empleado
 * @param {string} estadoActual - Estado actual (ACTIVO/INACTIVO)
 */
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