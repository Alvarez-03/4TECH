<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
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
                        'gray-ebony': '#515751',
                    }
                }
            }
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<%
    String PERMISOS = (session.getAttribute("PERMISOS") != null)
            ? (String) session.getAttribute("PERMISOS")
            : "EMPRESA";
%>

<div class="w-full min-h-screen bg-gray-50/50 flex flex-col justify-start items-center py-8 px-4 sm:py-12">
    <main class="w-full max-w-5xl mx-auto flex justify-center">

        <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 w-full justify-center justify-items-center">

            <% if (PERMISOS.equals("SUPERADMIN")) { %>
            <button onclick="abrirModal(this)" data-type="FormRegisterEmp"
                    class="group bg-white border border-gray-100 p-6 sm:p-8 flex flex-col items-center justify-center aspect-square w-full max-w-sm text-gray-800 font-bold rounded-3xl shadow-md hover:shadow-xl hover:-translate-y-2 transition-all duration-300">
                <div class="p-5 rounded-2xl bg-blue-50 text-primary mb-5 group-hover:scale-110 transition-transform duration-300">
                    <i class="fa-solid fa-building-circle-arrow-right text-6xl sm:text-7xl"></i>
                </div>
                <span class="text-lg sm:text-xl text-center tracking-tight">Registrar empresa</span>
            </button>

            <a href="SvEmpresas" data-type="AdminEmp"
               class="group bg-white border border-gray-100 p-6 sm:p-8 flex flex-col items-center justify-center aspect-square w-full max-w-sm text-gray-800 font-bold rounded-3xl shadow-md hover:shadow-xl hover:-translate-y-2 transition-all duration-300">
                <div class="p-5 rounded-2xl bg-purple-50 text-purple-600 mb-5 group-hover:scale-110 transition-transform duration-300">
                    <i class="fa-solid fa-building-circle-exclamation text-6xl sm:text-7xl"></i>
                </div>
                <span class="text-lg sm:text-xl text-center tracking-tight">Administrar empresas</span>
            </a>
            <% } %>

            <% if (PERMISOS.equals("EMPLEADO") || PERMISOS.equals("EMPRESA")) { %>
            <a href="Orders.jsp"
               class="group bg-white border border-gray-100 p-6 sm:p-8 flex flex-col items-center justify-center aspect-square w-full max-w-sm text-gray-800 font-bold rounded-3xl shadow-md hover:shadow-xl hover:-translate-y-2 transition-all duration-300">
                <div class="p-5 rounded-2xl bg-blue-50 text-primary mb-5 group-hover:scale-110 transition-transform duration-300">
                    <i class="fa-solid fa-receipt text-6xl sm:text-7xl"></i>
                </div>
                <span class="text-lg sm:text-xl text-center tracking-tight">Órdenes</span>
            </a>

            <a href="SvInventario"
               class="group bg-white border border-gray-100 p-6 sm:p-8 flex flex-col items-center justify-center aspect-square w-full max-w-sm text-gray-800 font-bold rounded-3xl shadow-md hover:shadow-xl hover:-translate-y-2 transition-all duration-300">
                <div class="p-5 rounded-2xl bg-purple-50 text-purple-600 mb-5 group-hover:scale-110 transition-transform duration-300">
                    <i class="fa-solid fa-boxes-stacked text-6xl sm:text-7xl"></i>
                </div>
                <span class="text-lg sm:text-xl text-center tracking-tight">Inventario</span>
            </a>
            <% } %>

            <% if (PERMISOS.equals("EMPRESA") || PERMISOS.equals("SUPERADMIN")) { %>
            <a href="SvEmpleados"
               class="group bg-white border border-gray-100 p-6 sm:p-8 flex flex-col items-center justify-center aspect-square w-full max-w-sm text-gray-800 font-bold rounded-3xl shadow-md hover:shadow-xl hover:-translate-y-2 transition-all duration-300">
                <div class="p-5 rounded-2xl bg-amber-50 text-amber-600 mb-5 group-hover:scale-110 transition-transform duration-300">
                    <i class="fa-solid fa-users-gear text-6xl sm:text-7xl"></i>
                </div>
                <span class="text-lg sm:text-xl text-center tracking-tight">Administrar trabajadores</span>
            </a>
            <% } %>

            <a href="Dashboard.jsp"
               class="group bg-white border border-gray-100 p-6 sm:p-8 flex flex-col items-center justify-center aspect-square w-full max-w-sm text-gray-800 font-bold rounded-3xl shadow-md hover:shadow-xl hover:-translate-y-2 transition-all duration-300">
                <div class="p-5 rounded-2xl bg-emerald-50 text-emerald-600 mb-5 group-hover:scale-110 transition-transform duration-300">
                    <i class="fa-solid fa-chart-pie text-6xl sm:text-7xl"></i>
                </div>
                <span class="text-lg sm:text-xl text-center tracking-tight">Dashboard Analítico</span>
            </a>

        </section>
    </main>
</div>