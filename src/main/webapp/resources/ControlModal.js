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
        setTimeout(inicializarBuscadorCliente, 100);
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
        'UpdOrd': {
            title: '¿Cancelar edición?',
            text: 'Los cambios realizados en la orden no se guardarán.'
        },
        'FormInventario': {
            title: '¿Cancelar registro?',
            text: 'Los datos del producto no se guardarán.'
        },
        'UpdInventario': {
            title: '¿Cancelar edición?',
            text: 'Los cambios en el producto se perderán.'
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
                        window.location.href = "SvEmpresas";
                    }

                    else if (tipoModalActual === 'FormRegisterWork' || tipoModalActual === 'UpdWork') {
                        window.location.href = "SvEmpleados";
                    }

                    else if (tipoModalActual === 'FormRegisterOrd' || tipoModalActual === 'FormUpdateOrd') {
                        window.location.href = "Orders.jsp";
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

    fetch('SvEmpresas?accion=listarActivas')
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

function abrirModalActualizarOrden(button) {

    resetearModalesFlujo()

    // 1. Abrimos el modal base
    abrirModal(button);

    // 2. Cargamos los empleados en el select de edición
    cargarEmpleadosDinamicos('upd-empleado-id');

    // 3. Capturamos los datos del botón
    const id = button.getAttribute('data-id');
    const reporte = button.getAttribute('data-reporte');
    const diagnostico = button.getAttribute('data-diagnostico');
    const observaciones = button.getAttribute('data-observaciones');
    const estado = button.getAttribute('data-estado');
    const empleadoId = button.getAttribute('data-empleado');

    // 4. Llenamos los campos del modal
    document.getElementById('edit-orden-id').innerText = "#" + id;
    document.getElementById('upd-orden-id-hidden').value = id;
    document.getElementById('upd-reporte').value = reporte;
    document.getElementById('upd-diagnostico').value = (diagnostico === 'null') ? "" : diagnostico;
    document.getElementById('upd-observaciones').value = (observaciones === 'null') ? "" : observaciones;
    document.getElementById('upd-estado-actual').value = estado;

    //5. cargamos los productos que tiene la orden asignados
    setTimeout(() => {
        cargarSuministrosPreviosOrden(id);
    }, 400);

    // 6. El select de empleados tarda un poco en cargar por el fetch,
    // le damos un pequeño tiempo para seleccionar al empleado correcto
    setTimeout(() => {
        const selectEmp = document.getElementById('upd-empleado-id');
        if (selectEmp) selectEmp.value = empleadoId;
    }, 500);
}
function inicializarBuscadorCliente() {
    const inputDoc = document.getElementById("documento_cliente");
    const inputNombre = document.getElementById("nombre_cliente");
    const inputTel = document.getElementById("telefono_cliente");
    const inputEmail = document.getElementById("email_cliente");
    const statusMsg = document.getElementById("cliente_status");

    // Si no existen los campos (porque estamos en otro modal), salimos
    if (!inputDoc) return;

    inputDoc.addEventListener("blur", function() {
        let doc = this.value.trim();
        if (doc.length < 3) return;

        statusMsg.innerHTML = '<span class="text-blue-500 animate-pulse">Buscando cliente...</span>';

        fetch(`SvClientes?documento=${doc}`)
            .then(res => res.json())
            .then(data => {
                if (data && data.documento) {
                    inputNombre.value = data.nombre;
                    inputTel.value = data.telefono;
                    inputEmail.value = data.email;

                    // Aplicar estilos de bloqueado
                    [inputNombre, inputTel, inputEmail].forEach(el => {
                        el.readOnly = true;
                        el.classList.add('bg-gray-100', 'cursor-not-allowed', 'border-gray-200');
                        el.classList.remove('bg-white', 'border-blue-300');
                    });

                    statusMsg.innerHTML = '<span class="flex items-center text-green-600 font-medium"><i class="fas fa-check-circle mr-1"></i> Cliente vinculado</span>';
                } else {
                    // ESTADO: CLIENTE NUEVO
                    [inputNombre, inputTel, inputEmail].forEach(el => {
                        el.value = "";
                        el.readOnly = false;
                        el.classList.remove('bg-gray-100', 'cursor-not-allowed', 'border-gray-200');
                        el.classList.add('bg-white', 'border-blue-300', 'focus:ring-2');
                    });

                    statusMsg.innerHTML = '<span class="flex items-center text-amber-500 font-medium"><i class="fas fa-info-circle mr-1"></i> Cliente nuevo: complete los datos</span>';
                }
            })
            .catch(err => {
                console.error("Error buscando cliente:", err);
                statusMsg.innerHTML = '<span class="text-red-500 text-sm">Error de conexión.</span>';
            });
    });
}

function abrirModalActualizarInventario(button) {
    // 1. Abrir el modal base
    abrirModal(button);

    // 2. Capturar datos del botón
    const id = button.getAttribute('data-id');
    const nombre = button.getAttribute('data-nombre');
    const cantidad = button.getAttribute('data-cantidad');
    const costo = button.getAttribute('data-costo');

    // 3. Llenar el formulario (usando IDs específicos de FormInventario.jsp)
    const container = document.getElementById('container-FormInventario');
    if (container) {
        document.getElementById('inv-accion').value = "actualizar";
        document.getElementById('inv-id').value = id;
        document.getElementById('inv-nombre').value = nombre;
        document.getElementById('inv-cantidad').value = cantidad;
        document.getElementById('inv-costo').value = costo;

        document.getElementById('modalInventarioTitulo').innerText = "Actualizar Producto";
    }
}

// Función simple para resetear el modal al registrar nuevo
function abrirModalRegistroInventario(button) {
    abrirModal(button);
    const form = document.getElementById('FormInventario');
    if (form) {
        form.reset();
        document.getElementById('inv-accion').value = "registrar";
        document.getElementById('modalInventarioTitulo').innerText = "Registrar Producto";
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
