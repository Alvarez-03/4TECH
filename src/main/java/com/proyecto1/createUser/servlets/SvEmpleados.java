package com.proyecto1.createUser.servlets;

import Logica.modelo.Empleado;
import Logica.DAO.EmpleadoDAO;
import Logica.modelo.Empresa;

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
        Integer idEmpresaSesion = (Integer) sesion.getAttribute("ID_EMPRESA");
        String accion = request.getParameter("accion");

        List<Empleado> lista;

        if ("listarPorEmpresaJSON".equals(accion)) {
            // Obtenemos el objeto de la sesión que guardamos en el login
            Empresa empLogueada = (Empresa) sesion.getAttribute("usuarioLogueado");

            if (empLogueada != null) {
                System.out.println("ID EMPRESA ENCONTRADO: " + empLogueada.getID());
            } else {
                System.out.println("ERROR: La sesión 'usuarioLogueado' está VACÍA.");
            }

            StringBuilder json = new StringBuilder("[");
            if (empLogueada != null) {
                List<Empleado> listaEmp = dao.listarPorEmpresa(empLogueada.getID());
                boolean primero = true;

                for (Empleado emp : listaEmp) {
                    if ("ACTIVO".equals(emp.getEstado())) {
                        if (!primero) json.append(",");
                        json.append("{")
                                .append("\"id\":").append(emp.getID())
                                .append(", \"nombre\":\"").append(emp.getNombre()).append("\"")
                                .append(", \"cargo\":\"").append(emp.getCargo()).append("\"")
                                .append("}");
                        primero = false;
                    }
                }
            }
            json.append("]");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());
            return; // IMPORTANTE: Cortamos la ejecución para no hacer el redirect
        }

        if (idEmpresaSesion != null) {
            // Si hay una empresa logueada, solo ve sus empleados
            lista = dao.listarPorEmpresa(idEmpresaSesion);
        } else {
            // Si es SuperAdmin o no hay filtro, ve todos
            lista = dao.listar();
        }

        // 2. Guardar lista en sesión y redirigir al JSP
        sesion.setAttribute("listEmpleados", lista);
        response.sendRedirect("AdminEmpleados.jsp");
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
                case "actualizar":
                    actualizarEmpleado(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    break;
            }
        }
    }

    private void registrarEmpleado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Capturar datos del formulario
        int ID = Integer.parseInt(req.getParameter("ID"));
        String nombre = req.getParameter("nombre");
        String email = req.getParameter("email");
        String telefono = req.getParameter("telefono");
        String cargo = req.getParameter("cargo");
        String password = req.getParameter("password");
        int empresaId = Integer.parseInt(req.getParameter("empresa_id"));

        Empleado nuevo = new Empleado();
        nuevo.setID(ID);
        nuevo.setNombre(nombre);
        nuevo.setEmail(email);
        nuevo.setTelefono(telefono);
        nuevo.setCargo(cargo);
        nuevo.setPassword(password);
        nuevo.setEstado("ACTIVO");
        nuevo.setEmpresa_id(empresaId);

        int res = dao.registrar(nuevo);

        if (res > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void actualizarEmpleado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // 1. Capturar datos (Igual que el registro)
            int ID = Integer.parseInt(req.getParameter("ID"));
            String nombre = req.getParameter("nombre");
            String email = req.getParameter("email");
            String telefono = req.getParameter("telefono");
            String cargo = req.getParameter("cargo");
            String password = req.getParameter("password");
            int empresaId = Integer.parseInt(req.getParameter("empresa_id"));

            // 2. Crear objeto con los datos
            Empleado empEdit = new Empleado();
            empEdit.setID(ID);
            empEdit.setNombre(nombre);
            empEdit.setEmail(email);
            empEdit.setTelefono(telefono);
            empEdit.setCargo(cargo);
            empEdit.setPassword(password);
            empEdit.setEmpresa_id(empresaId);

            // 3. Ejecutar actualización
            int res = dao.actualizar(empEdit);

            if (res > 0) {
                resp.setStatus(HttpServletResponse.SC_OK);
            } else {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            System.err.println("Error en Servlet Actualizar: " + e);
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
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
