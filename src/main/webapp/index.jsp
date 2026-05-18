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
<body class="bg-gradient-to-t from-primary to-black min-h-screen m-0 flex items-center justify-center bg-cover bg-center bg-no-repeat bg-fixed py-6 px-4" style="background-image: url('IMG/fondo1.jpg');">

<section class="bg-white/80 backdrop-blur-md max-w-4xl w-full grid grid-cols-1 md:grid-cols-2 overflow-hidden rounded-2xl shadow-2xl min-h-[auto] md:min-h-[580px]">

    <div class="p-6 sm:p-8 md:p-10 flex flex-col justify-center w-full">
        <header class="mb-6 text-center flex flex-col justify-center items-center">
            <img src="IMG/4TECH.png" alt="logo4TECH" class="w-36 h-36 md:w-48 md:h-48 object-contain mb-2">
            <h1 class="text-2xl md:text-3xl font-bold text-gray-800 tracking-tight">Inicio de sesión empresarial</h1>
        </header>

        <form action="SvEmpresas" method="POST" class="space-y-4 md:space-y-6" onsubmit="deshabilitarBoton()">
            <input type="hidden" name="accion" value="login">

            <div class="text-start">
                <label for="email" class="block text-sm font-semibold text-gray-700">Email</label>
                <div class="mt-1.5">
                    <input id="email" type="email" name="email" required autocomplete="email"
                           class="block w-full rounded-xl bg-gray-50/50 px-3.5 py-2.5 text-gray-900 border border-gray-300 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all text-base sm:text-sm"
                           placeholder="tu@correo.com" />
                </div>
            </div>

            <div class="text-start">
                <label for="password" class="block text-sm font-semibold text-gray-700">Contraseña</label>
                <div class="mt-1.5">
                    <input id="password" type="password" name="password" required autocomplete="current-password"
                           class="block w-full rounded-xl bg-gray-50/50 px-3.5 py-2.5 text-gray-900 border border-gray-300 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all text-base sm:text-sm" />
                </div>
            </div>

            <div class="pt-2">
                <button type="submit" name="accion" value="login"
                        class="flex w-full justify-center rounded-xl bg-primary px-4 py-2.5 text-sm font-bold text-white shadow-md hover:bg-opacity-90 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all active:scale-[0.98]">
                    Ingresar
                </button>
            </div>
        </form>

        <div class="mt-6 text-center border-t border-gray-200/60 pt-4">
            <p class="text-xs text-gray-500 mb-2">¿Eres parte del equipo técnico?</p>
            <a href="loginEmpleados.jsp"
               class="inline-block w-full rounded-xl border border-primary px-4 py-2.5 text-sm font-bold text-primary hover:bg-blue-50/50 transition-all active:scale-[0.98]">
                Acceso para Empleados
            </a>
        </div>
    </div>

    <div class="hidden md:block w-full h-full min-h-[580px]">
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