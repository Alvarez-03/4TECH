<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulta de Servicios - 4TECH</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 font-sans min-h-screen flex flex-col justify-between">

<nav class="bg-blue-700 text-white shadow-md px-6 py-2 flex justify-between items-center">
    <img src="IMG/4TECH.png" alt="logo4TECH" class="w-16 h-16 object-contain">
    <a href="loginEmpresarial.jsp" class="text-sm bg-blue-800 hover:bg-blue-900 px-4 py-2 rounded-lg font-bold transition-all shadow">
        Página principal.
    </a>
</nav>

<main class="container mx-auto max-w-4xl px-4 py-12 flex-grow">
    <div class="text-center mb-10">
        <h1 class="text-3xl font-extrabold text-gray-900 sm:text-4xl tracking-tight">Seguimiento de Órdenes de Servicio</h1>
        <p class="mt-3 text-base text-gray-500">Consulta el progreso de tus reparaciones ingresando tu número de identificación o el código de la orden.</p>
    </div>

    <div class="bg-white rounded-xl shadow-md p-6 mb-8 border border-gray-100">
        <form action="SvConsultaPublica" method="GET" class="flex flex-col sm:flex-row gap-3">
            <div class="relative flex-grow">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <i class="fa-solid fa-magnifying-glass text-gray-400"></i>
                </div>
                <input type="text" name="criterio" required
                       value="${criterioBuscado}"
                       placeholder="Ingresa Cédula o Número de Orden"
                       class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-gray-900 font-medium">
            </div>
            <button type="submit"
                    class="bg-blue-600 hover:bg-blue-700 text-white font-bold px-6 py-3 rounded-lg transition-all active:scale-95 shadow flex items-center justify-center gap-2">
                Buscar Órdenes
            </button>
        </form>
    </div>

    <c:if test="${not empty listaOrdenes}">
        <h2 class="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2 px-1">
            <i class="fa-solid fa-boxes-ids text-blue-600"></i> Historial de servicios encontrados
        </h2>

        <div class="max-h-[520px] overflow-y-auto pr-2 space-y-6 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-transparent">
            <c:forEach var="ord" items="${listaOrdenes}">
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 transition-all hover:shadow-md">

                    <div class="flex justify-between items-center border-b border-gray-100 pb-4 mb-4">
                        <div>
                            <span class="text-blue-700 font-black text-2xl italic tracking-tighter">
                                ORD-${String.format("%04d", ord.IDorden)}
                            </span>
                            <p class="text-sm font-bold text-gray-700 flex items-center gap-1.5 mt-0.5">
                                <i class="fa-solid fa-building text-blue-600 text-xs"></i>
                                Atendido por: <span class="text-blue-800 uppercase font-extrabold">${mapaEmpresas[ord.IDorden]}</span>
                            </p>
                            <p class="text-xs text-gray-400 mt-1">Fecha de Ingreso: ${ord.fecha_ingreso}</p>
                        </div>

                        <c:choose>
                            <c:when test="${ord.estado_actual eq 'PENDIENTE'}">
                                <span class="bg-amber-500 text-white text-xs italic px-4 py-1.5 rounded-full font-black uppercase tracking-wide shadow-sm">
                                        ${ord.estado_actual}
                                </span>
                            </c:when>
                            <c:when test="${ord.estado_actual eq 'EN REVISION' || ord.estado_actual eq 'EN PROCESO'}">
                                <span class="bg-blue-600 text-white text-xs italic px-4 py-1.5 rounded-full font-black uppercase tracking-wide shadow-sm">
                                        ${ord.estado_actual}
                                </span>
                            </c:when>
                            <c:when test="${ord.estado_actual eq 'COMPLETADO' || ord.estado_actual eq 'ENTREGADO'}">
                                <span class="bg-green-600 text-white text-xs italic px-4 py-1.5 rounded-full font-black uppercase tracking-wide shadow-sm">
                                        ${ord.estado_actual}
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="bg-gray-600 text-white text-xs italic px-4 py-1.5 rounded-full font-black uppercase tracking-wide shadow-sm">
                                        ${ord.estado_actual}
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="space-y-4">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                            <div class="bg-gray-50 p-4 rounded-lg border border-gray-100">
                                <strong class="text-gray-800 block mb-1 flex items-center gap-1.5">
                                    <i class="fa-solid fa-clipboard-list text-gray-400 text-base"></i> Reporte Inicial:
                                </strong>
                                <p class="text-gray-600 leading-relaxed">${ord.reporte}</p>
                            </div>

                            <div class="bg-gray-50 p-4 rounded-lg border border-gray-100">
                                <strong class="text-gray-800 block mb-1 flex items-center gap-1.5">
                                    <i class="fa-solid fa-screwdriver-wrench text-gray-400 text-base"></i> Diagnóstico Técnico:
                                </strong>
                                <p class="text-gray-600 leading-relaxed italic">
                                    <c:choose>
                                        <c:when test="${not empty ord.diagnostico}">${ord.diagnostico}</c:when>
                                        <c:otherwise>Su equipo se encuentra en cola de revisión técnica.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>

                        <div class="bg-gray-50 p-4 rounded-lg border border-gray-100 text-sm">
                            <strong class="text-gray-800 block mb-1 flex items-center gap-1.5">
                                <i class="fa-solid fa-eye text-gray-400 text-base"></i> Observaciones:
                            </strong>
                            <p class="text-gray-600 leading-relaxed">
                                <c:choose>
                                    <c:when test="${not empty ord.observaciones}">${ord.observaciones}</c:when>
                                    <c:otherwise><span class="text-gray-400 italic">Ninguna observación registrada hasta el momento.</span></c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="border border-gray-100 rounded-lg p-4 bg-white">
                            <strong class="text-gray-800 block mb-3 text-sm flex items-center gap-1.5">
                                <i class="fa-solid fa-layer-group text-blue-600 text-base"></i> Repuestos e Insumos Utilizados:
                            </strong>

                            <div class="overflow-x-auto">
                                <table class="min-w-full divide-y divide-gray-200 text-xs text-left">
                                    <thead class="bg-gray-50 text-gray-500 uppercase font-semibold">
                                    <tr>
                                        <th class="px-4 py-2">ID Producto</th>
                                        <th class="px-4 py-2">Nombre del Repuesto</th>
                                        <th class="px-4 py-2 text-center">Cantidad</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tabla-suministros-${ord.IDorden}" class="divide-y divide-gray-100 text-gray-600 font-medium">
                                    <tr class="loader-row">
                                        <td colspan="3" class="px-4 py-3 text-center text-gray-400 italic">
                                            <i class="fa-solid fa-spinner fa-spin mr-1"></i> Buscando componentes asociados...
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                </div>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${not empty criterioBuscado && empty listaOrdenes}">
        <div class="text-center py-12 bg-white rounded-xl shadow border border-gray-100 max-w-md mx-auto mt-6">
            <i class="fa-solid fa-folder-minus text-amber-500 text-5xl mb-3"></i>
            <h3 class="text-lg font-bold text-gray-800">Sin registros</h3>
            <p class="text-gray-500 text-sm px-6 mt-1">No encontramos órdenes de servicio asociadas al criterio ingresado. Asegúrate de digitar el número correctamente.</p>
        </div>
    </c:if>
