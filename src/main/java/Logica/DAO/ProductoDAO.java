package Logica.DAO;

import Config.Conexion;
import Logica.modelo.Producto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // Listar productos por empresa
    public List<Producto> listarPorEmpresa(long idEmpresa) {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT * FROM inventario WHERE empresa_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setLong(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Producto p = new Producto();
                p.setProducto_id(rs.getLong("producto_id"));
                p.setNombre(rs.getString("nombre"));
                p.setCantidad(rs.getInt("cantidad"));
                p.setCosto(rs.getDouble("costo"));
                p.setEmpresa_id(rs.getLong("empresa_id"));
                p.setProveedorId(rs.getInt("proveedor_id"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error listar inventario: " + e.getMessage());
        }
        return lista;
    }

    public int registrar(Producto p) {
        String sql = "INSERT INTO inventario (nombre, cantidad, costo, empresa_id, proveedor_id) VALUES (?,?,?,?,?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getNombre());
            ps.setInt(2, p.getCantidad());
            ps.setDouble(3, p.getCosto());
            ps.setLong(4, p.getEmpresa_id());
            ps.setLong(5, p.getProveedorId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            return 0;
        }
    }

    public int eliminar(long idProducto, long idEmpresa) {
        // Validamos por idProducto e idEmpresa por seguridad
        String sql = "DELETE FROM inventario WHERE producto_id = ? AND empresa_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setLong(1, idProducto);
            ps.setLong(2, idEmpresa);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al eliminar producto: " + e.getMessage());
            return 0;
        }
    }

    public int actualizar(Producto p) {
        String sql = "UPDATE inventario SET nombre = ?, cantidad = ?, costo = ?, proveedor_id = ? WHERE producto_id = ? AND empresa_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getNombre());
            ps.setInt(2, p.getCantidad());
            ps.setDouble(3, p.getCosto());

            if (p.getProveedorId() == 0) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, p.getProveedorId());
            }

            ps.setLong(5, p.getProducto_id());
            ps.setLong(6, p.getEmpresa_id());

            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al actualizar producto: " + e.getMessage());
            return 0;
        }
    }
}
