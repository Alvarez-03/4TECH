let productosInventarioDisponibles = [];
let pasoActual = 1;
let pasoEdicionActual = 1;
const totalPasos = 3;
const totalPasosEdicion = 2;

document.addEventListener("DOMContentLoaded", () => {
    fetch("SvInventario?format=json")
        .then(res => res.ok ? res.json() : Promise.reject("Error de inventario"))
        .then(data => productosInventarioDisponibles = data)
        .catch(err => console.error("Error Fetch:", err));
});

// --- CONTROL DE PASOS (REGISTRO Y EDICIÓN) ---
function cambiarPaso(direccion) {
    if (direccion === 1) {
        if (pasoActual === 1 && (!document.getElementById('documento_cliente').value.trim() || !document.getElementById('nombre_cliente').value)) {
            return Swal.fire({ icon: 'error', title: 'Cliente no válido', text: 'Verifique que el documento esté registrado.' });
        }
        if (pasoActual === 2 && (!document.getElementById('empleado_id').value || !document.getElementById('reporte').value.trim())) {
            return Swal.fire({ icon: 'warning', title: 'Atención', text: 'Asigne un empleado y escriba el reporte.' });
        }
    }

    document.getElementById(`paso-${pasoActual}`).classList.add('hidden');
    pasoActual = Math.max(1, Math.min(totalPasos, pasoActual + direccion));
    document.getElementById(`paso-${pasoActual}`).classList.remove('hidden');
    actualizarInterfazPasos();
}

function actualizarInterfazPasos() {
    const lineaProgreso = document.getElementById('linea-progreso');
    if (!lineaProgreso) return;

    for (let i = 1; i <= totalPasos; i++) {
        const c = document.getElementById(`circle-step-${i}`);
        if (c) c.className = i <= pasoActual ? "w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold text-sm ring-4 ring-blue-100" : "w-8 h-8 rounded-full bg-gray-200 text-gray-600 flex items-center justify-center font-bold text-sm";
    }

    document.getElementById('btn-back').classList.toggle('hidden', pasoActual === 1);
    document.getElementById('btn-cancelar-modal').classList.toggle('hidden', pasoActual !== 1);
    document.getElementById('btn-next').classList.toggle('hidden', pasoActual === totalPasos);
    document.getElementById('btn-submit-form').classList.toggle('hidden', pasoActual !== totalPasos);
}

function cambiarPasoEdicion(direccion) {
    if (direccion === 1 && pasoEdicionActual === 1 && !document.getElementById('upd-diagnostico').value.trim()) {
        return Swal.fire({
            icon: 'warning',
            title: 'Atención',
            text: 'El diagnóstico técnico es obligatorio.' });
    }

    document.getElementById(`upd-paso-${pasoEdicionActual}`).classList.add('hidden');
    pasoEdicionActual = Math.max(1, Math.min(totalPasosEdicion, pasoEdicionActual + direccion));
    document.getElementById(`upd-paso-${pasoEdicionActual}`).classList.remove('hidden');
    actualizarInterfazEdicion();
}

function actualizarInterfazEdicion() {
    const lineaProgresoUpd = document.getElementById('linea-progreso-upd');
    if (!lineaProgresoUpd) return;

    for (let i = 1; i <= totalPasosEdicion; i++) {
        const c = document.getElementById(`circle-upd-step-${i}`);
        if (c) c.className = i <= pasoEdicionActual ? "w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold text-sm ring-4 ring-blue-100" : "w-8 h-8 rounded-full bg-gray-200 text-gray-600 flex items-center justify-center font-bold text-sm";
    }

    document.getElementById('btn-upd-back').classList.toggle('hidden', pasoEdicionActual === 1);
    document.getElementById('btn-upd-cancelar').classList.toggle('hidden', pasoEdicionActual !== 1);
    document.getElementById('btn-upd-next').classList.toggle('hidden', pasoEdicionActual === totalPasosEdicion);
    document.getElementById('btn-upd-submit').classList.toggle('hidden', pasoEdicionActual !== totalPasosEdicion);
}

