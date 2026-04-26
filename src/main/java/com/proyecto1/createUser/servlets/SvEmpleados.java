package com.proyecto1.createUser.servlets;

import Logica.modelo.Empleado;
import Logica.DAO.EmpleadoDAO;
import Logica.modelo.Empresa;

import java.io.IOException;
import java.util.ArrayList;
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
        // 1. Obtener el usuario logueado (Empresa)
        Empresa empLogueada = (Empresa) sesion.getAttribute("usuarioLogueado");
        // 2. Obtener los permisos (Si es SuperAdmin)
        String permisos = (String) sesion.getAttribute("PERMISOS");

        List<Empleado> lista = null;

        // Lógica para el JSON (Selección en modales)
        String accion = request.getParameter("accion");
        if ("listarPorEmpresaJSON".equals(accion)) {

            if (empLogueada == null) {
                System.out.println("ERROR: La sesión 'usuarioLogueado' está VACÍA.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            List<Empleado> listaEmp = dao.listarPorEmpresa(empLogueada.getID());

            StringBuilder json = new StringBuilder("[");
            boolean primero = true;

            for (Empleado emp : listaEmp) {
                if ("ACTIVO".equalsIgnoreCase(emp.getEstado())) {
                    if (!primero) json.append(",");
                    json.append("{")
                            .append("\"id\":").append(emp.getID())
                            .append(", \"nombre\":\"").append(emp.getNombre()).append("\"")
                            .append(", \"cargo\":\"").append(emp.getCargo()).append("\"")
                            .append("}");
                    primero = false;
                }
            }
            json.append("]");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());

            return;
        }
        
        
        if ("SUPERADMIN".equals(permisos)) {
            lista = dao.listar(); 
        } else if (empLogueada != null) {
            lista = dao.listarPorEmpresa(empLogueada.getID());
            sesion.setAttribute("EMPRESA", empLogueada.getNombre());
        } else {
            lista = new ArrayList<>(); 
        }

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
        try {
            HttpSession sesion = req.getSession();
            Empresa empLogueada = (Empresa) sesion.getAttribute("usuarioLogueado");
            String permisos = (String) sesion.getAttribute("PERMISOS");

            int empresaId;

            if ("SUPERADMIN".equals(permisos)) {
                empresaId = Integer.parseInt(req.getParameter("empresa_id"));
            } else {
                empresaId = empLogueada.getID();
            }

            int ID = Integer.parseInt(req.getParameter("ID"));
            String nombre = req.getParameter("nombre");
            String email = req.getParameter("email");
            String telefono = req.getParameter("telefono");
            String cargo = req.getParameter("cargo");
            String password = req.getParameter("password");

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
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            System.err.println("Error en registro: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void actualizarEmpleado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            HttpSession sesion = req.getSession();
            Empresa empLogueada = (Empresa) sesion.getAttribute("usuarioLogueado");
            String permisos = (String) sesion.getAttribute("PERMISOS");

            // 1. Capturar ID del empleado (Obligatorio)
            String idStr = req.getParameter("ID");
            if (idStr == null || idStr.isEmpty()) {
                throw new Exception("ID de empleado no recibido.");
            }
            int ID = Integer.parseInt(idStr);


            // 3. Capturar el resto de datos
            String nombre = req.getParameter("nombre");
            String email = req.getParameter("email");
            String telefono = req.getParameter("telefono");
            String cargo = req.getParameter("cargo");
            String password = req.getParameter("password");

            // 4. Crear objeto y asignar valores
            Empleado empEdit = new Empleado();
            empEdit.setID(ID);
            empEdit.setNombre(nombre);
            empEdit.setEmail(email);
            empEdit.setTelefono(telefono);
            empEdit.setCargo(cargo);

            // Manejo de contraseña: Si llega vacía, podrías mantener la anterior
            // (dependiendo de cómo funcione tu DAO, aquí la seteamos tal cual llega)
            empEdit.setPassword(password != null ? password : "");

            // 5. Ejecutar actualización
            int res = dao.actualizar(empEdit);

            if (res > 0) {
                // Limpiamos la lista en sesión para que se recargue con los datos nuevos
                sesion.removeAttribute("listEmpleados");
                resp.setStatus(HttpServletResponse.SC_OK);
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            System.err.println("Error en Servlet Actualizar: " + e);
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Error: " + e.getMessage());
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
