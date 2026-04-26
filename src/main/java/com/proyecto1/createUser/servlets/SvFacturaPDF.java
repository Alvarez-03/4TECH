package com.proyecto1.createUser.servlets;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Logica.DAO.OrdenServicioDAO;
import Logica.modelo.Empresa;
import Logica.modelo.OrdenServicio;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import java.io.OutputStream;

@WebServlet("/SvFacturaPDF")
public class SvFacturaPDF extends HttpServlet {
    OrdenServicioDAO dao = new OrdenServicioDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();
        Empresa emp = (Empresa) sesion.getAttribute("usuarioLogueado");

        // Si la sesión expiró o no hay empresa, cancelamos
        if (emp == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) return;

        int idOrden = Integer.parseInt(idParam);
        OrdenServicio ord = dao.obtenerPorId(idOrden); // Asegúrate de tener este método

        // Configurar respuesta
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Factura_ORD_" + idOrden + ".pdf");

        // Construir el HTML con CSS inline (OpenHTMLtoPDF prefiere estilos inline o bloques <style>)
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

                // Cabecera con Nombre de Empresa
                "<div class='header'>" +
                "  <div class='order-number'><strong>ORD-" + String.format("%04d", idOrden) + "</strong></div>" +
                "  <h1 class='empresa-name'>" + emp.getNombre() + "</h1>" +
                "  <div class='doc-type'>COMPROBANTE DE ORDEN DE SERVICIO</div>" +
                "</div>" +

                // Datos generales
                "<div class='info-grid'>" +
                "  <div class='info-item'><strong>Fecha de Emisión:</strong> " + ord.getFecha_ingreso() + "</div>" +
                "  <div class='info-item'><strong>Estado de la Orden:</strong> " + ord.getEstado_actual() + "</div>" +
                "</div>" +

                // Sección de Reporte
                "<table class='table'>" +
                "  <thead><tr><th>REPORTE INICIAL DEL CLIENTE</th></tr></thead>" +
                "  <tbody><tr><td>" + ord.getReporte().replace("\n", "<br/>") + "</td></tr></tbody>" +
                "</table>" +

                // Sección de Diagnóstico
                "<table class='table'>" +
                "  <thead><tr><th>DIAGNÓSTICO TÉCNICO Y RESULTADOS</th></tr></thead>" +
                "  <tbody><tr><td>" +
                (ord.getDiagnostico() != null && !ord.getDiagnostico().isEmpty() ?
                        ord.getDiagnostico().replace("\n", "<br/>") : "<i>Diagnóstico pendiente de revisión.</i>") +
                "  </td></tr></tbody>" +
                "</table>" +

                // Observaciones (si existen)
                (ord.getObservaciones() != null && !ord.getObservaciones().isEmpty() ?
                        "<table class='table'><thead><tr><th>OBSERVACIONES ADICIONALES</th></tr></thead>" +
                        "<tbody><tr><td>" + ord.getObservaciones().replace("\n", "<br/>") + "</td></tr></tbody></table>" : "") +

                "<div class='footer'>" +
                "  <p>Este documento es un soporte digital generado por el sistema de gestión de " + emp.getNombre() + ".</p>" +
                "  <p>© " + java.time.Year.now().getValue() + " - Todos los derechos reservados 4TECH.</p>" +
                "</div>" +
                "</body></html>";
        try (OutputStream os = response.getOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            builder.withHtmlContent(html, null);
            builder.toStream(os);
            builder.run();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}