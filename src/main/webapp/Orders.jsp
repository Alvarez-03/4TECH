<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Logica.modelo.OrdenServicio" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <link rel="icon" type="image/png" href="IMG/4TECH.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">

    <script src="resources/ControlModal.js"></script>

    <meta charset="utf-8">
    <title>ORDENES DE SERVICIO</title>
    <%
        if (session.getAttribute("listaOrdenes") == null && session.getAttribute("usuarioLogueado") != null) {
            response.sendRedirect("SvOrdenes");
            return;
        }
    %>
</head>
<body>
    <%@include file="/Components/header.jsp" %>
    <%@include file="Components/modalform.jsp" %>
    <section class="mx-4 mt-3">
        <%@include file="/Components/actionBar.jsp" %>
    </section>

    <main class="flex flex-col justify-center gap-5 md:flex-row w-full h-screen mb-3">
        <section class="rounded-xl bg-gray-900 md:w-[30%] p-3 overflow-y-auto h-full">
            <div class="flex flex-col gap-3">
                <%
                    List<OrdenServicio> listaOrd = (List<OrdenServicio>) session.getAttribute("listaOrdenes");
                    if (listaOrd != null && !listaOrd.isEmpty()) {
                        for (OrdenServicio ord : listaOrd) {
                %>
                <div onclick="verDetalleOrden(
                    '<%= ord.getIDorden() %>',
                    '<%= ord.getReporte() %>',
                    '<%= ord.getDiagnostico()%>',
                    '<%= ord.getObservaciones()%>',
                    '<%= ord.getEstado_actual() %>',
                    '<%= ord.getFecha_ingreso() %>',
                    '<%= ord.getEmpleado_id() %>',
                    '<%= ord.getEmpresa_id() %>'
                    )" class="bg-white rounded-2xl p-4 shadow-sm cursor-pointer hover:shadow-md border border-gray-100 relative group">

                    <div class="flex justify-between items-start">
                        <span class="text-blue-700 font-black text-lg">ORD-<%= String.format("%04d", ord.getIDorden()) %></span>

                        <span class="bg-blue-600 text-white text-[10px] px-4 py-1.5 rounded-full font-bold uppercase tracking-wider">
                    <%= ord.getEstado_actual() %>
                </span>
                    </div>

                    <div class="mt-2 pr-8">
                        <p class="text-gray-500 font-bold text-base truncate">
                            <%= ord.getReporte() %>
                        </p>
                        <p class="text-gray-400 text-xs font-bold mt-1 uppercase tracking-tighter">
                            FECHA | <%= ord.getFecha_ingreso() %>
                        </p>
                    </div>

                    <div class="absolute right-4 top-1/2 -translate-y-1/2 mt-2">
                        <i class="fa-solid fa-chevron-right text-black text-xl group-hover:translate-x-1 transition-transform"></i>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="flex flex-col items-center justify-center h-64 text-gray-400">
                    <i class="fa-solid fa-folder-open text-5xl mb-4 opacity-20"></i>
                    <p class="text-sm font-medium">No hay órdenes registradas</p>
                </div>
                <% } %>
            </div>
        </section>

        <section class="rounded-xl bg-gray-900 md:w-[65%] p-6 overflow-y-auto">
            <div id="placeholder-detalle" class="flex flex-col items-center justify-center h-full text-gray-500">
                <i class="fa-solid fa-file-invoice text-7xl mb-4 opacity-20"></i>
                <h2 class="text-xl font-bold">Selecciona una orden</h2>
            </div>

            <div id="contenido-detalle" class="hidden">
                <div class="flex justify-between items-center mb-6">
                    <div class="flex items-center gap-4">
                        <h2 id="det-id-title" class="text-blue-500 text-3xl font-black italic">APP-0000</h2>
                        <div class="text-white">
                            <p class="font-bold text-lg leading-tight uppercase">ORDEN DE SERVICIO</p>
                            <p id="det-fecha-top" class="text-xs text-gray-400 font-bold tracking-widest"></p>
                        </div>
                    </div>
                    <div class="flex gap-3">
                        <span id="det-badge-estado" class="bg-blue-600 text-white px-6 py-2 rounded-full font-black text-sm uppercase self-center"></span>
                        <button class="bg-red-600 hover:bg-red-700 text-white px-8 py-2 rounded-lg font-black text-sm uppercase transition-colors shadow-lg">Factura</button>
                    </div>
                </div>

                <hr class="border-blue-500 border-1 mb-6 opacity-50">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                    <div class="md:col-span-2">
                        <div class="bg-white rounded-xl p-4 min-h-[120px] shadow-inner">
                            <h4 class="text-blue-700 font-black text-lg uppercase mb-2 tracking-tighter">REPORTE</h4>
                            <p id="det-reporte-body" class="text-gray-700 font-bold text-sm leading-relaxed"></p>
                        </div>
                    </div>

                    <div class="bg-white rounded-xl p-4 min-h-[180px] shadow-inner">
                        <h4 class="text-blue-700 font-black text-lg uppercase mb-2 tracking-tighter">Diagnóstico</h4>
                        <p id="det-diagnostico-body" class="text-gray-600 font-bold text-sm leading-relaxed"></p>
                    </div>

                    <div class="flex flex-col gap-4">
                        <div class="flex flex-col gap-1">
                            <label class="text-white font-black text-sm uppercase italic">Tecnico asignado:</label>
                            <div class="w-full bg-white text-gray-800 font-bold p-2 rounded border-l-4 border-blue-500 focus:outline-none">
                                <p id="tecnico" class="text-gray-800 font-black text-sm uppercase italic"></p>
                            </div>
                        </div>

                        <div class="flex flex-col gap-1">
                            <label class="text-white font-black text-sm uppercase italic">Estado:</label>
                            <div class="w-full bg-white text-gray-800 font-bold p-2 rounded border-l-4 border-blue-500 focus:outline-none">
                                <p id="estadoP" class="text-gray-800 font-black text-sm uppercase italic"></p>
                            </div>
                        </div>

                        <div class="bg-white rounded-xl p-3 min-h-[80px] shadow-inner mt-2">
                            <h4 class="text-blue-700 font-black text-lg uppercase mb-1 tracking-tighter">Observaciones</h4>
                            <p id="det-obs-body" class="text-gray-600 font-bold text-xs"></p>
                        </div>
                    </div>

                </div>
            </div>
        </section>
    </main>

    <script>
        function verDetalleOrden(id, reporte, diagnostico, observaciones, estado, fecha, empleadoID, empresaID) {

            document.getElementById('placeholder-detalle').classList.add('hidden');
            document.getElementById('contenido-detalle').classList.remove('hidden');

            const formattedId = "APP-" + id.toString().padStart(4, '0');
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
            } else if (estado === 'TERMINADO' || estado === 'ENTREGADO') {
                badge.className = "bg-green-600 text-white px-6 py-2 rounded-full font-black text-sm uppercase self-center shadow-lg";
            } else {
                badge.className = "bg-blue-600 text-white px-6 py-2 rounded-full font-black text-sm uppercase self-center shadow-lg";
            }
        }
    </script>

</body>
</html>
