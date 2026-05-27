package Logica.modelo;

public class Proveedor {
    private int idProveedor;
    private int empresaId;
    private String nombreEmpresa;
    private String contactoAsesor;
    private String telefonoContacto;

    public Proveedor() {}

    public Proveedor(int empresaId, String nombreEmpresa, String contactoAsesor, String telefonoContacto) {
        this.empresaId = empresaId;
        this.nombreEmpresa = nombreEmpresa;
        this.contactoAsesor = contactoAsesor;
        this.telefonoContacto = telefonoContacto;
    }

    public int getIdProveedor() { return idProveedor; }
    public void setIdProveedor(int idProveedor) { this.idProveedor = idProveedor; }

    public int getEmpresaId() { return empresaId; }
    public void setEmpresaId(int empresaId) { this.empresaId = empresaId; }

    public String getNombreEmpresa() { return nombreEmpresa; }
    public void setNombreEmpresa(String nombreEmpresa) { this.nombreEmpresa = nombreEmpresa; }

    public String getContactoAsesor() { return contactoAsesor; }
    public void setContactoAsesor(String contactoAsesor) { this.contactoAsesor = contactoAsesor; }

    public String getTelefonoContacto() { return telefonoContacto; }
    public void setTelefonoContacto(String telefonoContacto) { this.telefonoContacto = telefonoContacto; }

}