</main>

<footer class="bg-gray-800 text-gray-400 text-center py-4 text-xs border-t border-gray-700">
    <p>© 2026 4TECH.</p>
</footer>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Buscamos todas las tablas de suministros renderizadas en la página
        const tablas = document.querySelectorAll('[id^="tabla-suministros-"]');

        tablas.forEach(tabla => {
            const ordenId = tabla.id.replace('tabla-suministros-', '');

            // Invocamos la ruta exacta de tu SvOrdenes para traer los insumos con sus nombres reales
            fetch('SvOrdenes?accion=listarSuministros&ordenId=' + ordenId + '&tipoVista=detalles')
                .then(response => response.json())
                .then(data => {
                    tabla.innerHTML = ''; // Limpiamos el mensaje de carga

                    if (data.length === 0) {
                        tabla.innerHTML = `
                            <tr>
                                <td colspan="3" class="px-4 py-3 text-center text-gray-400 italic">
                                    No se utilizaron repuestos adicionales en este servicio.
                                </td>
                            </tr>`;
                        return;
                    }

                    // Recorremos el JSON estructurado por tu servlet y lo pintamos en la tabla
                    data.forEach(item => {
                        const fila = document.createElement('tr');
                        fila.className = "hover:bg-gray-50 transition-colors";
                        fila.innerHTML = `
                            <td class="px-4 py-2.5 font-mono text-blue-600">#\${item.producto_id}</td>
                            <td class="px-4 py-2.5 font-bold text-gray-700">\${item.nombre}</td>
                            <td class="px-4 py-2.5 text-center text-gray-900 bg-gray-50 font-black rounded-md">\${item.cantidad}</td>
                        `;
                        tabla.appendChild(fila);
                    });
                })
                .catch(err => {
                    console.error("Error al cargar suministros:", err);
                    tabla.innerHTML = `
                        <tr>
                            <td colspan="3" class="px-4 py-3 text-center text-red-500">
                                Error al sincronizar los componentes del inventario.
                            </td>
                        </tr>`;
                });
        });
    });
</script>
</body>
</html>