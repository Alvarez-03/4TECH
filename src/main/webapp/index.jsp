<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>4TECH | LOGIN EMPRESARIAL</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">

    <script src="WEB-INF/resources/ControlsButton.js"></script>
    <link rel="icon" type="image/png" href="IMG/4TECH.png">
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
</head>
    <body class="bg-gradient-to-t from-primary to-black min-h-screen p-0 m-0 flex items-center justify-center bg-cover bg-center bg-no-repeat bg-fixed" style="background-image: url('IMG/fondo1.jpg');" >
        <section class="bg-white/60 max-w-4xl w-full mx-4 grid grid-cols-1 md:grid-cols-2 overflow-hidden rounded-xl shadow-2xl">

            <div class="p-10 flex flex-col justify-center">
                <header class="mb-8 text-center flex flex-col justify-center items-center">
                    <img src="IMG/4TECH.png" alt="logo4TECH" width="200" height="200">
                    <h1 class="text-3xl font-bold text-gray-800 tracking-tight">Inicio de sesión empresarial</h1>
                </header>

                <form action="SvEmpresas" method="POST" class="space-y-6" onsubmit="deshabilitarBoton()">
                    <input type="hidden" name="accion" value="login">

                    <div class="text-start">
                        <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                        <div class="mt-2">
                            <input id="email" type="email" name="email" required autocomplete="email"
                                   class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-indigo-500 outline-none sm:text-sm"
                                   placeholder="tu@correo.com" />
                        </div>
                    </div>

                    <div class="text-start">
                        <label for="password" class="block text-sm font-medium text-gray-700">Contraseña</label>
                        <div class="mt-2">
                            <input id="password" type="password" name="password" required autocomplete="current-password"
                                   class="block w-full rounded-md bg-gray-50 px-3 py-2 text-gray-900 border border-gray-300 focus:ring-2 focus:ring-indigo-500 outline-none sm:text-sm" />
                        </div>
                    </div>

                    <div class="pt-2">
                        <button type="submit" name="accion" value="login"
                                class="flex w-full justify-center rounded-md bg-primary px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition-colors">
                            Ingresar
                        </button>
                    </div>
                </form>
                <div class="mt-6 text-center border-t pt-4">
                    <p class="text-xs text-gray-500 mb-2">¿Eres parte del equipo técnico?</p>
                    <a href="loginEmpleados.jsp"
                       class="inline-block w-full rounded-md border border-primary px-3 py-2 text-sm font-semibold text-primary hover:bg-blue-50 transition-colors">
                        Acceso para Empleados
                    </a>
                </div>
            </div>

            <div class="hidden md:block w-full h-full">
                <img src="IMG/fondo2.jpg" class="w-full h-full object-cover" alt="4Tech_IMG_EMPRESARIAL">
            </div>
        </section>

        <%
            String error = (String) request.getAttribute("errorLogin");
            String debug = (String) request.getAttribute("debugMsg");

            if (error != null) {
        %>
            <script>
                console.error("Error de Login: <%= error %>");
                console.warn("Detalles técnicos: <%= debug %>");

                Swal.fire({
                    icon: 'error',
                    title: 'Upss hubo un error',
                    text: '<%= error %>',
                    confirmButtonColor: '#1d4ed8'
                });
            </script>
        <% } %>
    </body>

</html>