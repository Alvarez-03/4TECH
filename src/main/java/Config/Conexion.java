package Config;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {

    private Connection con;

    String host = "localhost";
    String puerto = "3306";
    String db = "pruebaslocal";
    String user = "root";
    String pass = "";

    public Connection getConnection() {
        try {
            String url = "jdbc:mysql://" + host + ":" + puerto + "/" + db + "?useSSL=false&allowPublicKeyRetrieval=true";
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            if (con != null) {
                System.out.println("¡Conectado exitosamente al servidor LOCAL!");
            }
        } catch (Exception e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
        return con;
    }
}