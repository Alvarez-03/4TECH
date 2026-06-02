package Logica.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import Config.Conexion;

public class ReporteDAO {

    private final Conexion cn = new Conexion();
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    private Connection getConnection() throws SQLException {
        return cn.getConnection();
    }

    // =========================================================================
    // SUPERADMIN
    // =========================================================================
    public int obtenerTotalEmpresasGlobal() {
        String sql = "SELECT COUNT(*) AS total FROM empresa";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            System.err.println("Error en obtenerTotalEmpresasGlobal: " + e.getMessage());
        }
        return 0;
    }

    public List<Map<String, Object>> obtenerEmpresasPorCiudad() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT ciudad, COUNT(*) AS cantidad FROM empresa GROUP BY ciudad ORDER BY cantidad DESC";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("ciudad", rs.getString("ciudad"));
                fila.put("cantidad", rs.getInt("cantidad"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerEmpresasPorCiudad: " + e.getMessage());
        }
        return lista;
    }

    // =========================================================================
    // EMPRESA
    // =========================================================================
    public double obtenerInversionTotalAlmacen(int idEmpresa) {
        String sql = "SELECT SUM(cantidad * costo) AS inversion_total FROM inventario WHERE empresa_id = ?";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpresa);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble("inversion_total");
        } catch (SQLException e) {
            System.err.println("Error en obtenerInversionTotalAlmacen: " + e.getMessage());
        }
        return 0.0;
    }

    public List<Map<String, Object>> obtenerStockCritico(int idEmpresa) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT nombre, cantidad FROM inventario WHERE cantidad <= 5 AND empresa_id = ? ORDER BY cantidad ASC";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("nombre", rs.getString("nombre"));
                fila.put("cantidad", rs.getInt("cantidad"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerStockCritico: " + e.getMessage());
        }
        return lista;
    }

    public List<Map<String, Object>> obtenerTopProductosCostosos(int idEmpresa) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT nombre, costo FROM inventario WHERE empresa_id = ? ORDER BY costo DESC LIMIT 5";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("nombre", rs.getString("nombre"));
                fila.put("costo", rs.getDouble("costo"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerTopProductosCostosos: " + e.getMessage());
        }
        return lista;
    }

    public List<Map<String, Object>> obtenerOrdenesPorEstado(int idEmpresa) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT estado_actual, COUNT(*) AS total FROM ordenservicios WHERE empresa_id = ? GROUP BY estado_actual";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("estado", rs.getString("estado_actual"));
                fila.put("total", rs.getInt("total"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerOrdenesPorEstado: " + e.getMessage());
        }
        return lista;
    }

    public List<Map<String, Object>> obtenerItemsPorProveedor(int idEmpresa) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT p.nombre_empresa, COUNT(i.producto_id) AS total_items " +
                "FROM proveedores p " +
                "LEFT JOIN inventario i ON p.IDproveedor = i.proveedor_id " +
                "WHERE p.empresa_id = ? GROUP BY p.IDproveedor, p.nombre_empresa";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("proveedor", rs.getString("nombre_empresa"));
                fila.put("totalItems", rs.getInt("total_items"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerItemsPorProveedor: " + e.getMessage());
        }
        return lista;
    }

    // =========================================================================
    // EMPLEADO
    // =========================================================================
    public List<Map<String, Object>> obtenerMisOrdenesPorEstado(int idEmpleado, int idEmpresa) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT estado_actual, COUNT(*) AS total FROM ordenservicios WHERE empleado_id = ? AND empresa_id = ? GROUP BY estado_actual";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpleado);
            ps.setInt(2, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("estado", rs.getString("estado_actual"));
                fila.put("total", rs.getInt("total"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerMisOrdenesPorEstado: " + e.getMessage());
        }
        return lista;
    }

    public List<Map<String, Object>> obtenerRendimientoEquipo(int idEmpresa) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT e.nombre, COUNT(o.IDorden) AS ordenes_completadas " +
                "FROM empleado e " +
                "INNER JOIN ordenservicios o ON e.ID = o.empleado_id " +
                "WHERE e.empresa_id = ? GROUP BY e.ID, e.nombre ORDER BY ordenes_completadas DESC";
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("nombre", rs.getString("nombre"));
                fila.put("completadas", rs.getInt("ordenes_completadas"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerRendimientoEquipo: " + e.getMessage());
        }
        return lista;
    }
}