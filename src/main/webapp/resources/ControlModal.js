// Función para abrir el modal
function abrirModal(button) {
    const modal = document.getElementById('miModal');
    const modalContent = document.getElementById('modalContent');

    if (!modal) {
        console.error("No se encontró el elemento miModal");
        return;
    }

    const type = button.getAttribute('data-type');
    console.log("Abriendo modal de tipo:", type);

    modal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';

    setTimeout(() => {
        modal.classList.add('opacity-100');
        modalContent.classList.remove('scale-95', 'opacity-0');
        modalContent.classList.add('scale-100', 'opacity-100');
    }, 10);
}

// Función para cerrar el modal
function cerrarModal() {
    Swal.fire({
        title: '¿No quieres registrar la empresa?',
        text: "Se perderan los datos y la empresa no quedara registrada.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#EF2917',
        cancelButtonColor: '#1d4ed8',
        confirmButtonText: 'No registrar',
        cancelButtonText: 'Continuar'
    }).then((result) => {
        if (result.isConfirmed) {
            let modal = document.getElementById('miModal');
            let modalContent = document.getElementById('modalContent');

            modalContent.classList.remove('scale-100', 'opacity-100');
            modalContent.classList.add('scale-95', 'opacity-0');
            modal.classList.remove('opacity-100');

            document.body.style.overflow = 'auto';

            setTimeout(() => {
                modal.classList.add('hidden');
            }, 300);
        }
    });

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
                    let modal = document.getElementById('miModal');
                    let modalContent = document.getElementById('modalContent');

                    modalContent.classList.remove('scale-100', 'opacity-100');
                    modalContent.classList.add('scale-95', 'opacity-0');
                    modal.classList.remove('opacity-100');

                    document.body.style.overflow = 'auto';

                    setTimeout(() => {
                        modal.classList.add('hidden');
                    }, 300);
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

// Configurar los eventos una vez que el HTML esté listo
document.addEventListener("DOMContentLoaded", function() {
    const btnCerrar = document.getElementById('btnCerrarModal');
    const modal = document.getElementById('miModal');

    if (btnCerrar) {
        btnCerrar.onclick = cerrarModal;
    }

    if (modal) {
        modal.onclick = (e) => {
            if (e.target === modal) cerrarModal();
        };
    }
});