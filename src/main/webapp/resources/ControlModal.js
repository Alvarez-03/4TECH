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
        'AdminEmp': {
            title: '¿Cerrar administración?',
            text: 'Se cerrará la vista de gestión de empresas.'
        }
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
    event.preventDefault(); // Evita que la página se recargue

    const form = event.target;
    const formData = new FormData(form);

    // Enviamos los datos al Servlet usando fetch
    fetch(form.action, {
        method: 'POST',
        body: new URLSearchParams(formData)
    })
        .then(response => {
            if (response.ok) {
                // --- ¡ÉXITO! ---
                Swal.fire({
                    icon: 'success',
                    title: '¡Registro Exitoso!',
                    text: 'La empresa ha sido creada correctamente.',
                }).then(() => {
                    ejecutarCierreEfectivo()
                });

            } else {
                console.error("Error:", error);
                Swal.fire({
                    icon: 'error',
                    title: 'Upps',
                    text: 'Registro no exitoso.',
                });
            }
        })
        .catch(error => {
            console.error("Error en la petición:", error);
            alert("No se pudo conectar con el servidor.");
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