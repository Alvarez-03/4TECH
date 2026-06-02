<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>4TECH | Acceso Técnico</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="IMG/4TECH.png">

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'sans-serif'] },
                    colors: { 'primary': '#1d4ed8' }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col justify-center items-center font-sans p-4">

<div class="w-full max-w-md mx-auto">

    <header class="text-center mb-8">
        <div class="flex justify-center mb-2">
            <img src="IMG/4TECH.png" alt="logo4TECH" class="w-28 h-28 md:w-36 md:h-36 object-contain">
        </div>
        <h1 class="text-2xl md:text-3xl font-bold text-gray-900 tracking-tight">Panel Técnico</h1>
        <p class="text-sm md:text-base text-gray-500 mt-1">Ingresa para gestionar tus órdenes</p>
    </header>

    <div class="bg-white p-6 sm:p-8 rounded-2xl shadow-xl border border-gray-100/80">
        <form action="SvEmpleados" method="POST" class="space-y-5">
            <input type="hidden" name="accion" value="loginEmpleado">

            <div class="text-start">
                <label for="email" class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5 ml-1">Correo Electrónico</label>
                <input id="email" type="email" name="email" required
                       class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:border-primary focus:ring-2 focus:ring-primary/20 focus:bg-white outline-none transition-all text-base sm:text-sm"
                       placeholder="nombre@4tech.com" />
            </div>

            <div class="text-start">
                <label for="password" class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5 ml-1">Contraseña</label>
                <input id="password" type="password" name="password" required
                       class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:border-primary focus:ring-2 focus:ring-primary/20 focus:bg-white outline-none transition-all text-base sm:text-sm"
                       placeholder="••••••••" />
            </div>

            <div class="pt-2">
                <button type="submit"
                        class="w-full bg-gray-900 text-white py-3.5 rounded-xl font-bold text-base md:text-lg shadow-md hover:bg-gray-800 active:scale-[0.98] transition-all duration-200">
                    Iniciar Sesión
                </button>
            </div>
            <footer class="mt-8 text-center">
                <a href="loginEmpresarial.jsp" class="inline-flex items-center text-sm font-semibold text-primary hover:text-blue-800 transition-colors gap-2">
                    &larr; Volver a Acceso Empresarial
                </a>
            </footer>
        </form>
    </div>
</div>

<%-- Manejo de errores con SweetAlert2 --%>
<%
    String error = (String) request.getAttribute("errorLogin");
    if (error != null) {
%>
<script>
    Swal.fire({
        icon: 'error',
        title: 'Error de acceso',
        text: '<%= error %>',
        confirmButtonColor: '#1d4ed8',
        customClass: {
            popup: 'rounded-3xl',
            confirmButton: 'rounded-xl px-10 py-3'
        }
    });
</script>
<% } %>
</body>
</html>