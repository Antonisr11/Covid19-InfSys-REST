package my.restful.web.services;

public class User {
    private final String AMKA;
    private final String name;
    private final String password;
    private final String email;
    private final Boolean isAdmin;

    public User(String AMKA, String name, String password, String email, Boolean isAdmin) {
        this.AMKA = AMKA;
        this.name = name;
        this.password = password;
        this.email = email;
        this.isAdmin=isAdmin;
    }

    public String getAMKA() {
        return AMKA;
    }

    public String getName() {
        return name;
    }

    public String getPassword() {
        return password;
    }

    public String getEmail() {
        return email;
    }

    public Boolean isAdmin() {
        return isAdmin;
    }
}
