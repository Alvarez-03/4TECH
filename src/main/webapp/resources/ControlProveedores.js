/**
 * ControlProveedores.js - Lógica asíncrona para el CRUD de proveedores en 4TECH
 */

// 1. Abrir y cargar el listado de proveedores
function abrirModalProveedores() {
    document.getElementById('modalListadoProveedores').classList.remove('hidden');
    cargarProveedoresTabla();
}

function cerrarModalProveedores() {
    document.getElementById('modalListadoProveedores').classList.add('hidden');
}

// 2. Consumir el formato JSON del Servlet para pintar la tabla al vuelo
function cargarProveedoresTabla() {
    const tbody = document.getElementById('tablaCuerpoProveedores');
    tbody.innerHTML = `<tr><td colspan="4" class="text-center py-8 text-gray-400"><i class="fa-solid fa-circle-notch animate-spin text-2xl mr-2"></i> Cargando...</td></tr>`;

    fetch('SvProveedores?format=json')
        .then(response => response.json())
        .then(data => {
            tbody.innerHTML = '';
            if (data.length === 0) {
                tbody.innerHTML = `<tr><td colspan="4" class="text-center py-10 text-gray-400"><i class="fa-solid fa-folder-open text-4xl mb-2 block"></i> No tienes proveedores registrados.</td></tr>`;
                return;
            }

            data.forEach(p => {
                const fila = document.createElement('tr');
                fila.className = "hover:bg-gray-50 transition-colors border-b border-gray-100";
                fila.innerHTML = `
                    <td class="px-4 py-3 font-semibold text-gray-800">${p.nombreEmpresa}</td>
                    <td class="px-4 py-3 text-gray-600">${p.contacto || '<span class="italic text-gray-400">Sin asignar</span>'}</td>
                    <td class="px-4 py-3 text-gray-700 font-medium"><i class="fa-brands fa-whatsapp text-green-500 mr-1"></i> ${p.telefono}</td>
                    <td class="px-4 py-3 text-center">
                        <div class="flex justify-center gap-2">
                            <button onclick="prepararEdicionProveedor(${p.id}, '${escapeHtml(p.nombreEmpresa)}', '${escapeHtml(p.contacto)}', '${p.telefono}')" 
                                    class="text-blue-600 hover:bg-blue-50 p-2 rounded-full transition-all" title="Editar">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </button>
                            <button onclick="confirmarEliminarProveedor(${p.id})" 
                                    class="text-red-600 hover:bg-red-50 p-2 rounded-full transition-all" title="Eliminar">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </div>
                    </td>
                `;
                tbody.appendChild(fila);
            });
        })
        .catch(error => {
            console.error("Error al cargar proveedores:", error);
            tbody.innerHTML = `<tr><td colspan="4" class="text-center py-8 text-red-500 font-bold">Error al conectar con el servidor</td></tr>`;
        });
}

// 3. Controlar el Sub-Modal del formulario (Para Registrar o Editar)
function abrirFormularioProveedor(tipo) {
    document.getElementById('modalFormProveedor').classList.remove('hidden');
    if(tipo === 'registrar') {
        document.getElementById('tituloFormProveedor').innerText = "Registrar Nuevo Proveedor";
        document.getElementById('formProveedorElemento').reset();
        document.getElementById('prov_accion').value = "registrar";
        document.getElementById('prov_id').value = "";
    }
}

function cerrarFormularioProveedor() {
    document.getElementById('modalFormProveedor').classList.add('hidden');
}

// 4. Preparar campos para actualizar
function evaluarCamposEdicion(id, nombre, contacto, telefono) {
    document.getElementById('tituloFormProveedor').innerText = "Modificar Proveedor";
    document.getElementById('prov_accion').value = "actualizar";
    document.getElementById('prov_id').value = id;
    document.getElementById('prov_nombre').value = nombre;
    document.getElementById('prov_contacto').value = contacto === "null" ? "" : contacto;
    document.getElementById('prov_telefono').value = telefono;
    document.getElementById('modalFormProveedor').classList.remove('hidden');
}

function prepararEdicionProveedor(id, nombre, contacto, telefono) {
    evaluarCamposEdicion(id, nombre, contacto, telefono);
}

// 5. Enviar la petición POST al servlet (Registrar o Actualizar) por AJAX
function guardarProveedor(event) {
    event.preventDefault();
    const form = document.getElementById('formProveedorElemento');
    const formData = new URLSearchParams(new FormData(form));

    fetch('SvProveedores', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: formData.toString()
    })
        .then(async response => {
            const txt = await response.text();
            if(response.ok) {
                Swal.fire({ icon: 'success', title: '¡Hecho!', text: txt, timer: 2000, showConfirmButton: false });
                cerrarFormularioProveedor();
                cargarProveedoresTabla(); // Refresca el listado del modal
            } else {
                Swal.fire({ icon: 'error', title: 'Error', text: txt || 'No se pudo procesar la solicitud' });
            }
        })
        .catch(err => {
            Swal.fire({ icon: 'error', title: 'Fallo crítico', text: 'Error de red al intentar guardar.' });
        });
}

// 6. Eliminar un Proveedor usando SweetAlert2
function confirmarEliminarProveedor(id) {
    Swal.fire({
        title: '¿Estás seguro?',
        text: "Al borrar el proveedor, los productos que le pertenecen quedarán sin distribuidor.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#6b7280',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch(`SvProveedores?accion=eliminar&IDproveedor=${id}`, { method: 'POST' })
                .then(async response => {
                    const txt = await response.text();
                    if(response.ok) {
                        Swal.fire({ icon: 'success', title: 'Eliminado', text: txt, timer: 1500, showConfirmButton: false });
                        cargarProveedoresTabla();
                    } else {
                        Swal.fire({ icon: 'error', title: 'Error', text: txt });
                    }
                })
                .catch(() => Swal.fire({ icon: 'error', title: 'Error', text: 'No se pudo comunicar con el servidor' }));
        }
    });
}

// Función auxiliar para evitar rupturas de cadenas en atributos HTML de los botones
function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
}