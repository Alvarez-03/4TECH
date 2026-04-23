package com.proyecto1.createUser.servlets;

import Logica.OrdenServicio;
import Logica.Empresa;
import Logica.OrdenServicioDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SvOrdenes")
public class SvOrdenes extends HttpServlet {

    OrdenServicioDAO dao = new OrdenServicioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();
        Empresa empLogueada = (Empresa) sesion.getAttribute("usuarioLogueado");

        if (empLogueada == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<OrdenServicio> lista = dao.listarPorEmpresa(empLogueada.getID());

        sesion.setAttribute("listaOrdenes", lista);

        response.sendRedirect("Orders.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            registrarOrden(request, response);
        }
    }

    private void registrarOrden(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession sesion = req.getSession();
        Empresa empLogueada = (Empresa) sesion.getAttribute("usuarioLogueado");
        System.out.println(empLogueada.getID());

        long empleado_id = Long.parseLong(req.getParameter("empleado_id"));
        System.out.println("Empleado ID: " + empleado_id);

        try {
            String reporte = req.getParameter("reporte");
            String diagnostico = req.getParameter("diagnostico");
            String observaciones = req.getParameter("observaciones");
            String estadoActual = req.getParameter("estado_actual");


            OrdenServicio nueva = new OrdenServicio();
            nueva.setReporte(reporte);
            nueva.setDiagnostico(diagnostico);
            nueva.setObservaciones(observaciones);
            nueva.setEstado_actual(estadoActual);
            nueva.setEmpleado_id((int) empleado_id);
            nueva.setEmpresa_id(empLogueada.getID());

            int res = dao.guardar(nueva);

            if (res > 0) {
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("Orden registrada exitosamente");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("Error al guardar en la base de datos");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Error: " + e.getMessage());
        }
    }
}