<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <link href="https://cdn.tailwindcss.com" rel="stylesheet">
</head>

<div
        id="miModal"
        class="hidden fixed inset-0 z-50 overflow-auto flex items-center justify-center bg-black bg-opacity-50 transition-opacity duration-300"
        aria-labelledby="modal-title"
        role="dialog"
        aria-modal="true"
>
    <div
            id="modalContent"
            class="bg-white rounded-lg shadow-xl w-full max-w-4xl p-6 transition-all transform scale-95 opacity-0"
    >

        <div id="container-FormRegisterEmp" class="modal-section hidden">
            <header class="mb-6 border-b pb-2">
                <h2 class="text-2xl font-bold text-gray-800">Registrar empresa | <span class="text-primary">4TECH</span></h2>
                <p class="text-sm text-gray-500">Completa la información para crear una nueva cuenta.</p>
            </header>

            <form action="SvUsuarios" method="POST" onsubmit="enviarFormulario(event)" id="formRegistro">
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

        <div id="container-FormRegisterWork" class="modal-section hidden">
            <header class="mb-6 border-b pb-2">
                <h2 class="text-2xl font-bold text-gray-800">Registrar Trabajadores</h2>
            </header>
            <p>Aquí irá el formulario de trabajadores...</p>
        </div>

        <div id="container-AdminEmp" class="modal-section hidden">
            <header class="mb-6 border-b pb-2">
                <h2 class="text-2xl font-bold text-gray-800">Administrar Empresas</h2>
            </header>
            <p>Aquí irá la tabla o lista de administración...</p>
        </div>
            </main>
        </div>
    </div>
</div>