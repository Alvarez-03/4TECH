<%@ page import="Logica.modelo.Empresa" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <link href="https://cdn.tailwindcss.com" rel="stylesheet">
    <script src="resources/ControlModal.js"></script>
</head>
<%
    String permisos = (String) session.getAttribute("PERMISOS");
    Empresa emp = (Empresa) session.getAttribute("usuarioLogueado");
%>
<div id="miModal" class="hidden fixed inset-0 z-50 overflow-auto flex items-center justify-center bg-black bg-opacity-50 transition-opacity duration-300" aria-labelledby="modal-title" role="dialog"  aria-modal="true">
    <div id="modalContent"  class="bg-white rounded-lg shadow-xl w-full max-w-4xl p-6 transition-all transform scale-95 opacity-0">

<%--        //formulario para registrar empresas--%>
        <div id="container-FormRegisterEmp" class="modal-section hidden">
            <header class="mb-6 border-b pb-2">
                <h2 class="text-2xl font-bold text-gray-800">Registrar empresa | <span class="text-primary">4TECH</span></h2>
                <p class="text-sm text-gray-500">Completa la información para crear una nueva cuenta.</p>
            </header>

            <form action="SvEmpresas" method="POST" onsubmit="enviarFormulario(event)" id="formRegistro">
                <input type="hidden" name="accion" value="registrar">

                <main class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="md:col-span-2">
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Nombre de empresa</label>
                        <input id="nombre" type="text" name="nombre" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="MANTENIMIENTO SAS" />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Siglas</label>
                        <input id="siglas" type="text" name="siglas" required maxlength="3"
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="MTO" />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Teléfono</label>
                        <input id="telefono" type="number" name="telefono" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="3100870020" />
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Correo Electrónico</label>
                        <input id="email" type="email" name="email" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="mantenimientosas@gmail.com" />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Ciudad</label>
                        <input id="ciudad" type="text" name="ciudad" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="Cali, Colombia" />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Dirección</label>
                        <input id="direccion" type="text" name="direccion" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="CRA 11 # 8 - 10" />
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Contraseña de acceso</label>
                        <input id="password" type="password" name="password" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="••••••••" />
                    </div>
                </main>

                <div class="mt-8 flex gap-3">
                    <button
                            id="btnCerrarModal"
                            type="button"
                            class="flex-1 rounded-md border border-gray-300 px-4 py-2 bg-white text-gray-700 font-medium hover:bg-gray-50 transition sm:text-sm"
                    >
                        Cancelar
                    </button>
                    <button
                            type="submit"
                            class="flex-1 bg-primary text-white py-2 px-4 rounded-md hover:bg-blue-800 font-bold transition sm:text-sm shadow-lg shadow-blue-200"
                    >
                        Registrar Empresa
                    </button>
                </div>
            </form>
        </div>

<%--        //formulario para actualizar empresa--%>
        <div id="container-UpdEmp" class="modal-section hidden">
            <header class="mb-6 border-b pb-2">
                <h2 class="text-2xl font-bold text-gray-800">Actualiza Empresa</h2>
            </header>
            <form action="SvEmpresas" method="post" onsubmit="enviarFormulario(event)" id="formUpdEmp">
                <input type="hidden" name="accion" value="actualizarEmp">

                <main class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="md:col-span-2">
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Nombre de empresa</label>
                        <input id="nombre" type="text" name="nombre" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="MANTENIMIENTO SAS" />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Siglas</label>
                        <input id="siglas" type="text" name="siglas" required maxlength="3"
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="MTO" />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Teléfono</label>
                        <input id="telefono" type="number" name="telefono" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="3100870020" />
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Correo Electrónico</label>
                        <input id="email" type="email" name="email" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="mantenimientosas@gmail.com" />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Ciudad</label>
                        <input id="ciudad" type="text" name="ciudad" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="Cali, Colombia" />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Dirección</label>
                        <input id="direccion" type="text" name="direccion" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="CRA 11 # 8 - 10" />
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Contraseña de acceso</label>
                        <input id="password" type="password" name="password" required
                               class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                               placeholder="••••••••" />
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Estado de la Empresa</label>
                        <select id="estado" name="estado"
                                class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm">
                            <option value="ACTIVO">ACTIVO</option>
                            <option value="SUSPENDIDO">SUSPENDIDO</option>
                        </select>
                    </div>
                </main>

                <div class="mt-8 flex gap-3">
                    <button
                            onclick="cerrarModal()"
                            id="btnCerrarModal"
                            type="button"
                            data-type="UpdEmp"
                            class="flex-1 rounded-md border border-gray-300 px-4 py-2 bg-white text-gray-700 font-medium hover:bg-gray-50 transition sm:text-sm"
                    >
                        Cancelar
                    </button>
                    <button
                            type="submit"
                            class="flex-1 bg-primary text-white py-2 px-4 rounded-md hover:bg-blue-800 font-bold transition sm:text-sm shadow-lg shadow-blue-200"
                    >
                        Actualizar Empresa
                    </button>
                </div>
            </form>
        </div>

