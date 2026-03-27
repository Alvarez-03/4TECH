package com.proyecto1.createUser.servlets;

import Logica.Empleado;
import Logica.EmpleadoDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SvEmpleados")
public class SvEmpleados extends HttpServlet {

    EmpleadoDAO dao = new EmpleadoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();

        // 1. Obtener el ID de la empresa de la sesión (asumiendo que lo guardaste al loguear)
        // Si no tienes el ID en sesión, por ahora listaremos todos
        Integer idEmpresaSesion = (Integer) sesion.getAttribute("ID_EMPRESA");

        List<Empleado> lista;

        if (idEmpresaSesion != null) {
            // Si hay una empresa logueada, solo ve sus empleados
            lista = dao.listarPorEmpresa(idEmpresaSesion);
        } else {
            // Si es SuperAdmin o no hay filtro, ve todos
            lista = dao.listar();
        }

        // 2. Guardar lista en sesión y redirigir al JSP
        sesion.setAttribute("listEmpleados", lista);
        response.sendRedirect("AdministrarEmpleados.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion != null) {
            switch (accion) {
                case "registrar":
                    registrarEmpleado(request, response);
                    break;
                case "cambiarEstado":
                    cambiarEstadoEmpleado(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    break;
            }
        }
    }

    private void registrarEmpleado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Capturar datos del formulario
        String nombre = req.getParameter("nombre");
        String email = req.getParameter("email");
        int telefono = Integer.parseInt(req.getParameter("telefono"));
        String cargo = req.getParameter("cargo");
        String password = req.getParameter("password");
        int empresaId = Integer.parseInt(req.getParameter("empresa_id"));

        Empleado nuevo = new Empleado();
        nuevo.setNombre(nombre);
        nuevo.setEmail(email);
        nuevo.setTelefono(telefono);
        nuevo.setCargo(cargo);
        nuevo.setPassword(password);
        nuevo.setEstado("ACTIVO"); // Por defecto al registrar
        nuevo.setEmpresa_id(empresaId);

        int res = dao.registrar(nuevo);

        if (res > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void cambiarEstadoEmpleado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String estadoActual = req.getParameter("estado");

        // Si está ACTIVO pasamos a INACTIVO, y viceversa
        String nuevoEstado = estadoActual.equalsIgnoreCase("ACTIVO") ? "INACTIVO" : "ACTIVO";

        int res = dao.cambiarEstado(id, nuevoEstado);

        if (res > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(nuevoEstado); // Devolvemos el nuevo estado para JS
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
