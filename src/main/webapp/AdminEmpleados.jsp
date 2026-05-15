<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Logica.modelo.Empleado" %>
<%@ page import="Logica.modelo.Empresa" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // 1. Recuperamos datos de sesión para lógica de visualización
    Empresa empLogueada = (Empresa) session.getAttribute("usuarioLogueado");
    String PERMISOS_emp = (session.getAttribute("PERMISOS") != null)
            ? (String) session.getAttribute("PERMISOS")
            : "EMPRESA";

    // 2. Título dinámico
    String EMPRESA_NOM = (session.getAttribute("EMPRESA") != null)
            ? (String)session.getAttribute("EMPRESA")
            : "4TECH";

    request.setAttribute("titulo", "Empleados - " + EMPRESA_NOM);

    // 3. ID de empresa para el botón de registro (si es SuperAdmin será 0 o manejado por modal)
    int idEmpresaParaRegistro = (empLogueada != null) ? empLogueada.getID() : 0;
%>

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
    <script src="resources/ControlAdminEmpleado.js"></script>

    <meta charset="utf-8">
    <title>Administrar empleados | 4TECH</title>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'ui-sans-serif', 'system-ui'],
                    },
                    colors: {
                        'primary': '#1d4ed8',
                        'secondary': '#EF2917',
                        'accent': '#FFBA08',
                        'gray-ebony':'#515751',
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50">

<%@include file="Components/header.jsp"%>

<div class="max-w-7xl mx-auto my-8 px-4">
    
    <div class="flex justify-between items-center mb-8">
        <div class="j">
            <h1 class="text-3xl font-extrabold text-gray-800">Panel de Empleados</h1>
            <% if (PERMISOS_emp.equals("SUPERADMIN")) { %>
            <p class="text-gray-500 mt-1 italic">Visualizando personal de: <strong><%= EMPRESA_NOM %></strong></p>
            <% } %>
        </div>

        <div class="flex flex-1 w-full max-w-2xl gap-3">
            <div class="relative flex-1">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                    <i class="fa-solid fa-magnifying-glass w-5 h-5 text-gray-400"></i>
                </span>
                <input
                        type="text"
                        id="inputBusqueda"
                        onkeyup="filtrarEmpleados()"
                        placeholder="Buscar por nombre, rol, correo o teléfono..."
                        class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-xl leading-5 bg-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary sm:text-sm shadow-sm"
                >
            </div>
        </div>

        <button
                onclick="abrirModal(this)"
                data-type="FormRegisterWork"
                data-empresa-id="<%= idEmpresaParaRegistro %>"
                class="bg-secondary hover:bg-secondary/80 text-white px-6 py-3 rounded-xl font-bold shadow-lg transition-all flex items-center gap-2 active:scale-95">
            <i class="fa-solid fa-user-plus"></i> Registrar Empleado
        </button>
    </div>

    <%-- TABLA DE EMPLEADOS --%>
    <div class="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-800 text-white">
            <tr>
                <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Nombre del Empleado</th>
                <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Cargo / Rol</th>
                <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Correo</th>
                <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Teléfono</th>
                <th class="px-6 py-4 text-left text-xs font-bold uppercase tracking-wider">Estado</th>
                <th class="px-6 py-4 text-center text-xs font-bold uppercase tracking-wider">Acciones</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-100" id="tablaEmpleados">
            <%
                List<Empleado> lista = (List<Empleado>) session.getAttribute("listEmpleados");
                if (lista != null && !lista.isEmpty()) {
                    for (Empleado emp : lista) {
            %>
            <tr class="hover:bg-gray-50 transition-colors">
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                        <div class="h-9 w-9 rounded-full bg-indigo-600 flex items-center justify-center text-white text-sm font-bold shadow-sm">
                            <%= (emp.getNombre() != null && !emp.getNombre().isEmpty()) ? emp.getNombre().substring(0,1).toUpperCase() : "?" %>
                        </div>
                        <span class="ml-3 font-semibold text-gray-700"><%= emp.getNombre() %></span>
                    </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                            <span class="text-sm text-gray-600 bg-gray-100 px-2 py-1 rounded-md font-medium border border-gray-200">
                                <%= emp.getCargo() %>
                            </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 italic">
                    <%= emp.getEmail() %>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                    <%= emp.getTelefono() %>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                            <span class="px-3 py-1 text-xs font-black rounded-full shadow-sm
                                <%= "ACTIVO".equalsIgnoreCase(emp.getEstado()) ? "bg-green-100 text-green-700 border border-green-200" : "bg-red-100 text-red-700 border border-red-200" %>">
                                <%= emp.getEstado() %>
                            </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-center">
                    <div class="flex justify-center items-center gap-2">
                        <button onclick="abrirModalActualizarTrabajador(this)"
                                data-type="UpdWork"
                                data-id="<%= emp.getID() %>"
                                data-nombre="<%= emp.getNombre() %>"
                                data-cargo="<%= emp.getCargo() %>"
                                data-email="<%= emp.getEmail() %>"
                                data-telefono="<%= emp.getTelefono() %>"
                                data-empresa-id="<%= emp.getEmpresa_id() %>"
                                class="p-2 text-blue-600 hover:bg-blue-50 rounded-full transition-all"
                                title="Editar Datos">
                            <i class="fa-solid fa-pen-to-square text-lg"></i>
                        </button>

                        <button onclick="confirmarCambioEstado(<%= emp.getID() %>, '<%= emp.getEstado() %>')"
                                class="p-2 <%= "ACTIVO".equalsIgnoreCase(emp.getEstado()) ? "text-orange-500 hover:bg-orange-50" : "text-green-500 hover:bg-green-50" %> rounded-full transition-all"
                                title="<%= "ACTIVO".equalsIgnoreCase(emp.getEstado()) ? "Desactivar Cuenta" : "Activar Cuenta" %>">
                            <i class="fa-solid <%= "ACTIVO".equalsIgnoreCase(emp.getEstado()) ? "fa-user-lock" : "fa-user-check" %> text-lg"></i>
                        </button>
                    </div>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="6" class="px-6 py-20 text-center">
                    <div class="flex flex-col items-center">
                        <i class="fa-solid fa-user-group text-6xl text-gray-200 mb-4"></i>
                        <span class="text-gray-400 font-medium">No hay trabajadores en la lista para mostrar.</span>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@include file="/Components/modalform.jsp" %>

</body>
</html>