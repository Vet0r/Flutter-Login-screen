import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_clientes/custom_theme.dart';
import 'package:gerenciamento_de_clientes/sign_in_screen.dart';

import 'forgot_pass_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isEmailError = false;
  bool isPassError = false;
  bool isUserinexistent = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: height,
          width: width,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset("assets/background.jpg"),
          ),
        ),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15,sigmaY: 15),
              child: Container(
                width: width>450?width*0.4:width*0.8,
                height: height*0.55,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  border: Border.all(width: 2, color: Colors.white30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Login", 
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: CustomTheme.letras,
                          fontSize: height*0.05
                        ),
                      )
                    ),
                    SizedBox(
                      height: height*0.03,
                    ),
                    textFieldForUser(context,width,TextField(
                      controller: emailController,
                      cursorColor: CustomTheme.background,
                      cursorHeight: height*0.03,
                      decoration: inputTextdecoration("Email"),
                      ),
                      (isEmailError||isUserinexistent),
                    ),
                    SizedBox(
                      height: height*0.03,
                    ),
                    textFieldForUser(context,width,TextField(
                      controller: passController,
                      cursorColor: CustomTheme.background,
                      cursorHeight: height*0.03,
                      obscureText: true,
                      decoration: inputTextdecoration("Senha"),
                      ),
                      isPassError,
                    ),
                    SizedBox(
                      height: height*0.005,
                    ),
                    errorMessage(width,height),
                    SizedBox(
                      height: height*0.01,
                    ),
                    loginButton(width,height,passController,emailController),
                    SizedBox(
                      height: height*0.005,
                    ),
                    signinButton(width,height,context),
                    SizedBox(
                      height: height*0.005,
                    ),
                    buttonForgotPass(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }

  buttonForgotPass(){
    return TextButton(onPressed:() {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotMyPassword()),
        );
    }, 
    child: Text(
        "Esqueci minha senha",
        style: TextStyle(
          color:CustomTheme.letras
        ),
      ),
    );
  }

  errorMessage(double width, double height){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width*0.55,
        height: height*0.02,
        child: Align(
          alignment: Alignment.topRight, 
          child: (isEmailError)?
          const Text("Email Inválido",style: TextStyle(color: Colors.red),):
                (isPassError)?
          const Text("Senha Inválida",style: TextStyle(color: Colors.red),):
                (isUserinexistent)?
          const Text("Email inexistente",style: TextStyle(color: Colors.red),):
          Container(),
        ),
      ),
    );
  }

  signinButton(double width,double height, BuildContext context){
    return TextButton(
      child: Container(
        decoration: BoxDecoration(
          color: CustomTheme.lightColor,
          border: Border.all(width: 2, color: Colors.white30),
          borderRadius: BorderRadius.circular(12),
        ),
        width: 200,
        height: height*0.05,
        child: Center(
          child: Text(
            "Cadastrar",
            style: TextStyle(
              fontSize: height*0.03,
              color: CustomTheme.letras 
            ),
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      },
    );
  }

  loginButton(double width,double height, TextEditingController? pass, TextEditingController? email){
    return TextButton(
      child: Container(
        decoration: BoxDecoration(
          color: CustomTheme.darkBackground,
          border: Border.all(width: 2, color: Colors.white30),
          borderRadius: BorderRadius.circular(12),
        ),
        width: 140,
        height: height*0.05,
        child: Center(
          child: !isLoading? Text(
            "Login",
            style: TextStyle(
              fontSize: height*0.03,
              color: CustomTheme.letras 
            ),
          ):SizedBox(
            height: height*0.03,

            child: CircularProgressIndicator(
                color: CustomTheme.lightBackgroud,
              ),
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        FirebaseAuth.instance.signInWithEmailAndPassword(email: email!.text, password: pass!.text).
          catchError((value){
            setState(() {
              isEmailError = false;
              isPassError = false;
              isUserinexistent = false;
            });
            switch (value.toString()) {
              case "[firebase_auth/invalid-email] The email address is badly formatted.":
                setState(() {
                  isEmailError = true;
                  isLoading=false;
                });
                break;
              case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
                print("----------- ${value.toString()} ${isUserinexistent} ---------------------");
                setState(() {
                  isUserinexistent = true;
                  isLoading=false;
                });
                break;
              case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
                setState(() {
                  isPassError = true;
                  isLoading=false;
                });
                break;
              default:
            }
            setState(() {
              isLoading=false;
            });
          }
        );
      },
    );
  }

  inputTextdecoration(String text,){
    return InputDecoration(
      contentPadding: EdgeInsets.only(left: 20),
      border: InputBorder.none,
      hintText: text,
    );
  }

  textFieldForUser(BuildContext context,double width, TextField campo, bool isError){
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15,sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            border: Border.all(width: 2, color: isError? Colors.red:Colors.white30),
            borderRadius: BorderRadius.circular(12),
          ),
          child:  SizedBox(
            width: width*0.6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: campo,
            ),
          ),
        ),
      ),
    );
  }
}