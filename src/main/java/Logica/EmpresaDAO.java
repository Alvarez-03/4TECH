package Logica;

import Config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EmpresaDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // 1. REGISTRAR: Insertamos todos los campos de la clase
    public int registrar(Empresa emp) {
        String sql = "INSERT INTO empresa (email, nombre, ciudad, direccion, telefono, siglas, estado, created_at, update_at, password) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, emp.getEmail());
            ps.setString(2, emp.getNombre());
            ps.setString(3, emp.getCiudad());
            ps.setString(4, emp.getDireccion());
            ps.setInt(5, emp.getTelefono());
            ps.setString(6, emp.getSiglas());
            ps.setString(7, emp.getEstado());
            ps.setString(8, emp.getCreated_at());
            ps.setString(9, emp.getUpdate_at());
            ps.setString(10, emp.getPassword());

            return ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("Error al registrar empresa: " + e);
            return 0;
        }
    }

    // 2. LISTAR: Mapeo completo de la tabla a la lista de objetos
    public List<Empresa> listar() {
        List<Empresa> lista = new ArrayList<>();
        String sql = "SELECT * FROM empresa";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                // Creamos un objeto vacío (puedes usar un constructor vacío si lo creas en la clase Empresa)
                // O pasarle valores por defecto al constructor largo:
                Empresa emp = new Empresa(
                        rs.getInt("ID"),
                        rs.getString("email"),
                        rs.getString("nombre"),
                        rs.getString("ciudad"),
                        rs.getString("direccion"),
                        rs.getInt("telefono"),
                        rs.getString("siglas"),
                        rs.getString("estado"),
                        rs.getString("created_at"),
                        rs.getString("update_at"),
                        rs.getString("password")
                );
                lista.add(emp);
            }
        } catch (Exception e) {
            System.err.println("Error al listar empresas: " + e);
        }
        return lista;
    }

    // 3. VALIDAR ACCESO (Login)
    public Empresa validarAcceso(String email, String pass) {
        String sql = "SELECT * FROM empresa WHERE email = ? AND password = ?";
        Empresa emp = null;
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, pass);
            rs = ps.executeQuery();

            if (rs.next()) {
                emp = new Empresa();
                emp.setID(rs.getInt("ID"));
                emp.setEmail(rs.getString("email"));
                emp.setNombre(rs.getString("nombre"));
                emp.setCiudad(rs.getString("ciudad"));
                emp.setDireccion(rs.getString("direccion"));
                emp.setTelefono(rs.getInt("telefono"));
                emp.setSiglas(rs.getString("siglas"));
                emp.setEstado(rs.getString("estado"));
                emp.setCreated_at(rs.getString("created_at"));
                emp.setUpdate_at(rs.getString("update_at"));
            }
        } catch (Exception e) {
            System.err.println("Error en validarAcceso: " + e);
        }
        return emp;
    }

    public int actualizar(Empresa emp) {
        // El password solo se cambia si el valor enviado no es NULL
        String sql = "UPDATE empresa SET nombre=?, ciudad=?, direccion=?, telefono=?, siglas=?, "
                + "password = IFNULL(?, password), estado=?, update_at=? WHERE email=?";

        String fechaActual = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());

        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, emp.getNombre());
            ps.setString(2, emp.getCiudad());
            ps.setString(3, emp.getDireccion());
            ps.setInt(4, emp.getTelefono());
            ps.setString(5, emp.getSiglas());
            ps.setString(6, emp.getPassword());
            ps.setString(7, emp.getEstado());
            ps.setString(8, fechaActual);
            ps.setString(9, emp.getEmail());


            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error en DAO actualizar: " + e);
            return 0;
        }
    }
}