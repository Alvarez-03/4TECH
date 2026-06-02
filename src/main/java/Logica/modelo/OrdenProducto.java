package Logica.modelo;

import java.math.BigInteger;

public class OrdenProducto {
    private BigInteger ordenId;
    private long productoId;
    private int cantidad;
    private double valorUnitario;

    public OrdenProducto() {}

    public BigInteger getOrdenId() {
        return ordenId;
    }

    public void setOrdenId(BigInteger ordenId) {
        this.ordenId = ordenId;
    }

    public long getProductoId() {
        return productoId;
    }

    public void setProductoId(long productoId) {
        this.productoId = productoId;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getValorUnitario() {
        return valorUnitario;
    }

    public void setValorUnitario(double valorUnitario) {
        this.valorUnitario = valorUnitario;
    }
}