// --- GESTIÓN DE FILAS DE PRODUCTOS ---
function generarHTMLFila(idContenedor) {
    let opciones = '<option value="" data-stock="0">-- Seleccione un Repuesto --</option>';
    productosInventarioDisponibles.forEach(p => opciones += `<option value="${p.id}" data-stock="${p.stock}">[Stock: ${p.stock}] ${p.nombre} - $${p.precio}</option>`);

    return `
        <select name="prod_ids[]" required onchange="validarStockFila(this)" class="flex-1 rounded-md border p-1.5 text-sm bg-white outline-none focus:ring-2 focus:ring-blue-500">
            ${opciones}
        </select>
        <input type="number" name="prod_cantidades[]" placeholder="Cant" min="1" value="1" required oninput="validarStockFila(this)" class="w-20 rounded-md border p-1.5 text-sm outline-none focus:ring-2 focus:ring-blue-500">
        <button type="button" onclick="removerFilaProducto(this, '${idContenedor}')" class="text-red-500 px-2 hover:text-red-700 transition"><i class="fa-solid fa-trash"></i></button>
    `;
}

function agregarFilaProducto() {
    const cont = document.getElementById('contenedor-productos-orden');
    if (cont.querySelector('.fa-box-open')) cont.innerHTML = '';
    const div = document.createElement('div');
    div.className = "flex gap-2 items-center bg-gray-50 p-2 rounded-xl border border-gray-200 transition-all";
    div.innerHTML = generarHTMLFila('contenedor-productos-orden');
    cont.appendChild(div);
}

function agregarFilaProductoEdicion() {
    const cont = document.getElementById('contenedor-productos-upd');
    if (cont.querySelector('.fa-spinner') || cont.querySelector('.fa-box-open')) cont.innerHTML = '';
    const div = document.createElement('div');
    div.className = "flex gap-2 items-center bg-gray-50 p-2 rounded-xl border border-gray-200";
    div.innerHTML = generarHTMLFila('contenedor-productos-upd');
    cont.appendChild(div);
}

function removerFilaProducto(boton, idContenedor) {
    const cont = document.getElementById(idContenedor);
    boton.parentElement.remove();
    if (cont.children.length === 0) {
        cont.innerHTML = `<div class="text-center py-6 text-gray-400 bg-gray-50 rounded-xl border border-dashed border-gray-200 w-full"><i class="fa-solid fa-box-open text-3xl mb-2"></i><p class="text-xs font-medium">No se han añadido repuestos todavía.</p></div>`;
    }
}

// --- VALIDACIONES DE DUPLICADOS Y STOCK ---
function validarStockFila(elemento) {
    const fila = elemento.closest('.flex');
    const select = fila.querySelector('select');
    const input = fila.querySelector('input[type="number"]');
    const opcion = select.options[select.selectedIndex];

    // Validación 1: Evitar Duplicados
    if (elemento.tagName.toLowerCase() === 'select' && select.value !== "") {
        const repetido = Array.from(fila.parentElement.querySelectorAll('select')).filter(s => s.value === select.value).length > 1;
        if (repetido) {
            select.value = ""; input.value = 1; input.removeAttribute('max');
            input.classList.remove('border-red-500', 'bg-red-50'); input.removeAttribute('data-has-error');
            return Swal.fire({ icon: 'warning', title: 'Producto ya seleccionado', text: 'Incremente la cantidad en la fila existente.', toast: true, position: 'top-end', showConfirmButton: false, timer: 4000 });
        }
    }

    // Validación 2: Control de Stock Máximo
    const stock = parseInt(opcion.getAttribute('data-stock')) || 0;
    const cant = parseInt(input.value) || 0;
    if (stock > 0) input.setAttribute('max', stock);

    if (cant > stock && stock > 0) {
        input.classList.add('border-red-500', 'ring-2', 'ring-red-200', 'bg-red-50', 'text-red-900');
        input.setAttribute('data-has-error', 'true');
        Swal.fire({ icon: 'warning', title: 'Stock Insuficiente', text: `Solo quedan ${stock} unidades de: ${opcion.text.split('] ')[1]}`, toast: true, position: 'top-end', showConfirmButton: false, timer: 4000 });
    } else {
        input.classList.remove('border-red-500', 'ring-2', 'ring-red-200', 'bg-red-50', 'text-red-900');
        input.removeAttribute('data-has-error');
    }
}

