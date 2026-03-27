// Función para abrir el modal
let tipoModalActual = "";

function abrirModal(button) {
    const modal = document.getElementById('miModal');
    const modalContent = document.getElementById('modalContent');
    const type = button.getAttribute('data-type'); // Ejemplo: "FormRegisterEmp"
    tipoModalActual = type;

    if (!modal) return;

    // 1. Ocultar TODAS las secciones del modal primero
    document.querySelectorAll('.modal-section').forEach(section => {
        section.classList.add('hidden');
    });

    // 2. Mostrar solo la sección que corresponde al tipo
    const sectionToShow = document.getElementById('container-' + type);
    if (sectionToShow) {
        sectionToShow.classList.remove('hidden');
    }

    // 3. Lógica de apertura con animación
    modal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';

    setTimeout(() => {
        modal.classList.add('opacity-100');
        modalContent.classList.remove('scale-95', 'opacity-0');
        modalContent.classList.add('scale-100', 'opacity-100');
    }, 10);
}

function abrirModalEditar(button) {
    // 1. Abrimos el modal con el ID del contenedor de actualización
    const type = button.getAttribute('data-type'); // "UpdEmp"
    abrirModal(button);

    // 2. Buscamos el contenedor del formulario de actualización
    const form = document.querySelector('#container-UpdEmp #formRegistro');

    // 3. Llenamos los campos usando los atributos 'data-' del botón de la tabla
    form.querySelector('#nombre').value = button.getAttribute('data-nombre');
    form.querySelector('#siglas').value = button.getAttribute('data-siglas');
    form.querySelector('#telefono').value = button.getAttribute('data-telefono');


    const inputEmail = form.querySelector('#email');
    const estado = button.getAttribute('data-estado');
    if (estado) {
        form.querySelector('#estado').value = estado;
    }
    inputEmail.value = button.getAttribute('data-email');
    inputEmail.readOnly = true;
    inputEmail.classList.add('bg-gray-200', 'cursor-not-allowed');

    form.querySelector('#ciudad').value = button.getAttribute('data-ciudad');
    form.querySelector('#direccion').value = button.getAttribute('data-direccion');


    form.querySelector('#password').value = "";
    form.querySelector('#password').required = false;
}

function cerrarModal() {
    // Definimos los mensajes por tipo
    const mensajes = {
        'FormRegisterEmp': {
            title: '¿Cancelar registro de empresa?',
            text: 'Se perderán los datos y la empresa no quedará registrada.'
        },
        'FormRegisterWork': {
            title: '¿Cancelar registro de trabajador?',
            text: 'La información del empleado no se guardará.'
        },
        'UpdEmp': {
            title: '¿No actualizar los datos de la empresa?',
            text: 'La información modifica no se guardará.'
        },
    };

    // Obtenemos el mensaje según el tipo actual o uno por defecto
    const contenido = mensajes[tipoModalActual] || {
        title: '¿Cerrar ventana?',
        text: 'Se perderán los cambios no guardados.'
    };

    Swal.fire({
        title: contenido.title,
        text: contenido.text,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#EF2917',
        cancelButtonColor: '#1d4ed8',
        confirmButtonText: 'Sí, cerrar',
        cancelButtonText: 'Continuar'
    }).then((result) => {
        if (result.isConfirmed) {
            ejecutarCierreEfectivo();
        }
    });
}

// Separamos la animación de cierre para no repetir código
function ejecutarCierreEfectivo() {
    const modal = document.getElementById('miModal');
    const modalContent = document.getElementById('modalContent');

    modalContent.classList.remove('scale-100', 'opacity-100');
    modalContent.classList.add('scale-95', 'opacity-0');
    modal.classList.remove('opacity-100');

    document.body.style.overflow = 'auto';

    setTimeout(() => {
        modal.classList.add('hidden');
    }, 300);
}


function enviarFormulario(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);

    fetch(form.action, {
        method: 'POST',
        body: new URLSearchParams(formData)
    })
        .then(response => {
            if (response.ok) {
                Swal.fire({
                    icon: 'success',
                    title: '¡Operación Exitosa!',
                    text: 'Los datos se han procesado correctamente.',
                    confirmButtonColor: '#1d4ed8',
                }).then(() => {
                    ejecutarCierreEfectivo();

                    // --- LÓGICA DE REDIRECCIÓN SELECTIVA ---

                    // Si el modal era de Actualizar Empresa o Registrar Empresa,
                    // vamos al Servlet para refrescar la tabla de empresas.
                    if (tipoModalActual === 'UpdEmp' || tipoModalActual === 'FormRegisterEmp') {
                        window.location.href = "SvUsuarios";
                    }

                    // Si fuera el de trabajadores, podrías mandarlo a otro lado:
                    else if (tipoModalActual === 'FormRegisterWork') {
                        // window.location.href = "SvTrabajadores"; (Ejemplo)
                        location.reload(); // O simplemente recargar la actual
                    }

                    // Para cualquier otro caso (Login, etc.), dejar que el Servlet maneje la respuesta
                    else {
                        location.reload();
                    }
                });

            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Upps',
                    text: 'No se pudo completar la acción.',
                });
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("Error de comunicación con el servidor.");
        });
}

document.addEventListener("DOMContentLoaded", function() {
    const btnCerrar = document.getElementById('btnCerrarModal');
    const modal = document.getElementById('miModal');

    if (btnCerrar) {
        btnCerrar.onclick = cerrarModal;
    }

    if (modal) {
        modal.onclick = (e) => {
            // Si hace clic en el fondo negro, llamamos a la función con alerta
            if (e.target === modal) {
                cerrarModal();
            }
        };
    }
});