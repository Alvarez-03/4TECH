package com.proyecto1.createUser.servlets;

import Logica.DAO.ReporteDAO;
import Logica.modelo.Empleado;
import Logica.modelo.Empresa;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SvDashboard")
public class SvDashboard extends HttpServlet {

    private final ReporteDAO dao = new ReporteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sesion = req.getSession();
        String permisos = (String) sesion.getAttribute("PERMISOS");
        Object usuario = sesion.getAttribute("usuarioLogueado");

        if (permisos == null || usuario == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Acceso denegado. Inicie sesión.");
            return;
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        StringBuilder json = new StringBuilder();
        json.append("{");

        String rolUniforme = permisos.toUpperCase().trim();

        if ("SUPERADMIN".equals(rolUniforme)) {
            json.append("\"totalEmpresas\":").append(dao.obtenerTotalEmpresasGlobal()).append(",");
            json.append("\"ciudades\":").append(convertirListaAManualJson(dao.obtenerEmpresasPorCiudad()));

        } else if ("EMPRESA".equals(rolUniforme)) {
            Empresa emp = (Empresa) usuario;
            int idEmpresa = emp.getID();

            json.append("\"inversionTotal\":").append(dao.obtenerInversionTotalAlmacen(idEmpresa)).append(",");
            json.append("\"stockCritico\":").append(convertirListaAManualJson(dao.obtenerStockCritico(idEmpresa))).append(",");
            json.append("\"topProductos\":").append(convertirListaAManualJson(dao.obtenerTopProductosCostosos(idEmpresa))).append(",");
            json.append("\"ordenesEstado\":").append(convertirListaAManualJson(dao.obtenerOrdenesPorEstado(idEmpresa))).append(",");
            json.append("\"itemsProveedor\":").append(convertirListaAManualJson(dao.obtenerItemsPorProveedor(idEmpresa))).append(",");
            json.append("\"rendimientoEquipo\":").append(convertirListaAManualJson(dao.obtenerRendimientoEquipo(idEmpresa)));

        } else if ("EMPLEADO".equals(rolUniforme)) {
            Empleado colab = (Empleado) usuario;
            int idEmpleado = colab.getID();
            int idEmpresa = colab.getEmpresa_id();

            json.append("\"misOrdenes\":").append(convertirListaAManualJson(dao.obtenerMisOrdenesPorEstado(idEmpleado, idEmpresa))).append(",");
            json.append("\"rendimientoEquipo\":").append(convertirListaAManualJson(dao.obtenerRendimientoEquipo(idEmpresa)));
        }

        json.append("}");
        resp.getWriter().write(json.toString());
    }

    private String convertirListaAManualJson(List<Map<String, Object>> lista) {
        if (lista == null || lista.isEmpty()) return "[]";
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < lista.size(); i++) {
            Map<String, Object> map = lista.get(i);
            sb.append("{");
            int entriesCount = 0;
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                sb.append("\"").append(entry.getKey()).append("\":");
                if (entry.getValue() == null) {
                    sb.append("null");
                } else if (entry.getValue() instanceof String) {
                    sb.append("\"").append(entry.getValue().toString().replace("\"", "\\\"").replace("\n", " ")).append("\"");
                } else {
                    sb.append(entry.getValue());
                }
                if (++entriesCount < map.size()) sb.append(",");
            }
            sb.append("}");
            if (i < lista.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
}