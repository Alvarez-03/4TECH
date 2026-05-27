package com.proyecto1.createUser.servlets;

import Logica.DAO.ProveedorDAO;
import Logica.modelo.Empleado;
import Logica.modelo.Empresa;
import Logica.modelo.Proveedor;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SvProveedores")
public class SvProveedores extends HttpServlet {

    private final ProveedorDAO dao = new ProveedorDAO();

    // Modificado para retornar -1 en lugar de null si la sesión no es válida
    private int obtenerIdEmpresaDesdeSesion(HttpSession sesion) {
        Object usuario = sesion.getAttribute("usuarioLogueado");
        String permisos = (String) sesion.getAttribute("PERMISOS");

        if (usuario == null || permisos == null) return -1;

        if ("EMPRESA".equals(permisos)) {
            Empresa emp = (Empresa) usuario;
            return emp.getID(); // Retorna int directamente
        } else if ("EMPLEADO".equals(permisos)) {
            Empleado colab = (Empleado) usuario;
            return colab.getEmpresa_id(); // Retorna int directamente
        }

        return -1;
    }

    // Cambiado el tipo del parámetro a int
    private void refrescarListaSesion(HttpServletRequest req, int idEmpresa) {
        List<Proveedor> lista = dao.listarPorEmpresa(idEmpresa);
        req.getSession().setAttribute("listProveedores", lista);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sesion = req.getSession();
        int idEmpresa = obtenerIdEmpresaDesdeSesion(sesion);

        // Como es int, validamos que sea mayor que -1 (es decir, una sesión válida)
        if (idEmpresa != -1) {
            List<Proveedor> lista = dao.listarPorEmpresa(idEmpresa);

            // POR SI SE SOLICITA EL FORMATO JSON (Útil para selects dinámicos en Productos)
            String format = req.getParameter("format");
            if ("json".equals(format)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");

                StringBuilder json = new StringBuilder();
                json.append("[");
                for (int i = 0; i < lista.size(); i++) {
                    Proveedor p = lista.get(i);
                    json.append("{");
                    json.append("\"id\":").append(p.getIdProveedor()).append(",");
                    json.append("\"nombreEmpresa\":\"").append(p.getNombreEmpresa().replace("\"", "\\\"")).append("\",");
                    json.append("\"contacto\":\"").append(p.getContactoAsesor() != null ? p.getContactoAsesor().replace("\"", "\\\"") : "").append("\",");
                    json.append("\"telefono\":\"").append(p.getTelefonoContacto()).append("\"");
                    json.append("}");
                    if (i < lista.size() - 1) {
                        json.append(",");
                    }
                }
                json.append("]");

                resp.getWriter().write(json.toString());
                return;
            }

            sesion.setAttribute("listProveedores", lista);
            resp.sendRedirect("Suppliers.jsp");
        } else {
            resp.sendRedirect("loginEmpresarial.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        HttpSession sesion = req.getSession();
        int idEmpresaSesion = obtenerIdEmpresaDesdeSesion(sesion);

        if (idEmpresaSesion == -1) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Sesión no válida");
            return;
        }

        try {
            switch (accion) {
                case "registrar":
                    procesarRegistro(req, resp, idEmpresaSesion);
                    refrescarListaSesion(req, idEmpresaSesion);
                    break;
                case "actualizar":
                    procesarActualizacion(req, resp, idEmpresaSesion);
                    refrescarListaSesion(req, idEmpresaSesion);
                    break;
                case "eliminar":
                    procesarEliminacion(req, resp, idEmpresaSesion);
                    refrescarListaSesion(req, idEmpresaSesion);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no reconocida");
            }
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }

    private void procesarRegistro(HttpServletRequest req, HttpServletResponse resp, int idEmpresa) throws IOException {
        Proveedor p = new Proveedor();
        p.setNombreEmpresa(req.getParameter("nombre_empresa"));
        p.setContactoAsesor(req.getParameter("contacto_asesor"));
        p.setTelefonoContacto(req.getParameter("telefono_contacto"));
        p.setEmpresaId(idEmpresa); // CORREGIDO: Antes guardabas idEmpresa en idProveedor. Debe ser en EmpresaId.

        if (dao.registrar(p) > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Proveedor registrado exitosamente");
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo registrar el proveedor");
        }
    }

    private void procesarActualizacion(HttpServletRequest req, HttpServletResponse resp, int idEmpresa) throws IOException {
        Proveedor p = new Proveedor();
        p.setIdProveedor(Integer.parseInt(req.getParameter("IDproveedor"))); // int nativo
        p.setNombreEmpresa(req.getParameter("nombre_empresa"));
        p.setContactoAsesor(req.getParameter("contacto_asesor"));
        p.setTelefonoContacto(req.getParameter("telefono_contacto"));
        p.setEmpresaId(idEmpresa);

        if (dao.actualizar(p) > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Proveedor actualizado");
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al actualizar");
        }
    }

    private void procesarEliminacion(HttpServletRequest req, HttpServletResponse resp, int idEmpresa) throws IOException {
        int idProv = Integer.parseInt(req.getParameter("IDproveedor")); // CORREGIDO: Cambiado de long a int

        if (dao.eliminar(idProv, idEmpresa) > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Proveedor eliminado");
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo eliminar");
        }
    }
}