package Config;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    private Connection con;

    // Configura estos datos según tu servidor MySQL local
    private String url = "jdbc:mysql://localhost:3306/pruebaslocal";   // Ejemplo: "jdbc:mysql://localhost:3306/4tech"
    private String user = "root";  // Ejemplo: "admin"
    private String pass = "";  // Ejemplo: "1234"

    public Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
        return con;
    }
}