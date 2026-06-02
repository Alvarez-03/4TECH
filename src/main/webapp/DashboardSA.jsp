<%@ page import="Logica.modelo.Empresa" %>
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
    <title>DASHBOARD</title>
</head>
<body class="min-h-screen">
    <%
        String PERMISOS_DASH = (session.getAttribute("PERMISOS") != null)
                ? (String) session.getAttribute("PERMISOS")
                : "EMPRESA";
        Object userObj = session.getAttribute("usuarioLogueado");

        if ("SUPERADMIN".equals(PERMISOS_DASH)) {
            request.setAttribute("titulo", "Dashboard Super Admin");
        } else if ("EMPLEADO".equals(PERMISOS_DASH)) {
            // Manejo para el Empleado
            if (userObj instanceof Logica.modelo.Empleado) {
                Logica.modelo.Empleado empTec = (Logica.modelo.Empleado) userObj;
                request.setAttribute("titulo", empTec.getNombre());
            } else {
                request.setAttribute("titulo", "Panel Técnico");
            }
        }
        else {
            // Manejo para la Empresa
            if (userObj instanceof Logica.modelo.Empresa) {
                Logica.modelo.Empresa empresa = (Logica.modelo.Empresa) userObj;
                request.setAttribute("titulo", empresa.getNombre());
            } else {
                request.setAttribute("titulo", "Panel de Empresa");
            }
        }
    %>
    <%@include file="/Components/header.jsp" %>
    <%@include file="/Components/buttoncard.jsp"%>
    <%@include file="Components/modalform.jsp" %>
</body>
</html>