<%--            //formulario para registrar colaborador--%>
        <div id="container-FormRegisterWork" class="modal-section hidden">
            <header class="mb-6 border-b pb-4">
                <h2 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="fa-solid fa-user-plus text-blue-600"></i>
                    Registrar Nuevo Trabajador
                </h2>
                <p class="text-sm text-gray-500">Complete los datos para vincular al colaborador.</p>
            </header>

            <form action="SvEmpleados" method="POST" onsubmit="enviarFormulario(event)" class="space-y-4" id="FormRegisterWork">
                <input type="hidden" name="accion" value="registrar">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Nombre Completo</label>
                        <input type="text" name="nombre" required placeholder="Ej. Juan Pérez"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Numero de identificacion</label>
                        <input type="number" name="ID" required placeholder="Ej. 1164845946"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Correo Electrónico</label>
                        <input type="email" name="email" required placeholder="juan@empresa.com"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Teléfono</label>
                        <input type="text" name="telefono" required placeholder="3001234567"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Cargo / Rol</label>
                        <input type="text" name="cargo" required placeholder="Ej. Analista TI"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Contraseña Inicial</label>
                        <input type="password" name="password" required placeholder="********"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <%
                        if ("SUPERADMIN".equals(permisos)) {
                    %>
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Asignar a empresa</label>
                        <select id="selectEmpresaRegistro" name="empresa_id" required
                                class="w-full px-4 py-2.5 rounded-lg border border-gray-300 bg-blue-50/30 focus:ring-2 focus:ring-blue-500 outline-none transition-all appearance-none cursor-pointer">
                            <option value="" disabled selected>Cargando empresas disponibles...</option>
                        </select>
                    </div>
                    <%
                    } else {
                        Object idEmp = session.getAttribute("ID_EMPRESA");
                    %>
                    <input type="hidden" name="empresa_id" value="<%= idEmp != null ? idEmp : "" %>">
                    <% } %>

                </div>



                <div class="pt-6 flex justify-end gap-3">
                    <button type="button" onclick="ejecutarCierreEfectivo()"
                            class="px-6 py-2.5 rounded-lg font-semibold text-gray-600 hover:bg-gray-100 transition-colors">
                        Cancelar
                    </button>
                    <button type="submit"
                            class="px-8 py-2.5 rounded-lg font-bold text-white bg-blue-600 hover:bg-blue-700 shadow-lg shadow-blue-200 transition-all active:scale-95">
                        Guardar Colaborador
                    </button>
                </div>
            </form>
        </div>

