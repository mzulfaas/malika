package login.model;

public interface IUser {
    String getEmail();
    String getPassword();
    int isValidData();
    Boolean login();
}

