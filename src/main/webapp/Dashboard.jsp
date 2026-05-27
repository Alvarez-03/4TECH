<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("titulo", "Panel Analítico - 4TECH");
    String permiso = (String) session.getAttribute("PERMISOS");
    if (permiso == null) {
        response.sendRedirect("loginEmpresarial.jsp");
        return;
    }
%>
<html>
<head>
    <link rel="icon" type="image/png" href="IMG/4TECH.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8">
    <title>4TECH - Dashboard</title>


    <script src="resources/ControlDashoards.js"></script>
</head>
<body class="bg-slate-50 font-['Inter']" data-rol="<%= permiso %>">

<%@include file="Components/header.jsp"%>

<div class="max-w-7xl mx-auto my-8 px-4">
    <% if ("SUPERADMIN".equals(permiso)) { %>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 flex items-center justify-between">
            <div>
                <p class="text-sm font-bold text-gray-400 uppercase tracking-wider">Clientes SaaS Activos</p>
                <h3 id="saas-total-empresas" class="text-4xl font-black text-gray-800 mt-1">0</h3>
            </div>
            <div class="p-4 bg-blue-50 text-blue-600 rounded-2xl text-2xl"><i class="fa-solid fa-building-shield"></i></div>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 flex items-center justify-between">
            <div>
                <p class="text-sm font-bold text-gray-400 uppercase tracking-wider">Estado de Infraestructura</p>
                <h3 class="text-lg font-bold text-green-600 mt-1 flex items-center gap-2">
                    <span class="h-3 w-3 rounded-full bg-green-500 animate-pulse"></span> Operacional
                </h3>
                <p class="text-xs text-gray-400 mt-0.5">Pool de conexiones y base de datos MySQL en línea de forma segura.</p>
            </div>
            <div class="p-4 bg-green-50 text-green-600 rounded-2xl text-2xl"><i class="fa-solid fa-server"></i></div>
        </div>
    </div>
    <div class="max-w-2xl mx-auto bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
        <h4 class="text-md font-bold text-gray-700 mb-4 text-center">Distribución Geográfica de Empresas Registradas</h4>
        <div class="relative h-72"><canvas id="chartCiudades"></canvas></div>
    </div>
    <% } %>

    <% if ("EMPRESA".equals(permiso)) { %>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 flex items-center justify-between">
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider">Valor Capitalizado en Almacén</p>
                <h3 id="emp-inversion" class="text-3xl font-black text-gray-800 mt-1">$ 0.00</h3>
            </div>
            <div class="p-4 bg-emerald-50 text-emerald-600 rounded-2xl text-xl"><i class="fa-solid fa-wallet"></i></div>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 flex items-center justify-between">
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider">Alertas de Desabastecimiento</p>
                <h3 id="emp-criticos" class="text-3xl font-black text-red-600 mt-1">0 <span class="text-sm font-medium text-gray-400">ítems</span></h3>
            </div>
            <div class="p-4 bg-red-50 text-red-600 rounded-2xl text-xl"><i class="fa-solid fa-triangle-exclamation"></i></div>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 flex items-center justify-between">
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider">Proveedores</p>
                <h3 id="emp-proveedores-count" class="text-3xl font-black text-gray-800 mt-1">0</h3>
            </div>
            <div class="p-4 bg-purple-50 text-purple-600 rounded-2xl text-xl"><i class="fa-solid fa-truck-ramp-box"></i></div>
        </div>
    </div>

    <div id="contenedor-tabla-criticos" class="hidden mb-8 bg-white p-6 rounded-2xl shadow-sm border border-red-100">
        <div class="flex items-center gap-2 text-red-600 font-bold mb-4">
            <i class="fa-solid fa-list-check"></i>
            <h4>Componentes con Urgencia de Reabastecimiento</h4>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-gray-600">
                <thead class="bg-red-50 text-red-800 font-semibold uppercase text-xs">
                <tr>
                    <th class="p-3 rounded-l-xl">Nombre del Repuesto</th>
                    <th class="p-3 rounded-r-xl text-center">Unidades Restantes</th>
                </tr>
                </thead>
                <tbody id="tabla-criticos-body">
                </tbody>
            </table>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
            <h4 class="text-sm font-bold text-gray-700 mb-4 uppercase tracking-wider text-center"><i class="fa-solid fa-layer-group text-blue-500 mr-1"></i> Top 5 Repuestos Más Costosos</h4>
            <div class="relative h-64"><canvas id="chartTopProductos"></canvas></div>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
            <h4 class="text-sm font-bold text-gray-700 mb-4 uppercase tracking-wider text-center"><i class="fa-solid fa-screwdriver-wrench text-amber-500 mr-1"></i> Estado de Órdenes de Servicio</h4>
            <div class="relative h-64"><canvas id="chartOrdenesEstado"></canvas></div>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
            <h4 class="text-sm font-bold text-gray-700 mb-4 uppercase tracking-wider text-center"><i class="fa-solid fa-chart-pie text-purple-500 mr-1"></i> Densidad de Artículos por Proveedor</h4>
            <div class="relative h-64"><canvas id="chartItemsProveedor"></canvas></div>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
            <h4 class="text-sm font-bold text-gray-700 mb-4 uppercase tracking-wider text-center"><i class="fa-solid fa-users text-indigo-500 mr-1"></i> Productividad Global del Equipo Técnico</h4>
            <div class="relative h-64"><canvas id="chartRendimientoEmpresa"></canvas></div>
        </div>
    </div>
    <% } %>

    <% if ("EMPLEADO".equals(permiso)) { %>
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
            <h4 class="text-sm font-bold text-gray-700 mb-4 uppercase tracking-wider text-center"><i class="fa-solid fa-user-gear text-blue-500 mr-1"></i> Resumen de Mis Órdenes Asignadas</h4>
            <div class="relative h-64"><canvas id="chartMisOrdenes"></canvas></div>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
            <h4 class="text-sm font-bold text-gray-700 mb-4 uppercase tracking-wider text-center"><i class="fa-solid fa-users text-indigo-500 mr-1"></i> Productividad Global del Equipo Técnico</h4>
            <div class="relative h-64"><canvas id="chartRendimientoEquipo"></canvas></div>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>