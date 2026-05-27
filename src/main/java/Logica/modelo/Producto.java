package Logica.modelo;

public class Producto {
    private long producto_id;
    private String nombre;
    private int cantidad;
    private double costo;
    private long empresa_id;
    private int proveedorId;

    public Producto() {}

    public long getEmpresa_id() {
        return empresa_id;
    }

    public void setEmpresa_id(long empresa_id) {
        this.empresa_id = empresa_id;
    }

    public double getCosto() {
        return costo;
    }

    public void setCosto(double costo) {
        this.costo = costo;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public long getProducto_id() {
        return producto_id;
    }

    public void setProducto_id(long producto_id) {
        this.producto_id = producto_id;
    }

    public int getProveedorId() { return proveedorId; }

    public void setProveedorId(int proveedorId) { this.proveedorId = proveedorId; }
}
