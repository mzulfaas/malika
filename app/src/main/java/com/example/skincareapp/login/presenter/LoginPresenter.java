package com.example.skincareapp.login.presenter;



import com.example.skincareapp.login.model.User;
import com.example.skincareapp.login.view.ILoginView;

public class LoginPresenter implements ILoginPresenter {

    ILoginView loginView;

    public LoginPresenter(ILoginView loginView) {
        this.loginView = loginView;
    }
//    public Boolean login(String username, String password) {
//        return username.equals("zulfa") && password.equals("123");
//    }

    @Override
    public void onLogin(String email, String password) {
        User user = new User(email, password);
        int loginCode = user.isValidData();


        if(loginCode == 0) {
            loginView.onLoginError("You must enter your email");
        } else if(loginCode == 1) {
            loginView.onLoginError("You must enter valid email");
        } else if(loginCode == 2) {
            loginView.onLoginError("Password length must be greater than 6");
        } else {
            if(user.login())
                 loginView.onLoginSuccess("Login success");
            else
                 loginView.onLoginError("Username dan password tidak cocok.");
        }
    }
}
