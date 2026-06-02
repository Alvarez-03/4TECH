<%@ page import="Logica.modelo.Empresa" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<%--        //formulario para registrar orden--%>
    <% if(permisos.equals("EMPRESA")){
        Empresa emp = (Empresa)session.getAttribute("usuarioLogueado");
    %>
    <div id="container-FormRegisterOrd" class="modal-section hidden">
        <header class="mb-6 border-b pb-2 sticky top-0 bg-white z-10">
            <h2 class="text-2xl font-bold text-gray-800">Registrar orden | <span class="text-blue-600"><%= emp.getNombre()%></span></h2>
            <p class="text-sm text-gray-500">Completa la información para crear una nueva orden.</p>
        </header>
        <form action="SvOrdenes" method="POST" id="FormRegisterOrd" onsubmit="enviarFormulario(event)" class="max-h-[85vh] flex flex-col justify-between px-1">
            <input type="hidden" name="accion" value="registrar">

            <div class="mb-6 px-4">
                <div class="flex items-center justify-between relative">
                    <div class="absolute left-0 top-1/2 transform -translate-y-1/2 w-full h-1 bg-gray-200 -z-10 rounded"></div>
                    <div id="linea-progreso" class="absolute left-0 top-1/2 transform -translate-y-1/2 w-0 h-1 bg-blue-600 -z-10 transition-all duration-300 rounded"></div>

                    <div class="flex flex-col items-center">
                        <div id="circle-step-1" class="w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold text-sm transition-all duration-300 ring-4 ring-blue-100">1</div>
                        <span class="text-[10px] font-bold uppercase tracking-wider text-gray-700 mt-1 hidden sm:block">Cliente</span>
                    </div>
                    <div class="flex flex-col items-center">
                        <div id="circle-step-2" class="w-8 h-8 rounded-full bg-gray-200 text-gray-600 flex items-center justify-center font-bold text-sm transition-all duration-300">2</div>
                        <span class="text-[10px] font-bold uppercase tracking-wider text-gray-400 mt-1 hidden sm:block">Detalles</span>
                    </div>
                    <div class="flex flex-col items-center">
                        <div id="circle-step-3" class="w-8 h-8 rounded-full bg-gray-200 text-gray-600 flex items-center justify-center font-bold text-sm transition-all duration-300">3</div>
                        <span class="text-[10px] font-bold uppercase tracking-wider text-gray-400 mt-1 hidden sm:block">Suministros</span>
                    </div>
                </div>
            </div>

            <div class="overflow-y-auto px-1 py-2 custom-scroll flex-1 max-h-[55vh]">

                <div id="paso-1" class="step-container space-y-4">
                    <div class="flex items-center border-b border-gray-100 pb-2 mb-2">
                        <div class="bg-blue-600 p-2 rounded-lg text-white mr-3">
                            <i class="fas fa-user-tag"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-800">Información del Cliente</h3>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="space-y-1">
                            <label class="text-xs font-semibold uppercase text-gray-500">Documento / NIT</label>
                            <div class="relative flex items-center">
                                <span class="absolute left-3 text-gray-400"><i class="fas fa-id-card"></i></span>
                                <input type="text" id="documento_cliente" name="documento" required
                                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                            </div>
                            <div id="cliente_status" class="min-h-[20px] text-[10px] mt-1 ml-1"></div>
                        </div>

                        <div class="space-y-1">
                            <label class="text-xs font-semibold uppercase text-gray-500">Nombre o Razón Social</label>
                            <div class="relative flex items-center">
                                <span class="absolute left-3 text-gray-400"><i class="fas fa-user"></i></span>
                                <input type="text" id="nombre_cliente" name="nombre_cliente" required readonly
                                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg bg-gray-50 text-gray-500 cursor-not-allowed outline-none">
                            </div>
                        </div>

                        <div class="space-y-1">
                            <label class="text-xs font-semibold uppercase text-gray-500">Teléfono / WhatsApp</label>
                            <div class="relative flex items-center">
                                <span class="absolute left-3 text-gray-400"><i class="fab fa-whatsapp"></i></span>
                                <input type="text" id="telefono_cliente" name="telefono_cliente" readonly
                                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg bg-gray-50 text-gray-500 cursor-not-allowed outline-none">
                            </div>
                        </div>

                        <div class="space-y-1">
                            <label class="text-xs font-semibold uppercase text-gray-500">Correo Electrónico</label>
                            <div class="relative flex items-center">
                                <span class="absolute left-3 text-gray-400"><i class="fas fa-envelope"></i></span>
                                <input type="email" id="email_cliente" name="email_cliente" readonly
                                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg bg-gray-50 text-gray-500 cursor-not-allowed outline-none">
                            </div>
                        </div>
                    </div>
                </div>

                <div id="paso-2" class="step-container space-y-4 hidden">
                    <div class="flex items-center border-b border-gray-100 pb-2 mb-2">
                        <div class="bg-blue-600 p-2 rounded-lg text-white mr-3">
                            <i class="fa-solid fa-receipt"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-800">Detalles de la Orden</h3>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="md:col-span-2">
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Empleado Asignado</label>
                            <select id="empleado_id" name="empleado_id" class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm"></select>
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Reporte del Cliente</label>
                            <textarea id="reporte" name="reporte" rows="2" class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm" placeholder="¿Qué reporta el cliente?"></textarea>
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Diagnóstico Inicial</label>
                            <textarea id="diagnostico" name="diagnostico" rows="2" class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm" placeholder="Análisis técnico inicial..."></textarea>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Estado Inicial</label>
                            <select id="estado_actual" name="estado_actual" class="block w-full rounded-md bg-yellow-50 px-3 py-2 text-yellow-700 border border-yellow-200 font-bold focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm uppercase">
                                <option value="PENDIENTE">PENDIENTE</option>
                                <option value="EN PROCESO">EN PROCESO</option>
                                <option value="REVISADO">REVISADO</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Observaciones Internas</label>
                            <input id="observaciones" type="text" name="observaciones" class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm" placeholder="Notas para el equipo..." />
                        </div>
                    </div>
                </div>

                <div id="paso-3" class="step-container space-y-4 hidden">
                    <div class="flex items-center border-b border-gray-100 pb-2 mb-2">
                        <div class="bg-blue-600 p-2 rounded-lg text-white mr-3">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-800">Suministros y Repuestos Utilizados</h3>
                    </div>

                    <p class="text-xs text-gray-500 italic mb-4">Agrega los productos del inventario requeridos para este servicio.</p>

                    <div id="contenedor-productos-orden" class="space-y-3">
                        <div class="text-center py-6 text-gray-400 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                            <i class="fa-solid fa-box-open text-3xl mb-2"></i>
                            <p class="text-xs font-medium">No se han añadido repuestos a esta orden todavía.</p>
                        </div>
                    </div>

                    <button type="button" onclick="agregarFilaProducto()" class="mt-2 text-sm font-bold text-blue-600 hover:text-blue-700 flex items-center gap-1">
                        <i class="fa-solid fa-circle-plus"></i> Añadir repuesto
                    </button>
                </div>

            </div>

            <div class="mt-6 flex gap-3 bg-white py-3 border-t">
                <button id="btn-back" onclick="cambiarPaso(-1)" type="button" class="flex-1 rounded-md border border-gray-300 px-4 py-2 bg-white text-gray-700 font-medium hover:bg-gray-50 transition sm:text-sm hidden">
                    Atrás
                </button>
                <button id="btn-cancelar-modal" onclick="cerrarModal()" type="button" class="flex-1 rounded-md border border-gray-300 px-4 py-2 bg-white text-gray-700 font-medium hover:bg-gray-50 transition sm:text-sm">
                    Cancelar
                </button>
                <button id="btn-next" onclick="cambiarPaso(1)" type="button" class="flex-1 bg-blue-700 text-white py-2 px-4 rounded-md hover:bg-blue-800 font-bold transition sm:text-sm shadow-lg">
                    Siguiente
                </button>
                <button id="btn-submit-form" type="submit" class="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white py-2 px-4 rounded-md font-bold transition sm:text-sm shadow-lg hidden">
                    Registrar orden
                </button>
            </div>
        </form>
    </div>
    <% } %>

    <%-- // formulario ACTUALIZAR ORDEN --%>
    <div id="container-UpdOrd" class="modal-section hidden">
        <header class="mb-6 border-b pb-4">
            <h2 class="text-2xl font-bold text-gray-800">Actualizar Orden | <span class="text-blue-600" id="edit-orden-id"></span></h2>
            <p class="text-sm text-gray-500">Modifica los detalles técnicos, estado o suministros de la orden.</p>
        </header>

        <div class="mb-6 px-4">
            <div class="flex items-center justify-between relative max-w-xs mx-auto">
                <div class="absolute left-0 top-1/2 transform -translate-y-1/2 w-full h-1 bg-gray-200 -z-10 rounded"></div>
                <div id="linea-progreso-upd" class="absolute left-0 top-1/2 transform -translate-y-1/2 w-0 h-1 bg-blue-600 -z-10 transition-all duration-300 rounded"></div>

                <div class="flex flex-col items-center">
                    <div id="circle-upd-step-1" class="w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold text-sm transition-all duration-300 ring-4 ring-blue-100">1</div>
                    <span class="text-[10px] font-bold uppercase tracking-wider text-gray-700 mt-1">Diagnóstico</span>
                </div>
                <div class="flex flex-col items-center">
                    <div id="circle-upd-step-2" class="w-8 h-8 rounded-full bg-gray-200 text-gray-600 flex items-center justify-center font-bold text-sm transition-all duration-300">2</div>
                    <span class="text-[10px] font-bold uppercase tracking-wider text-gray-400 mt-1">Repuestos</span>
                </div>
            </div>
        </div>

        <form action="SvOrdenes" method="POST" id="FormUpdateOrd" onsubmit="enviarFormulario(event)" class="max-h-[75vh] flex flex-col justify-between">
            <input type="hidden" name="accion" value="actualizar">
            <input type="hidden" name="ID" id="upd-orden-id-hidden">

            <div class="flex-1 min-h-0">

                <div id="upd-paso-1" class="upd-step-container h-full overflow-y-auto px-1 py-2 custom-scroll space-y-4">
                    <main class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <% if(permisos.equals("EMPRESA") ){ %>
                        <div>
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Empleado Asignado</label>
                            <select id="upd-empleado-id" name="empleado_id" required
                                    class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm">
                            </select>
                        </div>
                        <%} else {
                            Logica.modelo.Empleado tecnico = (Logica.modelo.Empleado) session.getAttribute("usuarioLogueado");
                        %>
                        <input type="hidden" name="empleado_id" value="<%= tecnico.getID() %>">
                        <div class="md:col-span-1">
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Técnico Responsable</label>
                            <p class="text-sm font-bold text-blue-600 p-2 bg-blue-50 rounded"><%= tecnico.getNombre() %></p>
                        </div>
                        <%}%>

                        <div>
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Estado Actual</label>
                            <select id="upd-estado-actual" name="estado_actual" required
                                    class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm font-bold">
                                <option value="PENDIENTE">PENDIENTE</option>
                                <option value="EN PROCESO">EN PROCESO</option>
                                <option value="REVISADO">REVISADO</option>
                                <option value="TERMINADO">TERMINADO</option>
                            </select>
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Reporte del Cliente</label>
                            <textarea id="upd-reporte" name="reporte" readonly
                                      class="block w-full rounded-md bg-gray-100 px-3 py-2 text-gray-600 border border-gray-300 sm:text-sm cursor-not-allowed"></textarea>
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Diagnóstico Técnico</label>
                            <textarea id="upd-diagnostico" name="diagnostico" rows="3" required
                                      class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                                      placeholder="Escriba el análisis técnico realizado..."></textarea>
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Observaciones Internas</label>
                            <input id="upd-observaciones" type="text" name="observaciones"
                                   class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm" placeholder="Notas adicionales..." />
                        </div>
                    </main>
                </div>

                <div id="upd-paso-2" class="upd-step-container h-full flex flex-col hidden">
                    <div class="flex items-center border-b border-gray-100 pb-2 mb-2 flex-shrink-0">
                        <div class="bg-blue-600 p-2 rounded-lg text-white mr-3">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-800">Gestionar Repuestos de la Orden</h3>
                    </div>
                    <p class="text-xs text-gray-500 italic mb-3 flex-shrink-0">Revisa, remueve o añade materiales del inventario consumidos en esta intervención.</p>

                    <div id="contenedor-productos-upd" class="space-y-3 flex-1 overflow-y-auto pr-1 pb-2 max-h-[28vh] custom-scroll">
                        <div class="text-center py-6 text-gray-400 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                            <i class="fa-solid fa-spinner fa-spin text-3xl mb-2 text-primary"></i>
                            <p class="text-xs font-medium">Cargando suministros asignados...</p>
                        </div>
                    </div>

                    <div class="pt-2 border-t mt-1 flex-shrink-0">
                        <button type="button" onclick="agregarFilaProductoEdicion()" class="text-sm font-bold text-primary hover:text-blue-700 flex items-center gap-1">
                            <i class="fa-solid fa-circle-plus"></i> Añadir otro repuesto
                        </button>
                    </div>
                </div>

            </div>

            <div class="mt-4 flex gap-3 bg-white py-3 border-t flex-shrink-0">
                <button id="btn-upd-back" onclick="cambiarPasoEdicion(-1)" type="button" class="flex-1 rounded-md border border-gray-300 px-4 py-2 bg-white text-gray-700 font-medium hover:bg-gray-50 transition sm:text-sm hidden">
                    Atrás
                </button>
                <button id="btn-upd-cancelar" onclick="cerrarModal()" type="button" class="flex-1 rounded-md border border-gray-300 px-4 py-2 bg-white text-gray-700 font-medium hover:bg-gray-50 transition sm:text-sm">
                    Cancelar
                </button>
                <button id="btn-upd-next" onclick="cambiarPasoEdicion(1)" type="button" class="flex-1 bg-primary text-white py-2 px-4 rounded-md hover:bg-blue-800 font-bold transition sm:text-sm shadow-lg">
                    Siguiente
                </button>
                <button id="btn-upd-submit" type="submit" class="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white py-2 px-4 rounded-md font-bold transition sm:text-sm shadow-lg hidden">
                    Actualizar Orden
                </button>
            </div>
        </form>
    </div>
</body>
</html>
