package Logica.DAO;


import Config.Conexion;
import Logica.modelo.OrdenServicio;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrdenServicioDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public int guardar(OrdenServicio orden) {
        String sql = "INSERT INTO ordenservicios (reporte, diagnostico, estado_actual, observaciones, fecha_ingreso, empresa_id, empleado_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            String fechaActual = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());

            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, orden.getReporte());
            ps.setString(2, orden.getDiagnostico());
            ps.setString(3, orden.getEstado_actual());
            ps.setString(4, orden.getObservaciones());
            ps.setString(5, fechaActual);
            ps.setInt(6, orden.getEmpresa_id());
            ps.setInt(7, orden.getEmpleado_id());

            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al guardar Orden: " + e.toString());
            return 0;
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }
        }
    }

    public List<OrdenServicio> listarPorEmpresa(int idEmpresa) {
        List<OrdenServicio> lista = new ArrayList<>();
        String sql = "SELECT * FROM ordenservicios WHERE empresa_id = ? ORDER BY fecha_ingreso DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpresa);
            rs = ps.executeQuery();
            while (rs.next()) {
                OrdenServicio ord = new OrdenServicio();
                // Convertimos el ID de la BD a BigInteger para tu clase
                ord.setIDorden(rs.getBigDecimal("IDorden").toBigInteger());
                ord.setReporte(rs.getString("reporte"));
                ord.setDiagnostico(rs.getString("diagnostico"));
                ord.setEstado_actual(rs.getString("estado_actual"));
                ord.setObservaciones(rs.getString("observaciones"));
                ord.setFecha_ingreso(rs.getString("fecha_ingreso"));
                ord.setEmpresa_id(rs.getInt("empresa_id"));
                ord.setEmpleado_id(rs.getInt("empleado_id"));
                lista.add(ord);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar Ordenes: " + e.toString());
        }
        return lista;
    }
}
