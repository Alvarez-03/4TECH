package Logica.modelo;

import java.math.BigInteger;

public class OrdenServicio {
    private BigInteger IDorden ;
    private String reporte;
    private String diagnostico;
    private String estado_actual;
    private String observaciones;
    private String fecha_ingreso;
    private int empresa_id; // Llave foránea
    private int empleado_id;  // Llave foránea
    private String cliente_id; // Llave foranea

    public OrdenServicio() {
    }

    public BigInteger getIDorden() {
        return IDorden;
    }

    public void setIDorden(BigInteger IDorden) {
        this.IDorden = IDorden;
    }

    public String getReporte() {
        return reporte;
    }

    public void setReporte(String reporte) {
        this.reporte = reporte;
    }

    public String getDiagnostico() {
        return diagnostico;
    }

    public void setDiagnostico(String diagnostico) {
        this.diagnostico = diagnostico;
    }

    public String getEstado_actual() {
        return estado_actual;
    }

    public void setEstado_actual(String estado_actual) {
        this.estado_actual = estado_actual;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public String getFecha_ingreso() {
        return fecha_ingreso;
    }

    public void setFecha_ingreso(String fecha_ingreso) {
        this.fecha_ingreso = fecha_ingreso;
    }

    public int getEmpresa_id() {
        return empresa_id;
    }

    public void setEmpresa_id(int empresa_id) {
        this.empresa_id = empresa_id;
    }

    public int getEmpleado_id() {
        return empleado_id;
    }

    public void setEmpleado_id(int empleado_id) {
        this.empleado_id = empleado_id;
    }

    public String getCliente_id() { return cliente_id; }

    public void setCliente_id(String cliente_doc) { this.cliente_id = cliente_doc; }
}
