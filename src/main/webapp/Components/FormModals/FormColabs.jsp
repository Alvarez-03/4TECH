<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
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
</body>
</html>
