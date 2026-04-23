<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
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
</head>
<body>
<div class="bg-primary p-4 rounded-xl shadow-sm mb-6 border max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 border-gray-100">
    <div class="flex flex-col md:flex-row items-center justify-between gap-4">

        <div class="flex flex-1 w-full max-w-2xl gap-3">
            <div class="relative flex-1">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                    <i class="fa-solid fa-magnifying-glass w-5 h-5 text-gray-400"></i>
                </span>
                <input type="text"
                       placeholder="Buscar por numero de orden"
                       class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary outline-none text-sm transition-all"
                >
            </div>
        </div>

        <div class="w-full md:w-auto">
            <button data-type="FormRegisterOrd" onclick="abrirModal(this)" class="w-full inline-flex items-center justify-center px-5 py-2.5 bg-accent font-semibold text-sm rounded-lg hover:bg-accent/80 focus:outline-none focus:ring-4 focus:ring-blue-300 transition-all shadow-md active:scale-95">
                <i class="fa-solid fa-plus mx-2 text-xl"></i>
                Agregar Orden
            </button>
        </div>

    </div>
</div>
</body>
</html>
