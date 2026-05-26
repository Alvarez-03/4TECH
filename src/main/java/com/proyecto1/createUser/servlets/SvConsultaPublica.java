package com.proyecto1.createUser.servlets;

import Logica.DAO.OrdenServicioDAO;
import Logica.DAO.EmpresaDAO;
import Logica.modelo.OrdenServicio;
import Logica.modelo.Empresa;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.math.BigInteger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SvConsultaPublica")
public class SvConsultaPublica extends HttpServlet {
    OrdenServicioDAO dao = new OrdenServicioDAO();
    EmpresaDAO empDao = new EmpresaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String criterio = request.getParameter("criterio");

        if (criterio != null && !criterio.trim().isEmpty()) {
            List<OrdenServicio> resultados = dao.consultarPublico(criterio.trim());

            Map<BigInteger, String> mapaEmpresas = new HashMap<>();

            for (OrdenServicio ord : resultados) {
                Empresa emp = empDao.buscarPorId(ord.getEmpresa_id());

                if (emp != null) {

                    mapaEmpresas.put(ord.getIDorden(), emp.getNombre());
                } else {
                    mapaEmpresas.put(ord.getIDorden(), "4TECH");
                }
            }

            // Enviamos los datos limpios a la vista JSP
            request.setAttribute("listaOrdenes", resultados);
            request.setAttribute("mapaEmpresas", mapaEmpresas);
            request.setAttribute("criterioBuscado", criterio);
        }

        request.getRequestDispatcher("Consulta.jsp").forward(request, response);
    }
}