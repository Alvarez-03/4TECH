// Función para abrir el modal
let tipoModalActual = "";

function abrirModal(button) {
    const modal = document.getElementById('miModal');
    const modalContent = document.getElementById('modalContent');
    const type = button.getAttribute('data-type');
    tipoModalActual = type;

    if (!modal) return;

    if (tipoModalActual === 'FormRegisterOrd'){
        console.log("FormRegisterOrd")
        cargarEmpleadosDinamicos('empleado_id')
    }
    if (tipoModalActual === 'FormRegisterWork' || tipoModalActual === 'UpdWork') {
        cargarEmpresasDinamicas('selectEmpresaRegistro');
    }
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
    const type = button.getAttribute('data-type'); // "UpdEmp"
    abrirModal(button);

    // 1. Buscamos el formulario específico por su ID único
    const form = document.getElementById('formUpdEmp');
    if (!form) return;

    // 2. Llenamos los campos usando el atributo 'name' para evitar conflictos de ID
    form.querySelector('input[name="nombre"]').value = button.getAttribute('data-nombre');
    form.querySelector('input[name="siglas"]').value = button.getAttribute('data-siglas');
    form.querySelector('input[name="telefono"]').value = button.getAttribute('data-telefono');
    form.querySelector('input[name="ciudad"]').value = button.getAttribute('data-ciudad');
    form.querySelector('input[name="direccion"]').value = button.getAttribute('data-direccion');

    // 3. Manejo del Email (Readonly)
    const inputEmail = form.querySelector('input[name="email"]');
    inputEmail.value = button.getAttribute('data-email');
    inputEmail.readOnly = true;
    inputEmail.classList.add('bg-gray-200', 'cursor-not-allowed');

    // 4. Manejo del Estado (Select)
    const selectEstado = form.querySelector('select[name="estado"]');
    const estado = button.getAttribute('data-estado');
    if (selectEstado && estado) {
        selectEstado.value = estado;
    }

    // 5. Password siempre limpio en edición
    const inputPass = form.querySelector('input[name="password"]');
    if (inputPass) {
        inputPass.value = "";
        inputPass.required = false;
    }
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
        'UpdWork': {
            title: '¿No actualizar colaborador?',
            text: 'Las modificaciones realizadas al trabajador se perderán.'
        },
        'FormRegisterOrd': {
            title: '¿No quieres agregar la orden?',
            text: 'al aceptar se perderán todos los campos llenados.'
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

                    if (tipoModalActual === 'UpdEmp' || tipoModalActual === 'FormRegisterEmp') {
                        window.location.href = "SvUsuarios";
                    }

                    else if (tipoModalActual === 'FormRegisterWork' || tipoModalActual === 'UpdWork') {
                        window.location.href = "SvEmpleados";
                    }

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

// Función para cargar las empresas desde el Servlet
function cargarEmpresasDinamicas(idDelSelect) {
    console.log("cargando empleados")
    const select = document.getElementById(idDelSelect);

    if (!select) return;

    fetch('SvUsuarios?accion=listarActivas')
        .then(response => {
            if (!response.ok) throw new Error('Error en la red');
            return response.json();
        })
        .then(data => {
            select.innerHTML = '<option value="" disabled selected>Seleccione una empresa...</option>';
            data.forEach(emp => {
                const option = document.createElement('option');
                option.value = emp.id;
                option.textContent = emp.nombre;
                select.appendChild(option);
            });
        })
        .catch(error => {
            console.error('Error:', error);
            select.innerHTML = '<option value="">Error al cargar empresas</option>';
        });
}


function cargarEmpleadosDinamicos(idDelSelect) {
    const select = document.getElementById(idDelSelect);

    // Verificamos que el select exista en el DOM para evitar errores
    if (!select) {
        console.warn(`No se encontró el elemento con ID: ${idDelSelect}`);
        return;
    }

    // Mostramos un mensaje de carga temporal
    select.innerHTML = '<option value="" disabled selected>Cargando técnicos...</option>';

    // Llamamos al Servlet SvEmpleados usando la nueva acción JSON
    fetch('SvEmpleados?accion=listarPorEmpresaJSON')
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al obtener datos del servidor');
            }
            return response.json();
        })
        .then(data => {

            select.innerHTML = '<option value="" disabled selected>Seleccione un técnico...</option>';

            if (data.length === 0) {
                const option = document.createElement('option');
                option.value = "";
                option.textContent = "No hay empleados activos disponibles";
                option.disabled = true;
                select.appendChild(option);
                return;
            }

            data.forEach(emp => {
                const option = document.createElement('option');
                console.log(emp.id)
                option.value = emp.id;
                option.textContent = `${emp.nombre} — (${emp.cargo})`;
                select.appendChild(option);
            });

            console.log("Empleados cargados exitosamente.");
        })
        .catch(error => {
            console.error('Error en cargarEmpleadosDinamicos:', error);
            select.innerHTML = '<option value="">Error al cargar la lista</option>';
        });
}

function abrirModalActualizarTrabajador(button) {

    abrirModal(button);

    const form = document.querySelector('#container-UpdWork');
    const idEmpresaActual = button.getAttribute('data-empresa-id');

    // Llenar campos con los atributos data- del botón
    if(form){
        form.querySelector('input[name="ID"]').value = button.getAttribute('data-id');
        form.querySelector('input[name="nombre"]').value = button.getAttribute('data-nombre');
        form.querySelector('input[name="email"]').value = button.getAttribute('data-email');
        form.querySelector('input[name="telefono"]').value = button.getAttribute('data-telefono');
        form.querySelector('input[name="cargo"]').value = button.getAttribute('data-cargo');

        setTimeout(() => {
            const selectEmp = form.querySelector('select[name="empresa_id"]');
            if (selectEmp && idEmpresaActual) {
                selectEmp.value = idEmpresaActual;
            }
        }, 350);
    }
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