function cargarSuministrosPreviosOrden(ordenId) {
    const contenedor = document.getElementById('contenedor-productos-upd');
    contenedor.innerHTML = `
        <div class="text-center py-6 text-gray-400 bg-gray-50 rounded-xl border border-dashed border-gray-200 w-full">
            <i class="fa-solid fa-spinner fa-spin text-3xl mb-2 text-blue-600"></i>
            <p class="text-xs font-medium">Buscando suministros de la orden...</p>
        </div>
    `;

    fetch(`SvOrdenes?accion=listarSuministros&ordenId=${ordenId}`)
        .then(res => res.ok ? res.json() : Promise.reject("Error leyendo suministros"))
        .then(productosAsignados => {
            contenedor.innerHTML = ''; // Limpiamos el spinner de carga

            if (productosAsignados.length === 0) {
                contenedor.innerHTML = `
                    <div class="text-center py-6 text-gray-400 bg-gray-50 rounded-xl border border-dashed border-gray-200 w-full">
                        <i class="fa-solid fa-box-open text-3xl mb-2"></i>
                        <p class="text-xs font-medium">Esta orden no consumió repuestos previamente.</p>
                    </div>`;
                return;
            }

            // Generamos las filas por cada producto existente
            productosAsignados.forEach(item => {
                agregarFilaProductoPrellenada(item.producto_id, item.cantidad);
            });
        })
        .catch(err => {
            console.error(err);
            contenedor.innerHTML = '<p class="text-xs text-red-500 text-center">Error al sincronizar suministros.</p>';
        });
}

function agregarFilaProductoPrellenada(productoId, cantidad) {
    const cont = document.getElementById('contenedor-productos-upd');
    const div = document.createElement('div');
    div.className = "flex gap-2 items-center bg-gray-50 p-2 rounded-xl border border-gray-200";

    // Generar el HTML base
    div.innerHTML = generarHTMLFila('contenedor-productos-upd');

    // Buscamos los elementos internos recién agregados para pre-llenarlos
    const select = div.querySelector('select');
    const input = div.querySelector('input[type="number"]');

    // Seleccionamos el producto id correcto
    select.value = productoId;

    // Truco de stock: Como el stock físico ya está disminuido en el inventario por esta orden,
    // le sumamos temporalmente al stock de la opción lo que ya tenía la orden asignada.
    const opcionSeleccionada = select.options[select.selectedIndex];
    if (opcionSeleccionada) {
        let stockFisicoActual = parseInt(opcionSeleccionada.getAttribute('data-stock')) || 0;
        let stockDisponibleVerdadero = stockFisicoActual + cantidad;

        // Modificamos los atributos dinámicamente para que la validación no falle
        opcionSeleccionada.setAttribute('data-stock', stockDisponibleVerdadero);
        opcionSeleccionada.text = `[Stock: ${stockDisponibleVerdadero}] ${opcionSeleccionada.text.split('] ')[1]}`;
    }

    // Colocamos la cantidad previa
    input.value = cantidad;
    if (opcionSeleccionada) input.setAttribute('max', opcionSeleccionada.getAttribute('data-stock'));

    cont.appendChild(div);
}

function resetearModalesFlujo() {
    pasoActual = 1; pasoEdicionActual = 1;
    actualizarInterfazPasos(); actualizarInterfazEdicion();

    // Limpiar contenedor de edición de suministros para que no se dupliquen
    const contenedorUpd = document.getElementById('contenedor-productos-upd');
    if(contenedorUpd) {
        contenedorUpd.innerHTML = `
            <div class="text-center py-6 text-gray-400 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                <i class="fa-solid fa-spinner fa-spin text-3xl mb-2 text-primary"></i>
                <p class="text-xs font-medium">Cargando suministros asignados...</p>
            </div>`;
    }

    ['paso-1', 'upd-paso-1'].forEach(id => {
        document.getElementById(id)?.classList.remove('hidden');
    });

    ['paso-2', 'paso-3', 'upd-paso-2'].forEach(id => {
        document.getElementById(id)?.classList.add('hidden');
    });
}