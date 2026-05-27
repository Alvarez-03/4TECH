<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="modalListadoProveedores" class="fixed inset-0 bg-black/50 z-40 hidden flex items-center justify-center p-4 backdrop-blur-sm transition-opacity">
    <div class="bg-white rounded-2xl w-full max-w-4xl max-h-[85vh] flex flex-col shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-200">
        <div class="bg-gray-800 text-white p-6 flex justify-between items-center">
            <div class="flex items-center gap-3">
                <i class="fa-solid fa-truck-field text-2xl text-blue-400"></i>
                <div>
                    <h3 class="text-xl font-bold">Proveedores</h3>
                    <p class="text-xs text-gray-400">Gestión de distribuidores de componentes asociados a la empresa</p>
                </div>
            </div>
            <div class="p-4 flex justify-end">
                <button onclick="abrirFormularioProveedor('registrar')" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2.5 rounded-xl font-bold text-sm shadow flex items-center gap-2 transition-all">
                    <i class="fa-solid fa-plus"></i> Agregar Proveedor
                </button>
            </div>
            <button onclick="cerrarModalProveedores()" class="text-gray-400 hover:text-white text-2xl transition-colors">&times;</button>
        </div>

        <div class="overflow-y-auto p-6 flex-1">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-100 text-gray-700 text-xs font-bold uppercase">
                <tr>
                    <th class="px-4 py-3 text-left">Empresa</th>
                    <th class="px-4 py-3 text-left">Asesor</th>
                    <th class="px-4 py-3 text-left">Teléfono</th>
                    <th class="px-4 py-3 text-center">Acciones</th>
                </tr>
                </thead>
                <tbody id="tablaCuerpoProveedores" class="divide-y divide-gray-100 text-sm">
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- 2. SUB-MODAL: FORMULARIO DE REGISTRO / EDICIÓN --%>
<div id="modalFormProveedor" class="fixed inset-0 bg-black/60 z-50 hidden flex items-center justify-center p-4 backdrop-blur-sm">
    <div class="bg-white rounded-2xl w-full max-w-md shadow-2xl overflow-hidden animate-in zoom-in-95 duration-150">
        <div class="bg-blue-600 text-white p-5 flex justify-between items-center">
            <h4 id="tituloFormProveedor" class="font-bold text-lg">Registrar Nuevo Proveedor</h4>
            <button onclick="cerrarFormularioProveedor()" class="text-white text-2xl hover:opacity-80">&times;</button>
        </div>

        <form id="formProveedorElemento" onsubmit="guardarProveedor(event)" class="p-6 space-y-4">
            <input type="hidden" id="prov_accion" name="accion" value="registrar">
            <input type="hidden" id="prov_id" name="IDproveedor" value="">

            <div>
                <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Nombre de la Empresa *</label>
                <input type="text" id="prov_nombre" name="nombre_empresa" required placeholder="Ej. Importaciones Tech S.A.S"
                       class="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-600 outline-none">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Contacto del Asesor</label>
                <input type="text" id="prov_contacto" name="contacto_asesor" placeholder="Ej. Ing. Carlos Mendoza"
                       class="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-600 outline-none">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Teléfono de Contacto *</label>
                <input type="text" id="prov_telefono" name="telefono_contacto" required placeholder="Ej. +57 312 456 7890"
                       class="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-600 outline-none">
            </div>

            <div class="flex justify-end gap-3 pt-4 border-t border-gray-100">
                <button type="button" onclick="cerrarFormularioProveedor()" class="px-4 py-2 text-gray-500 hover:bg-gray-100 rounded-xl font-semibold transition-colors">Cancelar</button>
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2 rounded-xl font-bold shadow transition-colors">Guardar Datos</button>
            </div>
        </form>
    </div>
</div>
