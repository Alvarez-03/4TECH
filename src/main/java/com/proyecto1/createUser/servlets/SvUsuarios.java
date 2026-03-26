package com.proyecto1.createUser.servlets;

import Logica.Empresa;
import Logica.EmpresaDAO;
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
        EmpresaDAO dao = new EmpresaDAO();
        List<Empresa> lista = dao.listar();

        HttpSession sesion = req.getSession();
        sesion.setAttribute("listEmpresa", lista);
        resp.sendRedirect("DashboardSA.jsp");
    }

    // El POST lo usaremos para el LOGIN o para REGISTRAR (según un parámetro)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion"); // Usaremos este campo oculto para saber qué hacer

        if ("login".equals(accion)) {
            procesarLogin(req, resp);
        } else if ("registrar".equals(accion)) {
            procesarRegistro(req, resp);
        }
    }

    private void procesarLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        EmpresaDAO dao = new EmpresaDAO();
        boolean puedeEntrar = dao.validarAcceso(email, password);

        if (puedeEntrar) {
            HttpSession sesion = req.getSession();
            // Lógica de permisos
            if (Objects.equals(email, "superadmin@gmail.com")) {
                sesion.setAttribute("PERMISOS", "SUPERADMIN");
                resp.sendRedirect("DashboardSA.jsp");
            } else {
                sesion.setAttribute("PERMISOS", "EMPRESA");
                resp.sendRedirect("index.jsp");
            }
        } else {
            req.setAttribute("errorLogin", "Correo o contraseña incorrectos.");
            req.getRequestDispatcher("index.jsp").forward(req, resp);
        }
    }

    private void procesarRegistro(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Obtener Datos del formulario
        String email = req.getParameter("email");
        String nombre = req.getParameter("nombre");
        String ciudad = req.getParameter("ciudad");
        String direccion = req.getParameter("direccion");

        // Manejo de error si el teléfono viene vacío
        Integer telefono = Integer.valueOf(req.getParameter("telefono"));


        String siglas = req.getParameter("siglas");
        String estado = "ACTIVO"; // Por defecto al registrar

        // Generar fechas automáticamente si no vienen del form
        String fechaActual = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
        String created_at = fechaActual;
        String update_at = fechaActual;

        String password = req.getParameter("password");

        // 2. Empaquetar con el constructor completo que definiste en tu clase Empresa
        Empresa nuevaEmp = new Empresa(email, nombre, ciudad, direccion, telefono, siglas, estado, created_at, update_at, password);

        // 3. Guardar en la BD
        EmpresaDAO dao = new EmpresaDAO();
        int resultado = dao.registrar(nuevaEmp);

        if (resultado > 0) {
            // En lugar de redirigir, mandamos un código 200 (OK)
            resp.setStatus(HttpServletResponse.SC_OK);
            // Opcional: puedes enviar un mensaje de texto
            resp.getWriter().write("Registro completado");
        } else {
            // Mandamos un código de error
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al guardar");
        }
    }
}