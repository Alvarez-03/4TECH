function deshabilitarBoton() {
    const btn = document.getElementById('btnRegistrar');
    const text = document.getElementById('btnText');
    const spinner = document.getElementById('btnSpinner');

    // 1. Deshabilitar el botón para evitar clics extra
    btn.disabled = true;

    // 2. Cambiar el texto y mostrar el spinner
    text.innerText = "Validando...";
    spinner.classList.remove('hidden');

    // 3. Opcional: Cambiar un poco el color para dar feedback visual
    btn.classList.add('bg-gray-400');
    btn.classList.remove('bg-indigo-600');
}

function CerrarSesion(){
    Swal.fire({
        title: '¿Cerrar sesión?',
        text: "Tendrás que volver a ingresar para acceder.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#1d4ed8',
        cancelButtonColor: '#EF2917',
        confirmButtonText: 'Sí, salir',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = "SvLogout";
        }
    });
}

function toggleMenu() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');

    // Si tiene la clase de estar escondido, se la quitamos y viceversa
    sidebar.classList.toggle('-translate-x-full');

    // Mostramos u ocultamos el fondo oscuro
    overlay.classList.toggle('hidden');
}