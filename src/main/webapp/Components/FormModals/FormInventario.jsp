<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="container-FormInventario" class="modal-section hidden">
  <header class="mb-6 border-b pb-4">
    <h2 id="modalInventarioTitulo" class="text-2xl font-bold text-gray-800 flex items-center gap-2">
      <i class="fa-solid fa-box text-blue-600"></i>
      Registrar Producto
    </h2>
  </header>

  <form action="SvInventario" method="POST" onsubmit="enviarFormulario(event)" class="space-y-4" id="FormInventario">
    <input type="hidden" name="accion" id="inv-accion" value="registrar">
    <input type="hidden" name="producto_id" id="inv-id">

    <div class="grid grid-cols-1 gap-4">
      <div>
        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Nombre del Producto / Repuesto</label>
        <input type="text" name="nombre" id="inv-nombre" required placeholder="Ej. Pantalla iPhone 13"
               class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Cantidad Inicial</label>
          <input type="number" name="cantidad" id="inv-cantidad" required min="0" placeholder="0"
                 class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
        </div>
        <div>
          <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Costo Unitario ($)</label>
          <input type="number" step="0.01" name="costo" id="inv-costo" required min="0" placeholder="0.00"
                 class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all">
        </div>
      </div>

      <div>
        <label class="block text-xs font-bold uppercase text-gray-500 mb-1">Proveedor Asociado</label>
        <select name="proveedor_id" id="inv-proveedor"
                class="w-full px-4 py-2.5 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none transition-all bg-white text-gray-700">
          <option value="">-- Sin Proveedor (Ninguno) --</option>
        </select>
      </div>
    </div>

    <div class="pt-6 flex justify-end gap-3">
      <button type="button" onclick="cerrarModal()"
              class="px-6 py-2.5 rounded-lg font-semibold text-gray-600 hover:bg-gray-100 transition-colors">
        Cancelar
      </button>
      <button type="submit" id="btnGuardarInventario"
              class="px-8 py-2.5 rounded-lg font-bold text-white bg-blue-600 hover:bg-blue-700 shadow-lg transition-all active:scale-95">
        Guardar Producto
      </button>
    </div>
  </form>
</div>