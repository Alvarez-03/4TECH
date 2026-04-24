package com.proyecto1.createUser.servlets;

import Logica.modelo.Empresa;
import Logica.DAO.EmpresaDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Objects;

@WebServlet("/SvUsuarios")
public class SvUsuarios extends HttpServlet {

    // El GET lo usaremos para LISTAR las empresas en el Dashboard
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        EmpresaDAO dao = new EmpresaDAO();

        // 1. Respuesta rápida JSON para el select del modal de empleados
        if ("listarActivas".equals(accion)) {
            List<Empresa> lista = dao.listar();
            StringBuilder json = new StringBuilder("[");
            boolean primero = true;

            for (Empresa e : lista) {
                if ("ACTIVO".equals(e.getEstado())) {
                    if (!primero) json.append(",");
                    // Usamos e.getId() que es el valor automático de la BD
                    json.append("{\"id\":").append(e.getID())
                            .append(", \"nombre\":\"").append(e.getNombre()).append("\"}");
                    primero = false;
                }
            }
            json.append("]");

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(json.toString());
            return;
        }

        // 2. Listado normal para la tabla de Administrar Empresas
        List<Empresa> lista = dao.listar();
        HttpSession sesion = req.getSession();
        sesion.setAttribute("listEmpresa", lista);
        resp.sendRedirect("AdministrarEmpresas.jsp");
    }

    // El POST lo usaremos para el LOGIN o para REGISTRAR (según un parámetro)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion"); // Usaremos este campo oculto para saber qué hacer

        if ("login".equals(accion)) {
            procesarLogin(req, resp);
        } else if ("registrar".equals(accion)) {
            procesarRegistro(req, resp);
        } else if ("actualizarEmp".equals(accion)) {
            procesarEdicion(req, resp);
        }
    }

    private void procesarLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        EmpresaDAO dao = new EmpresaDAO();
        Empresa empresaLogueada = dao.validarAcceso(email, password);

        if (empresaLogueada != null) {
            HttpSession sesion = req.getSession();

            sesion.setAttribute("usuarioLogueado", empresaLogueada);

            if (Objects.equals(email, "superadmin@gmail.com")) {
                sesion.setAttribute("PERMISOS", "SUPERADMIN");
                resp.sendRedirect("DashboardSA.jsp");
            } else {
                sesion.setAttribute("PERMISOS", "EMPRESA");
                resp.sendRedirect("DashboardSA.jsp");
            }
        } else {
            req.setAttribute("errorLogin", "Correo o contraseña incorrectos.");
            req.getRequestDispatcher("index.jsp").forward(req, resp);
        }
    }

    private void procesarRegistro(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String nombre = req.getParameter("nombre");
        String ciudad = req.getParameter("ciudad");
        String direccion = req.getParameter("direccion");
        Integer telefono = Integer.valueOf(req.getParameter("telefono"));
        String siglas = req.getParameter("siglas");
        String password = req.getParameter("password");

        String fechaActual = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());

        Empresa nuevaEmp = new Empresa();
        nuevaEmp.setEmail(email);
        nuevaEmp.setNombre(nombre);
        nuevaEmp.setCiudad(ciudad);
        nuevaEmp.setDireccion(direccion);
        nuevaEmp.setTelefono(telefono);
        nuevaEmp.setSiglas(siglas);
        nuevaEmp.setEstado("ACTIVO");
        nuevaEmp.setCreated_at(fechaActual);
        nuevaEmp.setUpdate_at(fechaActual);
        nuevaEmp.setPassword(password);

        EmpresaDAO dao = new EmpresaDAO();
        int resultado = dao.registrar(nuevaEmp);

        if (resultado > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Registro completado");
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void procesarEdicion(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Capturar datos del request
        String email = req.getParameter("email");
        String nombre = req.getParameter("nombre");
        String estado = req.getParameter("estado");
        String ciudad = req.getParameter("ciudad");
        String direccion = req.getParameter("direccion");
        Integer telefono = Integer.valueOf(req.getParameter("telefono"));
        String siglas = req.getParameter("siglas");
        String password = req.getParameter("password");

        // 2. Instanciar usando el constructor vacío que acabamos de crear
        Empresa empEditada = new Empresa();

        // 3. Llenar los datos
        empEditada.setEmail(email);
        empEditada.setNombre(nombre);
        empEditada.setEstado(estado);
        empEditada.setCiudad(ciudad);
        empEditada.setDireccion(direccion);
        empEditada.setTelefono(telefono);
        empEditada.setSiglas(siglas);

        // Solo asignar password si el usuario escribió algo en el modal
        if(password != null && !password.trim().isEmpty()) {
            empEditada.setPassword(password);
        }

        // 4. Enviar al DAO
        EmpresaDAO dao = new EmpresaDAO();
        int resultado = dao.actualizar(empEditada);

        if (resultado > 0) {
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


}