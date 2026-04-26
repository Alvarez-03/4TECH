
function verDetalleOrden(id, reporte, diagnostico, observaciones, estado, fecha, empleadoID, empresaID) {

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
