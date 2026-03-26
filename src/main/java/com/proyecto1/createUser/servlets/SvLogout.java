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

        // 1. Obtener la sesión y destruirla
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Esto borra TODO (Permisos, Usuario, etc.)
        }

        // 2. Mandar al usuario al login o inicio
        response.sendRedirect("index.jsp");
    }
}