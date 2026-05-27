package Logica.DAO;

import Config.Conexion;
import Logica.modelo.Proveedor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProveedorDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // Listar proveedores por empresa
    public List<Proveedor> listarPorEmpresa(long idEmpresa) {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT * FROM proveedores WHERE empresa_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setLong(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Proveedor p = new Proveedor();
                p.setIdProveedor((int) rs.getLong("IDproveedor"));
                p.setEmpresaId((int) rs.getLong("empresa_id"));
                p.setNombreEmpresa(rs.getString("nombre_empresa"));
                p.setContactoAsesor(rs.getString("contacto_asesor"));
                p.setTelefonoContacto(rs.getString("telefono_contacto"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error listar proveedores: " + e.getMessage());
        }
        return lista;
    }

    // Registrar un proveedor
    public int registrar(Proveedor p) {
        String sql = "INSERT INTO proveedores (empresa_id, nombre_empresa, contacto_asesor, telefono_contacto) VALUES (?,?,?,?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setLong(1, p.getEmpresaId());
            ps.setString(2, p.getNombreEmpresa());
            ps.setString(3, p.getContactoAsesor());
            ps.setString(4, p.getTelefonoContacto());
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al registrar proveedor: " + e.getMessage());
            return 0;
        }
    }

    // Eliminar un proveedor validando su empresa por seguridad (SaaS)
    public int eliminar(long idProveedor, long idEmpresa) {
        String sql = "DELETE FROM proveedores WHERE IDproveedor = ? AND empresa_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setLong(1, idProveedor);
            ps.setLong(2, idEmpresa);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al eliminar proveedor: " + e.getMessage());
            return 0;
        }
    }

    // Actualizar datos de un proveedor
    public int actualizar(Proveedor p) {
        String sql = "UPDATE proveedores SET nombre_empresa = ?, contacto_asesor = ?, telefono_contacto = ? WHERE IDproveedor = ? AND empresa_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setLong(1, p.getEmpresaId());
            ps.setString(2, p.getNombreEmpresa());
            ps.setString(3, p.getContactoAsesor());
            ps.setString(4, p.getTelefonoContacto());
            ps.setLong(4, p.getIdProveedor());
            ps.setLong(5, p.getEmpresaId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al actualizar proveedor: " + e.getMessage());
            return 0;
        }
    }

    // EXTRA: Buscar un proveedor específico por su ID y Empresa (Ideal para cargar ediciones)
    public Proveedor listarProveedorPorId(long idProveedor, long idEmpresa) {
        Proveedor p = null;
        String sql = "SELECT * FROM proveedores WHERE IDproveedor = ? AND empresa_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setLong(1, idProveedor);
            ps.setLong(2, idEmpresa);
            rs = ps.executeQuery();
            if (rs.next()) {
                p = new Proveedor();
                p.setIdProveedor((int) rs.getLong("IDproveedor"));
                p.setEmpresaId((int) rs.getLong("empresa_id"));
                p.setNombreEmpresa(rs.getString("nombre_empresa"));
                p.setContactoAsesor(rs.getString("contacto_asesor"));
                p.setTelefonoContacto(rs.getString("telefono_contacto"));
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar proveedor por ID: " + e.getMessage());
        }
        return p;
    }
}