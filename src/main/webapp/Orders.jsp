<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="icon" type="image/png" href="IMG/4TECH.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">

    <script src="resources/ControlModal.js"></script>

    <meta charset="utf-8">
    <title>Ordenes</title>
</head>
<body>
    <%@include file="/Components/header.jsp" %>
    <%@include file="Components/modalform.jsp" %>
    <section class="mx-4 mt-3">
        <%@include file="/Components/actionBar.jsp" %>
    </section>

    <main class="flex flex-col justify-center gap-5 md:flex-row w-full h-screen mb-3">
        <section class=" rounded-xl bg-gray-600 md:w-[30%] p-2">
            <div class="flex flex-col items-center justify-center h-full text-white p-10">
                <i class="fa-solid fa-circle-exclamation text-8xl mb-6 opacity-80"></i>

                <h2 class="text-xl font-semibold text-center">No se han cargado ordenes</h2>
                <p class="text-sm text-center mt-2">Crea una orden, en caso de ser un error contacte a soporte.</p>
            </div>
        </section>

        <section class=" rounded-xl bg-gray-600 md:w-[65%] p-2">
            <div class="flex flex-col items-center justify-center h-full text-white p-10">
                <i class="fa-solid fa-circle-exclamation text-8xl mb-6 opacity-80"></i>

                <h2 class="text-xl font-semibold text-center">Selecciona una orden para ver detalles</h2>
                <p class="text-sm mt-2">Haz clic en un registro de la lista para visualizar la información completa.</p>
            </div>
        </section>
    </main>

</body>
</html>
