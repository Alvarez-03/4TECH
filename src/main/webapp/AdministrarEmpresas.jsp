<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="icon" type="image/png" href="IMG/4TECH.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <script src="resources/ControlModal.js"></script>

    <meta charset="utf-8">
    <title>Administrar empresas | 4TECH</title>
</head>
<body>
    <%
        String PERMISOS_DASH= (session.getAttribute("PERMISOS") != null)
                ? (String)session.getAttribute("PERMISOS")
                : "EMPRESA";

        if (PERMISOS_DASH.equals("SUPERADMIN")) {
            request.setAttribute("titulo", "Dashboard Super Admin");
        } else{
            String EMPRESA = (session.getAttribute("EMPRESA") != null)
                    ? (String)session.getAttribute("EMPRESA")
                    : "4TECH";
            request.setAttribute("titulo", EMPRESA);
        }
    %>
    <%@ page import="Logica.Empresa" %>
    <%@ page import="java.util.List" %>
    <%@include file="/Components/header.jsp" %>
    <div class="max-w-6xl mx-auto my-4">
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-3xl font-bold text-gray-800">Gestión de Empresas</h1>
            </div>
        </div>

        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-primary text-white">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider">Siglas</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider">Nombre</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider">Email</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider">Ciudad</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider">Estado</th>
                    <th class="px-6 py-4 text-center text-xs font-semibold uppercase tracking-wider">Acciones</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                <%
                    List<Empresa> lista = (List<Empresa>) session.getAttribute("listEmpresa");
                    if (lista != null && !lista.isEmpty()) {
                        for (Empresa emp : lista) {
                %>
                <tr class="hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 whitespace-nowrap font-bold text-primary"><%= emp.getSiglas() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-gray-700"><%= emp.getNombre() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-gray-600 italic"><%= emp.getEmail() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-gray-700"><%= emp.getCiudad() %></td>
                    <td class="px-6 py-4 whitespace-nowrap">
                            <span class="px-3 py-1 text-xs font-bold rounded-full
                                <%= emp.getEstado().equals("ACTIVO") ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700" %>">
                                <%= emp.getEstado() %>
                            </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                        <button
                                onclick="abrirModalEditar(this)"
                                data-type="UpdEmp"
                                data-email="<%= emp.getEmail() %>"
                                data-nombre="<%= emp.getNombre() %>"
                                data-siglas="<%= emp.getSiglas() %>"
                                data-telefono="<%= emp.getTelefono() %>"
                                data-ciudad="<%= emp.getCiudad() %>"
                                data-direccion="<%= emp.getDireccion() %>"
                                data-estado="<%= emp.getEstado() %>"
                                class="text-blue-600 hover:text-blue-900 mx-2">
                            <i class="fa-solid fa-pen-to-square text-lg"></i>
                        </button>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="px-6 py-10 text-center text-gray-500">
                        <i class="fa-solid fa-circle-exclamation text-4xl mb-3 block"></i>
                        No hay empresas registradas o la sesión ha expirado.
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
<%@include file="Components/modalform.jsp" %>
</html>
