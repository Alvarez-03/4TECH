package Logica.modelo;

public class Empleado {
    private int ID;
    private String nombre;
    private String email;
    private String telefono;
    private String cargo;
    private String estado;
    private String password;
    private int empresa_id;

    public Empleado(){
    }

    public Empleado(int ID, String nombre, String email, String telefono, String cargo, String estado, String password, int empresa_id) {
        this.ID = ID;
        this.nombre = nombre;
        this.email = email;
        this.telefono = telefono;
        this.cargo = cargo;
        this.estado = estado;
        this.password = password;
        this.empresa_id = empresa_id;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getEmpresa_id() {
        return empresa_id;
    }

    public void setEmpresa_id(int empresa_id) {
        this.empresa_id = empresa_id;
    }
}
