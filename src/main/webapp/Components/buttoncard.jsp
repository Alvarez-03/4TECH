<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                    'gray-ebony': '#515751',
                }
            }
        }
    }
</script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<%
    String PERMISOS = (session.getAttribute("PERMISOS") != null)
            ? (String) session.getAttribute("PERMISOS")
            : "EMPRESA";
%>
<div class="w-full flex justify-center items-center py-12 px-4">
    <main class="max-w-4xl mx-auto py-10">
        <section class="grid grid-cols-1 md:grid-cols-3 gap-8 px-4">
            <% if (PERMISOS.equals("SUPERADMIN")) { %>
                <button class="bg-primary p-5 flex flex-col m-auto h-64 w-64 items-center justify-center aspect-square text-black font-bold rounded-3xl shadow-lg hover:scale-105 transition-transform p-6">
                    <i class="fa-solid fa-building-circle-arrow-right text-8xl mb-6"></i>
                    <span class="text-xl text-center">Registrar empresa</span>
                </button>
                <button class="bg-accent p-5 flex flex-col m-auto h-64 w-64 items-center justify-center aspect-square text-black font-bold rounded-3xl shadow-lg hover:scale-105 transition-transform p-6">
                    <i class="fa-solid fa-users-gear text-8xl mb-6"></i>
                    <span class="text-lg">Registrar trabajadores</span>
                </button>
                <button class="bg-secondary p-5 flex flex-col m-auto h-64 w-64 items-center justify-center aspect-square text-black font-bold rounded-3xl shadow-lg hover:scale-105 transition-transform p-6">
                    <i class="fa-solid fa-building-circle-exclamation text-8xl mb-6"></i>
                    <span class="text-lg ">Administrar empresas</span>
                </button>
            <% } else { %>
                <button>
                    Ordenes
                </button>
                <button>
                    Inventario
                </button>
                <button>
                    Recursos humanos
                </button>
            <%}%>
        </section>
    </main>
</div>