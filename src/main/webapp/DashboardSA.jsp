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
    <title>DASHBOARD | SUPER ADMIN</title>
</head>
<body class="min-h-screen">
    <%
        String PERMISOS_DASH= (session.getAttribute("PERMISOS") != null)
            ? (String)session.getAttribute("PERMISOS")
            : "EMPRESA";

        if (PERMISOS_DASH.equals("SUPERADMIN")) {
            request.setAttribute("titulo", "Dashboard Super Admin");
        } else{
            String EMPRESA = (session.getAttribute("EMPRESA") != null)
            ? (String)session.getAttribute("EMPRESA")
            : "4TECH";
            request.setAttribute("titulo", EMPRESA);
        }
    %>
    <%@include file="/Components/header.jsp" %>
    <%@include file="/Components/buttoncard.jsp"%>
    <%@include file="Components/modalform.jsp" %>
</body>
</html>