<%--            //formulario para actualizar colaborador--%>
        <div id="container-UpdWork" class="modal-section hidden">
            <header class="mb-6 border-b pb-4">
                <h2 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="fa-solid fa-user-plus text-blue-600"></i>
                    Actualizar colaborador
                </h2>
            </header>

            <form action="SvEmpleados" method="POST" onsubmit="enviarFormulario(event)" class="space-y-4" id="FormUpdWork">
                <input type="hidden" name="accion" value="actualizar">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Nombre Completo</label>
                        <input type="text" name="nombre"  placeholder="Ej. Juan Pérez"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Numero de identificacion</label>
                        <input type="number" name="ID" readonly placeholder="Ej. 1164845946"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Correo Electrónico</label>
                        <input type="email" name="email"  placeholder="juan@empresa.com"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Teléfono</label>
                        <input type="text" name="telefono"  placeholder="3001234567"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Cargo / Rol</label>
                        <input type="text" name="cargo"  placeholder="Ej. Analista TI"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Contraseña</label>
                        <input type="password" name="password"  placeholder="********"
                               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                    </div>

                </div>



                <div class="pt-6 flex justify-end gap-3">
                    <button type="button" onclick="cerrarModal()"
                            class="px-6 py-2.5 rounded-lg font-semibold text-gray-600 hover:bg-gray-100 transition-colors">
                        Cancelar
                    </button>
                    <button type="submit"
                            class="px-8 py-2.5 rounded-lg font-bold text-white bg-blue-600 hover:bg-blue-700 shadow-lg shadow-blue-200 transition-all active:scale-95">
                        Actualizar Colaborador
                    </button>
                </div>
            </form>
        </div>

    <%--        //formulario para registrar orden--%>
    <div id="container-FormRegisterOrd" class="modal-section hidden">
        <header class="mb-6 border-b pb-2 sticky top-0 bg-white z-10">
            <h2 class="text-2xl font-bold text-gray-800">Registrar orden | <span class="text-blue-600"><%= emp.getNombre() %></span></h2>
            <p class="text-sm text-gray-500">Completa la información para crear una nueva orden.</p>
        </header>

        <form action="SvOrdenes" method="POST" id="FormRegisterOrd" onsubmit="enviarFormulario(event)" class="max-h-[70vh] overflow-y-auto px-1 custom-scroll">
            <input type="hidden" name="accion" value="registrar">

            <main class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-4">

                <div class="md:col-span-2 flex items-center border-b border-gray-100 pb-2 mb-2">
                    <div class="bg-blue-600 p-2 rounded-lg text-white mr-3">
                        <i class="fas fa-user-tag"></i>
                    </div>
                    <h3 class="text-lg font-bold text-gray-800">Información del Cliente</h3>
                </div>

                <div class="space-y-1">
                    <label class="text-xs font-semibold uppercase text-gray-500">Documento / NIT</label>
                    <div class="relative flex items-center">
                        <span class="absolute left-3 text-gray-400"><i class="fas fa-id-card"></i></span>
                        <input type="text" id="documento_cliente" name="documento" required
                               class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                               placeholder="Ej: 1090...">
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

                <div class="md:col-span-2 flex items-center border-b border-gray-100 pb-2 mt-4 mb-2">
                    <div class="bg-blue-600 p-2 rounded-lg text-white mr-3">
                        <i class="fa-solid fa-receipt"></i>
                    </div>
                    <h3 class="text-lg font-bold text-gray-800">Detalles de la Orden</h3>
                </div>

                <div class="md:col-span-2">
                    <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Empleado Asignado</label>
                    <select id="empleado_id" name="empleado_id" required
                            class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm">
                    </select>
                </div>

                <div class="md:col-span-2">
                    <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Reporte del Cliente</label>
                    <textarea id="reporte" name="reporte" required rows="2"
                              class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm"
                              placeholder="¿Qué reporta el cliente?"></textarea>
                </div>

                <div class="md:col-span-2">
                    <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Diagnóstico Inicial</label>
                    <textarea id="diagnostico" name="diagnostico" rows="2"
                              class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm"
                              placeholder="Análisis técnico inicial..."></textarea>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Estado Inicial</label>
                    <select id="estado_actual" name="estado_actual" required
                            class="block w-full rounded-md bg-yellow-50 px-3 py-2 text-yellow-700 border border-yellow-200 font-bold focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm uppercase">
                        <option value="PENDIENTE">PENDIENTE</option>
                        <option value="EN PROCESO">EN PROCESO</option>
                        <option value="REVISADO">REVISADO</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Observaciones Internas</label>
                    <input id="observaciones" type="text" name="observaciones"
                           class="block w-full rounded-md bg-white px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none sm:text-sm"
                           placeholder="Notas para el equipo..." />
                </div>

            </main>

            <div class="mt-8 flex gap-3 sticky bottom-0 bg-white py-4 border-t">
                <button onclick="cerrarModal()" id="btnCerrarModal" type="button"
                        class="flex-1 rounded-md border border-gray-300 px-4 py-2 bg-white text-gray-700 font-medium hover:bg-gray-50 transition sm:text-sm">
                    Cancelar
                </button>
                <button type="submit"
                        class="flex-1 bg-blue-700 text-white py-2 px-4 rounded-md hover:bg-blue-800 font-bold transition sm:text-sm shadow-lg">
                    Registrar orden
                </button>
            </div>
        </form>
    </div>

    <%-- // formulario ACTUALIZAR ORDEN --%>
    <div id="container-UpdOrd" class="modal-section hidden">
        <header class="mb-6 border-b pb-2">
            <h2 class="text-2xl font-bold text-gray-800">Actualizar Orden | <span class="text-blue-600" id="edit-orden-id"></span></h2>
            <p class="text-sm text-gray-500">Modifica los detalles técnicos o el estado de la orden.</p>
        </header>

        <form action="SvOrdenes" method="POST" onsubmit="enviarFormulario(event)">
            <input type="hidden" name="accion" value="actualizar">
            <input type="hidden" name="ID" id="upd-orden-id-hidden">

            <main class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Empleado Asignado</label>
                    <select id="upd-empleado-id" name="empleado_id" required
                            class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm">
                    </select>
                </div>

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
                    <textarea id="upd-diagnostico" name="diagnostico" rows="3"
                              class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm"
                              placeholder="Escriba el análisis técnico..."></textarea>
                </div>

                <div class="md:col-span-2">
                    <label class="block text-xs font-semibold uppercase text-gray-500 mb-1">Observaciones</label>
                    <input id="upd-observaciones" type="text" name="observaciones"
                           class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-primary outline-none sm:text-sm" />
                </div>
            </main>

            <div class="mt-8 flex gap-3">
                <button onclick="cerrarModal()" type="button" class="flex-1 rounded-md border border-gray-300 px-4 py-2 bg-white text-gray-700 font-medium hover:bg-gray-50 transition">
                    Cancelar
                </button>
                <button type="submit" class="flex-1 bg-primary text-white py-2 px-4 rounded-md hover:bg-blue-800 font-bold transition shadow-lg">
                    Actualizar Orden
                </button>
            </div>
        </form>
    </div>
    </div>
</div>