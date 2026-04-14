<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="resources/ControlsButton.js"></script>
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<%
    String PERMISOS_SUBMENU= (session.getAttribute("PERMISOS") != null)
            ? (String)session.getAttribute("PERMISOS")
            : "EMPRESA";
%>
    <aside id="sidebar" class="fixed top-0 left-0 h-full w-64 bg-white shadow-2xl z-50 transform -translate-x-full transition-transform duration-300 ease-in-out">
        <div class="p-6">
            <div class="flex items-center justify-between mb-8">
                <img src="IMG/4TECH.png" alt="logo4TECH" class="h-20 w-20 object-contain">
                <button onclick="toggleMenu()" class="text-gray-500 hover:text-secondary">
                    <i class="fa-solid fa-xmark text-2xl"></i>
                </button>
            </div>

            <nav class="space-y-4">
                <% if (PERMISOS_SUBMENU.equals("SUPERADMIN")) {%>
                    <button onclick="abrirModal(this)" data-type="FormRegisterEmp" class="flex items-center gap-3 p-3 text-gray-ebony hover:bg-gray-100 rounded-lg transition-colors font-medium">
                        <i class="fa-solid fa-building-circle-arrow-right"></i> Registrar empresa
                    </button>
                    <a href="SvEmpleados" class="flex items-center gap-3 p-3 text-gray-ebony hover:bg-gray-100 rounded-lg transition-colors font-medium">
                        <i class="fa-solid fa-users-gear"></i> Administra trabajadores
                    </a>
                    <a href="SvUsuarios" data-type="AdminEmp"  class="flex items-center gap-3 p-3 text-gray-ebony hover:bg-gray-100 rounded-lg transition-colors font-medium">
                        <i class="fa-solid fa-building-circle-exclamation"></i> Administrar empresas
                    </a>
                <%} else{%>
                    <a href="DashboardSA.jsp" class="flex items-center gap-3 p-3 text-gray-ebony hover:bg-gray-100 rounded-lg transition-colors font-medium">
                        <i class="fa-solid fa-receipt"></i>Ordenes
                    </a>
                    <a href="DashboardSA.jsp" class="flex items-center gap-3 p-3 text-gray-ebony hover:bg-gray-100 rounded-lg transition-colors font-medium">
                        <i class="fa-solid fa-boxes-stacked"></i> Inventario
                    </a>
                    <a href="perfil.jsp" class="flex items-center gap-3 p-3 text-gray-ebony hover:bg-gray-100 rounded-lg transition-colors font-medium">
                        <i class="fa-solid fa-users-gear"></i> Recursos humanos
                    </a>
                <%}%>
                <a href="DashboardSA.jsp" class="flex items-center gap-3 p-3 text-gray-ebony hover:bg-gray-100 rounded-lg transition-colors font-medium">
                    <i class="fa-solid fa-house"></i> Dashboard
                </a>
                <hr class="border-gray-100">
                <button onclick="CerrarSesion()" class="w-full flex items-center gap-3 p-3 text-secondary hover:bg-red-50 rounded-lg transition-colors font-bold uppercase text-xs">
                    <i class="fa-solid fa-arrow-right-from-bracket mx-1"></i> Cerrar Sesión
                </button>
            </nav>
        </div>
    </aside>
