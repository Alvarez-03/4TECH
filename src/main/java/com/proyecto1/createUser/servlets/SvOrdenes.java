package com.proyecto1.createUser.servlets;

import Logica.DAO.ClienteDAO;
import Logica.modelo.Cliente;
import Logica.modelo.OrdenServicio;
import Logica.modelo.Empresa;
import Logica.DAO.OrdenServicioDAO;

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
        } else if ("actualizar".equals(accion)) {
            actualizarOrden(request, response);
        }
    }

    private void registrarOrden(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String docCliente = req.getParameter("documento");
        String nombreCliente = req.getParameter("nombre_cliente");
        String telCliente = req.getParameter("telefono_cliente");
        String emailCliente = req.getParameter("email_cliente");

        ClienteDAO cDao = new ClienteDAO();
        Cliente existente = cDao.buscar(docCliente);

        if (existente == null) {
            Cliente nuevo = new Cliente();
            nuevo.setDocumento(docCliente);
            nuevo.setNombre(nombreCliente);
            nuevo.setTelefono(telCliente);
            nuevo.setEmail(emailCliente);
            nuevo.setEstado("ACTIVO");

            cDao.registrar(nuevo);
            System.out.println("Cliente nuevo registrado: " + docCliente);
        }
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
            nueva.setCliente_id(docCliente);

            int res = dao.guardar(nueva);

            if (res > 0) {
                req.getSession().removeAttribute("listaOrdenes");
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

    private void actualizarOrden(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {

            String idStr = req.getParameter("ID");
            java.math.BigInteger idOrden = new java.math.BigInteger(idStr);


            String reporte = req.getParameter("reporte");
            String diagnostico = req.getParameter("diagnostico");
            String observaciones = req.getParameter("observaciones");
            String estadoActual = req.getParameter("estado_actual");
            int empleadoId = Integer.parseInt(req.getParameter("empleado_id"));


            OrdenServicio ordenEditada = new OrdenServicio();
            ordenEditada.setIDorden(idOrden);
            ordenEditada.setReporte(reporte);
            ordenEditada.setDiagnostico(diagnostico);
            ordenEditada.setObservaciones(observaciones);
            ordenEditada.setEstado_actual(estadoActual);
            ordenEditada.setEmpleado_id(empleadoId);


            int res = dao.actualizar(ordenEditada);

            if (res > 0) {
                req.getSession().removeAttribute("listaOrdenes");

                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("Orden actualizada correctamente");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("No se pudo actualizar la orden en la BD");
            }
        } catch (Exception e) {
            System.err.println("Error en Servlet Actualizar: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Error: " + e.getMessage());
        }
    }
}