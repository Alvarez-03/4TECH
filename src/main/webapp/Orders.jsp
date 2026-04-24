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
    <script src="resources/ControlOrders.js"></script>

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
                <div class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-all relative">

                    <div class="flex justify-between items-center mb-2">
                        <span class="text-blue-700 font-black text-xl italic tracking-tighter">
                            ORD-<%= String.format("%04d", ord.getIDorden()) %>
                        </span>

                        <div class="flex items-center gap-2">
                            <%-- Badge de Estado --%>
                            <span class="bg-blue-600 text-white text-base italic px-3 py-1 rounded-full font-bold uppercase">
                                <%= ord.getEstado_actual() %>
                            </span>

                            <%-- Botón de Editar (Al lado del estado) --%>
                            <button data-type="UpdOrd"
                                    data-id="<%= ord.getIDorden() %>"
                                    data-reporte="<%= ord.getReporte().replace("\"", "&quot;") %>"
                                    data-diagnostico="<%= ord.getDiagnostico() != null ? ord.getDiagnostico().replace("\"", "&quot;") : "" %>"
                                    data-observaciones="<%= ord.getObservaciones() != null ? ord.getObservaciones().replace("\"", "&quot;") : "" %>"
                                    data-estado="<%= ord.getEstado_actual() %>"
                                    data-empleado="<%= ord.getEmpleado_id() %>"
                                    onclick="abrirModalActualizarOrden(this)"
                                    class="p-1.5 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors border border-transparent hover:border-blue-100"
                                    title="Editar Orden">
                                <i class="fa-solid fa-pen-to-square text-lg"></i>
                            </button>
                        </div>
                    </div>

                    <div onclick="verDetalleOrden(
                            '<%= ord.getIDorden() %>',
                            '<%= ord.getReporte().replace("'", "\\'").replace("\n", " ").replace("\r", " ") %>',
                            '<%= ord.getDiagnostico() != null ? ord.getDiagnostico().replace("'", "\\'").replace("\n", " ").replace("\r", " ") : "" %>',
                            '<%= ord.getObservaciones() != null ? ord.getObservaciones().replace("'", "\\'").replace("\n", " ").replace("\r", " ") : "" %>',
                            '<%= ord.getEstado_actual() %>',
                            '<%= ord.getFecha_ingreso() %>',
                            '<%= ord.getEmpleado_id() %>',
                            '<%= ord.getEmpresa_id() %>'
                            )" class="cursor-pointer">

                        <div class="pr-6">
                            <p class="text-gray-600 font-bold text-sm truncate">
                                <%= ord.getReporte() %>
                            </p>
                            <div class="flex justify-between items-center mt-2">
                                <p class="text-gray-400 text-[10px] font-black uppercase tracking-tighter">
                                    <i class="fa-regular fa-calendar-days mr-1"></i><%= ord.getFecha_ingreso() %>
                                </p>
                                <i class="fa-solid fa-chevron-right text-gray-300 text-xs"></i>
                            </div>
                        </div>
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
                        <div class="flex bg-gray-800 p-1 rounded-xl border border-gray-700 shadow-inner">
                            <button class="bg-red-600 hover:bg-red-700 text-white px-8 py-2 rounded-lg font-black text-sm uppercase transition-colors shadow-lg">Factura</button>
                        </div>
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


</body>
</html>
