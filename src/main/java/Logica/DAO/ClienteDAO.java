package Logica.DAO;

import Config.Conexion;
import Logica.modelo.Cliente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class ClienteDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public Cliente buscar(String documento) {
        Cliente c = null;
        String sql = "SELECT * FROM cliente WHERE documento = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, documento);
            rs = ps.executeQuery();
            if (rs.next()) {
                c = new Cliente();
                c.setDocumento(rs.getString("documento"));
                c.setNombre(rs.getString("nombre"));
                c.setTelefono(rs.getString("telefono"));
                c.setEmail(rs.getString("email"));
                c.setEstado(rs.getString("estado"));
            }
        } catch (Exception e) {
            System.err.println("Error al buscar cliente: " + e);
        }
        return c;
    }

    public int registrar(Cliente cli) {
        String sql = "INSERT INTO cliente (documento, nombre, telefono, email, estado) VALUES (?,?,?,?,?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, cli.getDocumento());
            ps.setString(2, cli.getNombre());
            ps.setString(3, cli.getTelefono());
            ps.setString(4, cli.getEmail());
            ps.setString(5, "ACTIVO");
            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error al registrar cliente: " + e);
            return 0;
        }
    }

    public int actualizar(Cliente cli) {
        String sql = "UPDATE cliente SET nombre=?, telefono=?, email=?, estado=? WHERE documento=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, cli.getNombre());
            ps.setString(2, cli.getTelefono());
            ps.setString(3, cli.getEmail());
            ps.setString(4, cli.getEstado());
            ps.setString(5, cli.getDocumento());
            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error al actualizar cliente: " + e);
            return 0;
        }
    }
}