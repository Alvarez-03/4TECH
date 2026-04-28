package com.proyecto1.createUser.servlets;

import javax.servlet.annotation.WebServlet;
import Logica.modelo.Cliente;
import Logica.DAO.ClienteDAO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SvClientes")
public class SvClientes extends HttpServlet {
    ClienteDAO cDao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String doc = request.getParameter("documento");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Cliente c = cDao.buscar(doc);
        if (c != null) {

            String json = String.format(
                    "{\"documento\":\"%s\", \"nombre\":\"%s\", \"telefono\":\"%s\", \"email\":\"%s\"}",
                    c.getDocumento(), c.getNombre(), c.getTelefono(), c.getEmail()
            );
            response.getWriter().write(json);
        } else {
            response.getWriter().write("{}"); // Vacío si no existe
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("accion");
        Cliente c = new Cliente();
        c.setDocumento(request.getParameter("documento"));
        c.setNombre(request.getParameter("nombre"));
        c.setTelefono(request.getParameter("telefono"));
        c.setEmail(request.getParameter("email"));
        c.setEstado(request.getParameter("estado"));

        int resultado;
        if ("actualizar".equals(action)) {
            resultado = cDao.actualizar(c);
        } else {
            resultado = cDao.registrar(c);
        }

        if (resultado > 0) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
