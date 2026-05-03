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
<body class="bg-gray-50 min-h-screen flex flex-col justify-center font-sans">

<div class="w-full max-w-sm mx-auto px-6">

    <header class="text-center mb-10">
        <div class="flex justify-center mb-4">
            <img src="IMG/4TECH.png" alt="logo4TECH" class="w-32 h-auto">
        </div>
        <h1 class="text-2xl font-bold text-gray-900">Panel Técnico</h1>
        <p class="text-gray-500 mt-2">Ingresa para gestionar tus órdenes</p>
    </header>

    <div class="bg-white p-8 rounded-2xl shadow-xl border border-gray-100">
        <form action="SvEmpleados" method="POST" class="space-y-5">
            <input type="hidden" name="accion" value="loginEmpleado">

            <div>
                <label for="email" class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1 ml-1">Correo Electrónico</label>
                <input id="email" type="email" name="email" required
                       class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary focus:bg-white outline-none transition-all"
                       placeholder="nombre@4tech.com" />
            </div>

            <div>
                <label for="password" class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1 ml-1">Contraseña</label>
                <input id="password" type="password" name="password" required
                       class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary focus:bg-white outline-none transition-all"
                       placeholder="••••••••" />
            </div>

            <div class="pt-2">
                <button type="submit"
                        class="w-full bg-gray-900 text-white py-4 rounded-xl font-bold text-lg active:scale-95 transition-transform shadow-lg">
                    Iniciar Sesión
                </button>
            </div>
        </form>
    </div>

    <footer class="mt-8 text-center">
        <a href="index.jsp" class="text-sm font-semibold text-primary hover:text-blue-800 transition-colors">
            &larr; Volver a Acceso Empresarial
        </a>
    </footer>
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