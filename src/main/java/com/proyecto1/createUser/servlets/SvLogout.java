package com.proyecto1.createUser.servlets;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/SvLogout")
public class SvLogout extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener la sesión actual
        HttpSession session = request.getSession(false);
        String destino = "loginEmpresarial.jsp"; // Por defecto para Empresas/Admin

        if (session != null) {
            // 2. Revisar el rol antes de borrar la sesión
            String rol = (String) session.getAttribute("PERMISOS");

            if ("EMPLEADO".equals(rol)) {
                destino = "loginEmpleados.jsp"; // Redirigir al login técnico
            }

            // 3. Ahora sí, destruimos la sesión
            session.invalidate();
        }

        // 4. Redirigir al destino correspondiente
        response.sendRedirect(destino);
    }
}