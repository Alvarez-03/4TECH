package com.proyecto1.createUser.servlets;

import java.io.IOException;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Logica.DAO.OrdenServicioDAO;
import Logica.DAO.ClienteDAO;
import Logica.modelo.Empresa;
import Logica.modelo.OrdenServicio;
import Logica.modelo.Cliente;
import Logica.DAO.EmailServices;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

@WebServlet("/SvFacturaPDF")
public class SvFacturaPDF extends HttpServlet {
    OrdenServicioDAO dao = new OrdenServicioDAO();
    ClienteDAO cDao = new ClienteDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();
        Empresa emp = (Empresa) sesion.getAttribute("usuarioLogueado");

        if (emp == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        String accion = request.getParameter("accion"); // <--- CAPTURAMOS LA ACCIÓN

        if (idParam == null) return;

        int idOrden = Integer.parseInt(idParam);
        OrdenServicio ord = dao.obtenerPorId(idOrden);

        // 1. Buscamos al cliente (Lo necesitamos para el diseño del PDF y para el envío)
        String docCliente = ord.getCliente_id();
        Cliente c = cDao.buscar(docCliente);

        String correoCliente = (c != null) ? c.getEmail() : "";
        String nombreCliente = (c != null) ? c.getNombre() : "Cliente 4TECH";

        // 2. Generar el HTML exacto de tu factura (El bloque de String largo que ya tienes)
        String html = "<!DOCTYPE html><html><head><style>" +
                "body { font-family: 'Arial', sans-serif; padding: 40px; color: #333; line-height: 1.5; }" +
                ".header { border-bottom: 3px solid #1d4ed8; padding-bottom: 20px; margin-bottom: 30px; display: block; }" +
                ".empresa-name { font-size: 28px; font-weight: bold; color: #1d4ed8; text-transform: uppercase; margin: 0; }" +
                ".doc-type { font-size: 14px; color: #555; font-weight: bold; margin-top: 5px; }" +
                ".order-number { float: right; font-size: 18px; color: #333; }" +
                ".info-grid { margin-top: 20px; background: #f9fafb; padding: 15px; border-radius: 8px; }" +
                ".info-item { font-size: 13px; margin: 5px 0; }" +
                ".table { width: 100%; border-collapse: collapse; margin-top: 25px; table-layout: fixed; }" +
                ".table th { background-color: #1d4ed8; color: white; padding: 10px; text-align: left; font-size: 12px; border: 1px solid #1d4ed8; }" +
                ".table td { border: 1px solid #e5e7eb; padding: 15px; text-align: left; font-size: 13px; vertical-align: top; word-wrap: break-word; }" +
                ".footer { margin-top: 60px; text-align: center; font-size: 11px; color: #9ca3af; border-top: 1px solid #e5e7eb; padding-top: 20px; }" +
                "</style></head><body>" +
                "<div class='header'>" +
                "  <div class='order-number'><strong>ORD-" + String.format("%04d", idOrden) + "</strong></div>" +
                "  <h1 class='empresa-name'>" + emp.getNombre() + "</h1>" +
                "  <div class='doc-type'>COMPROBANTE DE ORDEN DE SERVICIO</div>" +
                "</div>" +
                "<div class='info-grid'>" +
                "  <div class='info-item'><strong>IDENTIFICACIÓN CLIENTE:</strong></div>" +
                "  <div style='font-size: 16px; font-weight: bold; color: #1d4ed8;'>" + ord.getCliente_id() + "</div>" +
                "  <div class='info-item'><strong>Nombre Cliente:</strong> " + nombreCliente + "</div>" +
                "  <div class='info-item'><strong>Fecha de Emisión:</strong> " + ord.getFecha_ingreso() + "</div>" +
                "  <div class='info-item'><strong>Estado de la Orden:</strong> " + ord.getEstado_actual() + "</div>" +
                "</div>" +
                "<table class='table'>" +
                "  <thead><tr><th>REPORTE INICIAL DEL CLIENTE</th></tr></thead>" +
                "  <tbody><tr><td>" + ord.getReporte().replace("\n", "<br/>") + "</td></tr></tbody>" +
                "</table>" +
                "<table class='table'>" +
                "  <thead><tr><th>DIAGNÓSTICO TÉCNICO Y RESULTADOS</th></tr></thead>" +
                "  <tbody><tr><td>" +
                (ord.getDiagnostico() != null && !ord.getDiagnostico().isEmpty() ?
                        ord.getDiagnostico().replace("\n", "<br/>") : "<i>Diagnóstico pendiente de revisión.</i>") +
                "  </td></tr></tbody>" +
                "</table>" +
                (ord.getObservaciones() != null && !ord.getObservaciones().isEmpty() ?
                        "<table class='table'><thead><tr><th>OBSERVACIONES ADICIONALES</th></tr></thead>" +
                        "<tbody><tr><td>" + ord.getObservaciones().replace("\n", "<br/>") + "</td></tr></tbody></table>" : "") +
                "<div class='footer'>" +
                "  <p>Este documento es un soporte digital generado por el sistema de gestión de " + emp.getNombre() + ".</p>" +
                "  <p>© " + java.time.Year.now().getValue() + " - Todos los derechos reservados 4TECH.</p>" +
                "</div>" +
                "</body></html>";

        try {
            // 3. Renderizar el PDF en el buffer de memoria RAM
            java.io.ByteArrayOutputStream memoryBuffer = new java.io.ByteArrayOutputStream();
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            builder.withHtmlContent(html, null);
            builder.toStream(memoryBuffer);
            builder.run();

            byte[] pdfBytes = memoryBuffer.toByteArray();

            // 4. BIPARTICIÓN DE LA LÓGICA SEGÚN LA ACCIÓN
            if ("enviar".equals(accion)) {
                // === CASO A: SOLO ENVIAR CORREO ===
                if (!correoCliente.isEmpty()) {
                    EmailServices emailService = new EmailServices();
                    boolean enviado = emailService.enviarFacturaPorSMTP(correoCliente, nombreCliente, String.valueOf(idOrden), pdfBytes);

                    response.setContentType("text/plain");
                    response.setCharacterEncoding("UTF-8");
                    if (enviado) {
                        response.getWriter().write("OK");
                    } else {
                        response.getWriter().write("ERROR_SMTP");
                    }
                } else {
                    response.getWriter().write("SIN_CORREO");
                }

            } else {
                // === CASO B: SOLO DESCARGAR / MOSTRAR EN COMPUTADOR (Por defecto) ===
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=Factura_ORD_" + idOrden + ".pdf");

                try (OutputStream os = response.getOutputStream()) {
                    os.write(pdfBytes);
                    os.flush();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            if ("enviar".equals(accion)) {
                response.getWriter().write("ERROR_EXCEPTION");
            }
        }
    }
}