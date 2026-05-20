package Logica.DAO;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class EmailServices {

    // Pon tus credenciales reales de la pestaña SMTP de Mailtrap
    private final String usuario = "c3a84211aff161";
    private final String contrasenia = "51805ba39b9c22";

    private final String host = "sandbox.smtp.mailtrap.io";
    private final String puerto = "2525";

    public boolean enviarFacturaPorSMTP(String correoDestinatario, String nombreCliente, String noOrden, byte[] pdfBytes) {

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", puerto);
        props.put("mail.smtp.ssl.trust", host);

        // Forzar el mapa de comandos clásico de javax para evitar bloqueos del servidor
        javax.activation.CommandMap.setDefaultCommandMap(new javax.activation.MailcapCommandMap());

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(usuario, contrasenia);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("cristian.tigreros@correounivalle.edu.co", "Soporte 4TECH"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(correoDestinatario));
            message.setSubject("Factura Electronica y Reporte - Orden " + noOrden + " - 4TECH");

            Multipart multipart = new MimeMultipart();

            // Parte A: Cuerpo del mensaje HTML
            MimeBodyPart parteTexto = new MimeBodyPart();
            String htmlContent = "<html><body style='font-family: sans-serif;'>"
                    + "<html>"
                    + "<head>"
                    + "<meta charset='UTF-8'>"
                    + "<style>"
                    + "  body { margin: 0; padding: 0; background-color: #f3f4f6; font-family: 'Segoe UI', Arial, sans-serif; -webkit-font-smoothing: antialiased; }"
                    + "  .wrapper { width: 100%; table-layout: fixed; background-color: #f3f4f6; padding: 40px 0; }"
                    + "  .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06); }"
                    + "  .header { background: linear-gradient(135deg, #1e40af 0%, #1d4ed8 100%); padding: 35px 40px; text-align: center; }"
                    + "  .header h1 { color: #ffffff; margin: 0; font-size: 26px; font-weight: 800; letter-spacing: 1px; text-transform: uppercase; }"
                    + "  .header p { color: #93c5fd; margin: 5px 0 0 0; font-size: 14px; font-weight: 500; }"
                    + "  .content { padding: 40px; color: #1f2937; line-height: 1.6; }"
                    + "  .greeting { font-size: 20px; font-weight: 700; color: #111827; margin-top: 0; margin-bottom: 15px; }"
                    + "  .text { font-size: 15px; color: #4b5563; margin-bottom: 25px; }"
                    + "  .badge-box { background-color: #f8fafc; border: 1px solid #e2e8f0; border-left: 4px solid #1d4ed8; padding: 20px; border-radius: 6px; margin-bottom: 25px; }"
                    + "  .badge-item { font-size: 14px; color: #334155; margin: 6px 0; }"
                    + "  .badge-item strong { color: #0f172a; }"
                    + "  .footer { background-color: #f9fafb; padding: 25px 40px; text-align: center; border-top: 1px solid #f3f4f6; }"
                    + "  .footer p { margin: 0; font-size: 12px; color: #9ca3af; }"
                    + "  .footer a { color: #1d4ed8; text-decoration: none; font-weight: 600; }"
                    + "</style>"
                    + "</head>"
                    + "<body>"
                    + "  <div class='wrapper'>"
                    + "    <div class='container'>"
                    + "      "
                    + "      <div class='header'>"
                    + "        <h1>4TECH</h1>"
                    + "        <p>Soluciones Tecnológicas Especializadas</p>"
                    + "      </div>"
                    + "      "
                    + "      "
                    + "      <div class='content'>"
                    + "        <p class='greeting'>¡Hola, " + nombreCliente + "!</p>"
                    + "        <p class='text'>Nos complace informarte que tu orden de servicio ha sido procesada con éxito en nuestro laboratorio técnico. A continuación, te compartimos los detalles principales:</p>"
                    + "        "
                    + "        "
                    + "        <div class='badge-box'>"
                    + "          <div class='badge-item'><strong>Número de Orden:</strong> #" + String.format("%04d", Integer.parseInt(noOrden)) + "</div>"
                    + "          <div class='badge-item'><strong>Estado:</strong> Completado / Listo para Entrega</div>"
                    + "          <div class='badge-item'><strong>Fecha de Soporte:</strong> " + java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy").format(java.time.LocalDate.now()) + "</div>"
                    + "        </div>"
                    + "        "
                    + "        <p class='text' style='margin-bottom: 0;'>Adjunto a este correo electrónico encontrarás un archivo en formato <strong>PDF</strong> que contiene el reporte técnico detallado, los diagnósticos finales y los costos asociados.</p>"
                    + "      </div>"
                    + "      "
                    + "      "
                    + "      <div class='footer'>"
                    + "        <p>Este es un mensaje automático generado por el sistema de gestión interna de 4TECH.</p>"
                    + "        <p style='margin-top: 6px;'>© " + java.time.Year.now().getValue() + " 4TECH. Todos los derechos reservados.</p>"
                    + "      </div>"
                    + "    </div>"
                    + "  </div>"
                    + "</body>"
                    + "</html>";
            parteTexto.setContent(htmlContent, "text/html; charset=utf-8");
            multipart.addBodyPart(parteTexto);

            // Parte B: El archivo PDF adjunto
            if (pdfBytes != null && pdfBytes.length > 0) {
                MimeBodyPart parteAdjunto = new MimeBodyPart();

                // Usamos el DataSource clásico de javax.activation
                javax.activation.DataSource source = new javax.activation.DataSource() {
                    @Override
                    public InputStream getInputStream() throws IOException {
                        return new ByteArrayInputStream(pdfBytes);
                    }

                    @Override
                    public OutputStream getOutputStream() throws IOException {
                        throw new UnsupportedOperationException("No soportado");
                    }

                    @Override
                    public String getContentType() {
                        return "application/pdf";
                    }

                    @Override
                    public String getName() {
                        return "Factura_" + noOrden + ".pdf";
                    }
                };

                parteAdjunto.setDataHandler(new javax.activation.DataHandler(source));
                parteAdjunto.setFileName("Factura_" + noOrden + ".pdf");
                multipart.addBodyPart(parteAdjunto);
            }

            message.setContent(multipart);

            // Envío final
            Transport.send(message);
            System.out.println("¡Correo enviado vía SMTP de Mailtrap con éxito!");
            return true;

        } catch (MessagingException e) {
            System.err.println("Error en el protocolo SMTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("Error inesperado en EmailServices: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}