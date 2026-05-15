<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%@ page import="Logica.modelo.Producto" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("titulo", "Inventario");
    String permiso = (String) session.getAttribute("PERMISOS");
%>
<head>
    <link rel="icon" type="image/png" href="IMG/4TECH.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">

    <script src="resources/ControlModal.js"></script>
    <meta charset="utf-8">

    <title>Inventario</title>
    <script src="resources/ControlInventario.js"></script>
</head>
<body>
    <%@include file="Components/header.jsp"%>

    <div class="max-w-7xl mx-auto my-8 px-4">

        <div class="flex flex-col md:flex-row justify-between items-center mb-8 gap-4">
            <div>
                <h1 class="text-3xl font-extrabold text-gray-800">Control de Inventario</h1>
                <p class="text-gray-500 italic">Gestión de repuestos y suministros de la empresa.</p>
            </div>

            <div class="flex flex-1 w-full max-w-xl gap-3">
                <div class="relative flex-1">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </span>
                    <input type="text" id="inputBusqueda" onkeyup="filtrarInventario()"
                           placeholder="Buscar producto por nombre..."
                           class="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-600 outline-none shadow-sm">
                </div>
            </div>

            <% if (permiso.equals("EMPRESA")){%>
                <button onclick="abrirModalRegistroInventario(this)"
                        data-type="FormInventario"
                        class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-xl font-bold shadow-lg transition-all flex items-center gap-2 active:scale-95">
                    <i class="fa-solid fa-box-archive"></i> Nuevo Producto
                </button>
            <%}%>
        </div>

        <%-- TABLA DE PRODUCTOS --%>
        <div class="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-800 text-white">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">ID</th>
                    <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Nombre del Producto</th>
                    <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Cantidad</th>
                    <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Costo Unitario</th>
                    <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Valor Total</th>
                    <% if (permiso.equals("EMPRESA")){%>
                    <th class="px-6 py-4 text-center text-xs font-bold uppercase tracking-wider">Acciones</th>
                    <%}%>
                </tr>
                </thead>
                <tbody id="tablaCuerpoInventario" class="divide-y divide-gray-100">
                <%
                    List<Producto> lista = (List<Producto>) session.getAttribute("listInventario");
                    if (lista != null && !lista.isEmpty()) {
                        for (Producto p : lista) {
                %>
                <tr class="hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">#<%= p.getProducto_id() %></td>
                    <td class="px-6 py-4 whitespace-nowrap font-semibold text-gray-700"><%= p.getNombre() %></td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-3 py-1 rounded-full text-xs font-black shadow-sm
                            <%= p.getCantidad() <= 5 ? "bg-red-100 text-red-700 border border-red-200" : "bg-green-100 text-green-700 border border-green-200" %>">
                            <%= p.getCantidad() %> unidades
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                        $ <%= String.format("%,.2f", p.getCosto()) %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-blue-600">
                        $ <%= String.format("%,.2f", p.getCosto() * p.getCantidad()) %>
                    </td>
                    <%if (permiso.equals("EMPRESA")){%>
                    <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                        <div class="flex justify-center gap-3">
                            <button onclick="abrirModalActualizarInventario(this)"
                                    data-type="FormInventario"
                                    data-id="<%= p.getProducto_id() %>"
                                    data-nombre="<%= p.getNombre() %>"
                                    data-cantidad="<%= p.getCantidad() %>"
                                    data-costo="<%= p.getCosto() %>"
                                    class="text-blue-600 hover:bg-blue-50 p-2 rounded-full transition-all">
                                <i class="fa-solid fa-pen-to-square text-lg"></i>
                            </button>
                            <button onclick="confirmarEliminarProducto(<%= p.getProducto_id() %>)"
                                    class="text-red-600 hover:bg-red-50 p-2 rounded-full transition-all">
                                <i class="fa-solid fa-trash-can text-lg"></i>
                            </button>
                        </div>
                    </td>
                    <%}%>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="px-6 py-20 text-center">
                        <div class="flex flex-col items-center">
                            <i class="fa-solid fa-boxes-stacked text-6xl text-gray-200 mb-4"></i>
                            <span class="text-gray-400 font-medium">No hay productos registrados en el inventario.</span>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <%@include file="Components/modalform.jsp" %>

</body>
</html>
