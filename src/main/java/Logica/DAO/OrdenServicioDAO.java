package Logica.DAO;


import Config.Conexion;
import Logica.modelo.OrdenServicio;

import java.math.BigInteger;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrdenServicioDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // MODIFICADO: Ahora retorna el BigInteger generado por la BD (o null si falla)
    public java.math.BigInteger guardar(OrdenServicio orden) {
        String sql = "INSERT INTO ordenservicios (reporte, diagnostico, estado_actual, observaciones, fecha_ingreso, empresa_id, empleado_id, cliente_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            String fechaActual = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
            con = cn.getConnection();

            // Indicamos que queremos recuperar la clave primaria generada automáticamente
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, orden.getReporte());
            ps.setString(2, orden.getDiagnostico());
            ps.setString(3, orden.getEstado_actual());
            ps.setString(4, orden.getObservaciones());
            ps.setString(5, fechaActual);
            ps.setInt(6, orden.getEmpresa_id());
            ps.setInt(7, orden.getEmpleado_id());
            ps.setString(8, orden.getCliente_id());

            int resultado = ps.executeUpdate();

            if (resultado > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    // Convertimos la llave autoincremental a BigInteger
                    return rs.getBigDecimal(1).toBigInteger();
                }
            }
            return null;
        } catch (SQLException e) {
            System.err.println("Error al guardar Orden: " + e.toString());
            return null;
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }
        }
    }


    public boolean guardarProductosOrden(java.math.BigInteger ordenId, String[] prodIds, String[] cantidades) {
        if (prodIds == null || prodIds.length == 0) return true;

        // Buscamos el costo de forma dinámica para registrar el valor histórico del repuesto
        String sqlDetalle = "INSERT INTO orden_productos (orden_id, producto_id, cantidad, valor_unitario) VALUES (?, ?, ?, (SELECT costo FROM inventario WHERE producto_id = ?))";
        String sqlDescontar = "UPDATE inventario SET cantidad = cantidad - ? WHERE producto_id = ?";

        Connection conTrans = null;
        try {
            conTrans = cn.getConnection();
            conTrans.setAutoCommit(false); // Activamos transacción para evitar fallos parciales

            try (PreparedStatement psDetalle = conTrans.prepareStatement(sqlDetalle);
                 PreparedStatement psDescontar = conTrans.prepareStatement(sqlDescontar)) {

                for (int i = 0; i < prodIds.length; i++) {
                    if (prodIds[i] == null || prodIds[i].trim().isEmpty()) continue;

                    long prodId = Long.parseLong(prodIds[i]);
                    int cant = Integer.parseInt(cantidades[i]);

                    // Fila para orden_productos
                    psDetalle.setObject(1, ordenId);
                    psDetalle.setLong(2, prodId);
                    psDetalle.setInt(3, cant);
                    psDetalle.setLong(4, prodId);
                    psDetalle.addBatch();

                    // Fila para actualizar stock en producto
                    psDescontar.setInt(1, cant);
                    psDescontar.setLong(2, prodId);
                    psDescontar.addBatch();
                }

                psDetalle.executeBatch();
                psDescontar.executeBatch();
            }

            conTrans.commit(); // Confirmamos todos los cambios juntos
            return true;
        } catch (SQLException e) {
            System.err.println("Error al guardar productos de la orden: " + e.getMessage());
            if (conTrans != null) { try { conTrans.rollback(); } catch (SQLException ex) { /* ignored */ } }
            return false;
        } finally {
            try { if (conTrans != null) conTrans.close(); } catch (SQLException e) { /* ignored */ }
        }
    }

    // NUEVO MÉTODO: Regresa las existencias previas al inventario y borra la relación vieja antes de editar
    public void reestablecerStockSuministros(java.math.BigInteger ordenId) {
        String sqlBuscar = "SELECT producto_id, cantidad FROM orden_productos WHERE orden_id = ?";
        String sqlDevolver = "UPDATE inventario SET cantidad = cantidad + ? WHERE producto_id = ?";
        String sqlEliminarRelacion = "DELETE FROM orden_productos WHERE orden_id = ?";

        Connection conTrans = null;
        try {
            conTrans = cn.getConnection();
            conTrans.setAutoCommit(false);

            List<long[]> productosViejos = new ArrayList<>();
            try (PreparedStatement psB = conTrans.prepareStatement(sqlBuscar)) {
                psB.setObject(1, ordenId);
                try (ResultSet rsB = psB.executeQuery()) {
                    while (rsB.next()) {
                        productosViejos.add(new long[]{rsB.getLong("producto_id"), rsB.getLong("cantidad")});
                    }
                }
            }

            if (!productosViejos.isEmpty()) {
                try (PreparedStatement psD = conTrans.prepareStatement(sqlDevolver)) {
                    for (long[] item : productosViejos) {
                        psD.setInt(1, (int) item[1]);
                        psD.setLong(2, item[0]);
                        psD.addBatch();
                    }
                    psD.executeBatch();
                }
            }

            try (PreparedStatement psE = conTrans.prepareStatement(sqlEliminarRelacion)) {
                psE.setObject(1, ordenId);
                psE.executeUpdate();
            }

            conTrans.commit();
        } catch (SQLException e) {
            System.err.println("Error al reestablecer stock: " + e.getMessage());
            if (conTrans != null) { try { conTrans.rollback(); } catch (SQLException ex) { /* ignored */ } }
        } finally {
            try { if (conTrans != null) conTrans.close(); } catch (SQLException e) { /* ignored */ }
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
                ord.setCliente_id(rs.getString("cliente_id"));
                lista.add(ord);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar Ordenes: " + e.toString());
        }
        return lista;
    }

    public List<OrdenServicio> listarPorEmpleado(int idEmpleado) {
        List<OrdenServicio> lista = new ArrayList<>();
        String sql = "SELECT * FROM ordenservicios WHERE empleado_id = ? ORDER BY fecha_ingreso DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpleado);
            rs = ps.executeQuery();
            while (rs.next()) {
                OrdenServicio ord = new OrdenServicio();
                ord.setIDorden(rs.getBigDecimal("IDorden").toBigInteger());
                ord.setReporte(rs.getString("reporte"));
                ord.setDiagnostico(rs.getString("diagnostico"));
                ord.setEstado_actual(rs.getString("estado_actual"));
                ord.setObservaciones(rs.getString("observaciones"));
                ord.setFecha_ingreso(rs.getString("fecha_ingreso"));
                ord.setEmpresa_id(rs.getInt("empresa_id"));
                ord.setEmpleado_id(rs.getInt("empleado_id"));
                ord.setCliente_id(rs.getString("cliente_id"));
                lista.add(ord);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar Ordenes por Empleado: " + e.toString());
        }
        return lista;
    }

    public int actualizar(OrdenServicio orden) {
        String sql = "UPDATE ordenservicios SET reporte=?, diagnostico=?, estado_actual=?, observaciones=?, empleado_id=? WHERE IDorden=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, orden.getReporte());
            ps.setString(2, orden.getDiagnostico());
            ps.setString(3, orden.getEstado_actual());
            ps.setString(4, orden.getObservaciones());
            ps.setInt(5, orden.getEmpleado_id());
            // Convertimos BigInteger a long para la consulta SQL
            ps.setLong(6, orden.getIDorden().longValue());

            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al actualizar Orden: " + e.toString());
            return 0;
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }
        }
    }

    public OrdenServicio obtenerPorId(int id) {
        String sql = "SELECT * FROM ordenservicios WHERE IDorden = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                OrdenServicio ord = new OrdenServicio();
                ord.setIDorden(rs.getBigDecimal("IDorden").toBigInteger());
                ord.setReporte(rs.getString("reporte"));
                ord.setDiagnostico(rs.getString("diagnostico"));
                ord.setEstado_actual(rs.getString("estado_actual"));
                ord.setFecha_ingreso(rs.getString("fecha_ingreso"));
                ord.setCliente_id(rs.getString("Cliente_id"));
                return ord;
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener orden: " + e.toString());
        }
        return null;
    }

    public int eliminar(int idOrden) {
        String sql = "DELETE FROM ordenservicios WHERE IDorden = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idOrden);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al eliminar Orden: " + e.toString());
            return 0;
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }
        }
    }

    public List<long[]> obtenerProductosPorOrden(BigInteger ordenId) {
        List<long[]> lista = new ArrayList<>();
        String sql = "SELECT producto_id, cantidad FROM orden_productos WHERE orden_id = ?";
        try (Connection con = cn.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setObject(1, ordenId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new long[]{rs.getLong("producto_id"), rs.getLong("cantidad")});
                }
            }
        } catch (SQLException e) { System.err.println("Error al leer productos de la orden: " + e.getMessage()); }
        return lista;
    }
}
