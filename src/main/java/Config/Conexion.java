package Config;

import io.github.cdimascio.dotenv.Dotenv;
import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    private Connection con;

    public Connection getConnection() {
        try {
            String host = System.getenv("MYSQL_ADDON_HOST");
            String port = System.getenv("MYSQL_ADDON_PORT");
            String dbName = System.getenv("MYSQL_ADDON_DB");
            String user = System.getenv("MYSQL_ADDON_USER");
            String pass = System.getenv("MYSQL_ADDON_PASSWORD");

            String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false&allowPublicKeyRetrieval=true";

            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            System.out.println("Conexión exitosa a la base de datos en la nube");
        } catch (Exception e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
        return con;
    }
}