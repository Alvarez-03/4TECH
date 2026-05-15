package com.proyecto1.createUser.servlets;

import Logica.DAO.ProductoDAO;
import Logica.modelo.Empleado;
import Logica.modelo.Empresa;
import Logica.modelo.Producto;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SvInventario")
public class SvInventario extends HttpServlet {

    private final ProductoDAO dao = new ProductoDAO();
    
    private Long obtenerIdEmpresaDesdeSesion(HttpSession sesion) {
        Object usuario = sesion.getAttribute("usuarioLogueado");
        String permisos = (String) sesion.getAttribute("PERMISOS");

        if (usuario == null || permisos == null) return null;

        if ("EMPRESA".equals(permisos)) {
            Empresa emp = (Empresa) usuario;
            return  Long.valueOf(emp.getID());
        } else if ("EMPLEADO".equals(permisos)) {
            Empleado colab = (Empleado) usuario;
            return Long.valueOf(colab.getEmpresa_id());
        }

        return null;
    }

    private void refrescarListaSesion(HttpServletRequest req, Long idEmpresa) {
        List<Producto> lista = dao.listarPorEmpresa(idEmpresa);
        req.getSession().setAttribute("listInventario", lista);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sesion = req.getSession();

        Long idEmpresa = obtenerIdEmpresaDesdeSesion(sesion);

        if (idEmpresa != null) {
            List<Producto> lista = dao.listarPorEmpresa(idEmpresa);
            sesion.setAttribute("listInventario", lista);
            resp.sendRedirect("Inventory.jsp");
        } else {
            // Si no hay empresa en sesión, mandamos al login
            resp.sendRedirect("index.jsp");
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        HttpSession sesion = req.getSession();
        Long idEmpresaSesion = obtenerIdEmpresaDesdeSesion(sesion);

        if (idEmpresaSesion == null) {
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

    private void procesarRegistro(HttpServletRequest req, HttpServletResponse resp, Long idEmpresa) throws IOException {
        Producto p = new Producto();
        p.setNombre(req.getParameter("nombre"));
        p.setCantidad(Integer.parseInt(req.getParameter("cantidad")));
        p.setCosto(Double.parseDouble(req.getParameter("costo")));
        p.setEmpresa_id(idEmpresa);

        if (dao.registrar(p) > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Producto registrado exitosamente");
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo registrar el producto");
        }
    }

    private void procesarActualizacion(HttpServletRequest req, HttpServletResponse resp, Long idEmpresa) throws IOException {
        Producto p = new Producto();
        p.setProducto_id(Long.parseLong(req.getParameter("producto_id")));
        p.setNombre(req.getParameter("nombre"));
        p.setCantidad(Integer.parseInt(req.getParameter("cantidad")));
        p.setCosto(Double.parseDouble(req.getParameter("costo")));
        p.setEmpresa_id(idEmpresa); // Validamos que pertenezca a la misma empresa

        if (dao.actualizar(p) > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Producto actualizado");
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al actualizar");
        }
    }

    private void procesarEliminacion(HttpServletRequest req, HttpServletResponse resp, Long idEmpresa) throws IOException {
        long idProd = Long.parseLong(req.getParameter("producto_id"));

        if (dao.eliminar(idProd, idEmpresa) > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Producto eliminado");
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo eliminar");
        }
    }
}
