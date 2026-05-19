
function verDetalleOrden(id, reporte, diagnostico, observaciones, estado, fecha, empleadoID, empresaID, clienteID) {

    document.getElementById('placeholder-detalle').classList.add('hidden');
    document.getElementById('contenido-detalle').classList.remove('hidden');

    const formattedId = "ORD-" + id.toString().padStart(4, '0');
    document.getElementById('det-id-title').innerText = formattedId;

    document.getElementById('det-fecha-top').innerText = "FECHA DE INGRESO: " + fecha;
    document.getElementById('det-reporte-body').innerText = reporte;

    document.getElementById('det-diagnostico-body').innerText =
    (diagnostico && diagnostico !== 'null' && diagnostico !== '') ? diagnostico : "EL TÉCNICO AÚN NO HA INGRESADO UN DIAGNÓSTICO.";

    document.getElementById('det-obs-body').innerText =
    (observaciones && observaciones !== 'null' && observaciones !== '') ? observaciones : "Sin observaciones adicionales.";

    document.getElementById('estadoP').innerText = estado;

    document.getElementById('tecnico').innerText = empleadoID;

    document.getElementById('idCliente').innerText = clienteID;

    const badge = document.getElementById('det-badge-estado');
    badge.innerText = estado;

    if (estado === 'PENDIENTE') {
    badge.className = "bg-orange-500 text-white px-6 py-2 rounded-full font-black text-sm uppercase self-center shadow-lg";
    } else if (estado === 'TERMINADO' ) {
        badge.className = "bg-green-600 text-white px-6 py-2 rounded-full font-black text-sm uppercase self-center shadow-lg";
    }  else if (estado === 'REVISADO' ) {
        badge.className = "bg-[#FFBA08] text-white px-6 py-2 rounded-full font-black text-sm uppercase self-center shadow-lg";
    } else {
        badge.className = "bg-blue-600 text-white px-6 py-2 rounded-full font-black text-sm uppercase self-center shadow-lg";
    }

    cargarDetallesSuministrosVista(id);
}

function generarFactura(ID) {

    console.log(ID +' | orden')

    Swal.fire({
        title: 'Generando PDF...',
        text: 'Tu factura se descargará en unos segundos',
        timer: 2000,
        showConfirmButton: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    // 5. Llamar al Servlet en una nueva pestaña para descargar el PDF
    // Esto evita que la página actual se recargue o se cierre
    window.open('SvFacturaPDF?id=' + ID, '_blank');
}

function filtrarOrdenes() {
    // 1. Obtener el texto del buscador
    const input = document.getElementById('inputBusqueda');
    const filtro = input.value.toLowerCase();

    // 2. Obtener todas las tarjetas de la columna izquierda
    const tarjetas = document.getElementsByClassName('card-orden');

    // 3. Recorrer y filtrar
    for (let i = 0; i < tarjetas.length; i++) {
        const tarjeta = tarjetas[i];
        const textoTarjeta = tarjeta.innerText.toLowerCase();

        if (textoTarjeta.includes(filtro)) {
            tarjeta.style.display = ""; // Mostrar
            tarjeta.style.opacity = "1";
        } else {
            tarjeta.style.display = "none"; // Ocultar
        }
    }
}

function cargarDetallesSuministrosVista(ordenId) {
    const contenedor = document.getElementById('det-productos-list');

    // Mostramos un spinner limpio mientras carga
    contenedor.innerHTML = `
        <div class="text-center py-4 text-gray-400">
            <i class="fa-solid fa-spinner fa-spin mr-2"></i> Cargando repuestos...
        </div>`;

    fetch(`SvOrdenes?accion=listarSuministros&ordenId=${ordenId}&tipoVista=detalles`)
        .then(res => res.ok ? res.json() : Promise.reject("Error"))
        .then(productos => {
            contenedor.innerHTML = ''; // Limpiar spinner

            if (productos.length === 0) {
                contenedor.innerHTML = `
                    <p class="text-xs text-gray-400 italic text-center py-4">
                        Sin repuestos registrados en esta orden.
                    </p>`;
                return;
            }

            // Inyectamos cada repuesto formateado de manera elegante
            productos.forEach(p => {
                const fila = document.createElement('div');
                fila.className = "flex justify-between items-center bg-gray-50 border-l-4 border-emerald-500 p-2 rounded shadow-sm";
                fila.innerHTML = `
                    <span class="text-xs font-bold text-gray-700 uppercase tracking-tight truncate ">
                        ${p.nombre}
                    </span>
                    <span class="bg-emerald-100 text-emerald-800 text-[11px] font-black px-2 py-0.5 rounded-full uppercase">
                        Cant: ${p.cantidad}
                    </span>
                `;
                contenedor.appendChild(fila);
            });
        })
        .catch(err => {
            console.error("Error al cargar suministros en vista:", err);
            contenedor.innerHTML = '<p class="text-xs text-red-500 text-center py-4">Error al sincronizar suministros.</p>';
        });
}
