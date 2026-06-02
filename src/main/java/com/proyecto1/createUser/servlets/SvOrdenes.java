package com.proyecto1.createUser.servlets;

import Logica.DAO.ClienteDAO;
import Logica.modelo.Cliente;
import Logica.modelo.Empleado;
import Logica.modelo.OrdenServicio;
import Logica.modelo.Empresa;
import Logica.DAO.OrdenServicioDAO;

import java.io.IOException;
import java.math.BigInteger;
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
        
        //listar productos utilizados
        String accion = request.getParameter("accion");

        if ("listarSuministros".equals(accion)) {
            String ordenIdStr = request.getParameter("ordenId");
            String tipoVista = request.getParameter("tipoVista");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (ordenIdStr != null && !ordenIdStr.isEmpty()) {
                BigInteger ordenId = new BigInteger(ordenIdStr);
                StringBuilder json = new StringBuilder();
                json.append("[");

                if ("detalles".equals(tipoVista)) {
                    List<Object[]> productosAsignados = dao.obtenerProductosConNombrePorOrden(ordenId);
                    for (int i = 0; i < productosAsignados.size(); i++) {
                        Object[] item = productosAsignados.get(i); // [id, nombre, cantidad]
                        json.append("{");
                        json.append("\"producto_id\":").append(item[0]).append(",");
                        json.append("\"nombre\":\"").append(item[1].toString().replace("\"", "\\\"")).append("\",");
                        json.append("\"cantidad\":").append(item[2]);
                        json.append("}");
                        if (i < productosAsignados.size() - 1) json.append(",");
                    }
                }
                else {
                    List<long[]> productosAsignados = dao.obtenerProductosPorOrden(ordenId);
                    for (int i = 0; i < productosAsignados.size(); i++) {
                        long[] item = productosAsignados.get(i); // [id, cantidad]
                        json.append("{");
                        json.append("\"producto_id\":").append(item[0]).append(",");
                        json.append("\"cantidad\":").append(item[1]);
                        json.append("}");
                        if (i < productosAsignados.size() - 1) json.append(",");
                    }
                }

                json.append("]");
                response.getWriter().write(json.toString());
            } else {
                response.getWriter().write("[]");
            }
            return;
        }
        
        HttpSession sesion = request.getSession();
        String permisos = (String) sesion.getAttribute("PERMISOS");
        Object usuario = sesion.getAttribute("usuarioLogueado");

        if (usuario == null || permisos == null) {
            response.sendRedirect("loginEmpresarial.jsp");
            return;
        }

        List<OrdenServicio> lista = null;

        if ("EMPRESA".equals(permisos)) {
            Empresa emp = (Empresa) usuario;
            lista = dao.listarPorEmpresa(emp.getID());
        } else if ("EMPLEADO".equals(permisos)) {
            Empleado mple = (Empleado) usuario;
            lista = dao.listarPorEmpleado((int) mple.getID());
        }

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
        }

        HttpSession sesion = req.getSession();
        Empresa empLogueada = (Empresa) sesion.getAttribute("usuarioLogueado");
        long empleado_id = Long.parseLong(req.getParameter("empleado_id"));

        try {
            OrdenServicio nueva = new OrdenServicio();
            nueva.setReporte(req.getParameter("reporte"));
            nueva.setDiagnostico(req.getParameter("diagnostico"));
            nueva.setObservaciones(req.getParameter("observaciones"));
            nueva.setEstado_actual(req.getParameter("estado_actual"));
            nueva.setEmpleado_id((int) empleado_id);
            nueva.setEmpresa_id(empLogueada.getID());
            nueva.setCliente_id(docCliente);

            // Intentamos guardar la orden base y capturamos su BigInteger auto-generado
            BigInteger idGenerado = dao.guardar(nueva);

            if (idGenerado != null) {
                // Recuperamos las listas del inventario enviadas por el Step Form
                String[] prodIds = req.getParameterValues("prod_ids[]");
                String[] cantidades = req.getParameterValues("prod_cantidades[]");

                // Procesamos los suministros consumidos disminuyendo stock
                boolean stockProcesado = dao.guardarProductosOrden(idGenerado, prodIds, cantidades);

                if (stockProcesado) {
                    req.getSession().removeAttribute("listaOrdenes");
                    resp.setStatus(HttpServletResponse.SC_OK);
                } else {
                    resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "La orden se creó, pero ocurrió un problema al procesar el inventario.");
                }
            } else {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo guardar la orden de servicio.");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Error: " + e.getMessage());
        }
    }

    private void actualizarOrden(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idStr = req.getParameter("ID");
            BigInteger idOrden = new BigInteger(idStr);

            OrdenServicio ordenEditada = new OrdenServicio();
            ordenEditada.setIDorden(idOrden);
            ordenEditada.setReporte(req.getParameter("reporte"));
            ordenEditada.setDiagnostico(req.getParameter("diagnostico"));
            ordenEditada.setObservaciones(req.getParameter("observaciones"));
            ordenEditada.setEstado_actual(req.getParameter("estado_actual"));
            ordenEditada.setEmpleado_id(Integer.parseInt(req.getParameter("empleado_id")));

            int res = dao.actualizar(ordenEditada);

            if (res > 0) {
                // 1. Revertimos cantidades al stock físico y limpiamos registros viejos de la tabla intermedia
                dao.reestablecerStockSuministros(idOrden);

                // 2. Capturamos el nuevo listado de repuestos de la vista de edición
                String[] prodIds = req.getParameterValues("prod_ids[]");
                String[] cantidades = req.getParameterValues("prod_cantidades[]");

                // 3. Insertamos el listado final actualizado aplicando los nuevos descuentos
                dao.guardarProductosOrden(idOrden, prodIds, cantidades);

                req.getSession().removeAttribute("listaOrdenes");
                resp.setStatus(HttpServletResponse.SC_OK);
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