<%@ page import="Logica.modelo.Empresa" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <link href="https://cdn.tailwindcss.com" rel="stylesheet">
    <script src="resources/ControlModal.js"></script>
</head>
    <%String permisos = (String) session.getAttribute("PERMISOS");%>
<body>
    <div id="miModal" class="hidden fixed inset-0 z-50 overflow-auto flex items-center justify-center bg-black bg-opacity-50 transition-opacity duration-300" aria-labelledby="modal-title" role="dialog"  aria-modal="true">
        <div id="modalContent"  class="bg-white rounded-lg shadow-xl w-full max-w-4xl p-6 transition-all transform scale-95 opacity-0"><![CDATA[

            <%--    //formulario para registrar y actualizar empresa--%>
            <%@include file="/Components/FormModals/FormEmps.jsp" %>

            <%--    //formulario para registrar y actualizar colaborador--%>
            <%@include file="/Components/FormModals/FormColabs.jsp" %>

            <%--    //formulario para registrar y actualizar orden--%>
            <% if (permisos.equals("EMPRESA") || permisos.equals("EMPLEADO")){%>
                <%@include file="FormModals/FormOrders.jsp" %>
                <%@include file="FormModals/FormInventario.jsp"%>
            <%}%>
        </div>
    </div>
</body>