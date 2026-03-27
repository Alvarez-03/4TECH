package Logica;

import Config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // 1. REGISTRAR
    public int registrar(Empleado emp) {
        String sql = "INSERT INTO empleado (nombre, email, telefono, cargo, estado, password, empresa_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, emp.getNombre());
            ps.setString(2, emp.getEmail());
            ps.setInt(3, emp.getTelefono());
            ps.setString(4, emp.getCargo());
            ps.setString(5, emp.getEstado());
            ps.setString(6, emp.getPassword());
            ps.setInt(7, emp.getEmpresa_id()); // FK
            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error al registrar empleado: " + e);
            return 0;
        }
    }

    // 2. LISTAR TODOS (Útil para el SuperAdmin)
    public List<Empleado> listar() {
        List<Empleado> lista = new ArrayList<>();
        String sql = "SELECT * FROM empleado";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Empleado emp = new Empleado(
                        rs.getInt("ID"),
                        rs.getString("nombre"),
                        rs.getString("email"),
                        rs.getInt("telefono"),
                        rs.getString("cargo"),
                        rs.getString("estado"),
                        rs.getString("password"),
                        rs.getInt("empresa_id")
                );
                lista.add(emp);
            }
        } catch (Exception e) {
            System.err.println("Error al listar empleados: " + e);
        }
        return lista;
    }

    // 3. LISTAR POR EMPRESA (Útil cuando una empresa ve sus propios empleados)
    public List<Empleado> listarPorEmpresa(int idEmpresa) {
        List<Empleado> lista = new ArrayList<>();
        String sql = "SELECT * FROM empleado WHERE empresa_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Empleado emp = new Empleado();
                emp.setId(rs.getInt("ID"));
                emp.setNombre(rs.getString("nombre"));
                emp.setCargo(rs.getString("cargo"));
                emp.setEstado(rs.getString("estado"));
                // ... llenar el resto
                lista.add(emp);
            }
        } catch (Exception e) {
            System.err.println("Error al filtrar empleados: " + e);
        }
        return lista;
    }
    // 4. cambiar estado de empleado
    public int cambiarEstado(int id, String nuevoEstado) {
        String sql = "UPDATE empleado SET estado = ? WHERE ID = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, nuevoEstado);
            ps.setInt(2, id);

            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error al cambiar estado del empleado: " + e);
            return 0;
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}