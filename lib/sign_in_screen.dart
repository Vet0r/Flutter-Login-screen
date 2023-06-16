import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_clientes/custom_theme.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isPassDifferent = false; //senhas não são iguais
  bool isAnyEmpty = false; //todos os campos são obrigatorios
  bool isInvalidEmail = false; //email invalido pela google

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
                height: height*0.60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  border: Border.all(width: 2, color: Colors.white30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Cadastro", 
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: CustomTheme.letras,
                          fontSize: height*0.05
                        ),
                      ),
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
                      (isAnyEmpty||isInvalidEmail),
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
                      (isAnyEmpty||isPassDifferent),
                    ),
                    SizedBox(
                      height: height*0.03,
                    ),
                    textFieldForUser(context,width,TextField(
                      controller: confirmPassController,
                      cursorColor: CustomTheme.background,
                      cursorHeight: height*0.03,
                      obscureText: true,
                      decoration: inputTextdecoration("Confirma Senha"),
                      ),
                      (isAnyEmpty||isPassDifferent),
                    ),
                    SizedBox(
                      height: height*0.01,
                    ),
                    errorMessage(width,height),
                    SizedBox(
                      height: height*0.01,
                    ),
                    loginButton(width,height,passController,confirmPassController,emailController,context),
                    SizedBox(
                      height: height*0.01,
                    ),
                    exitButton(width,height,context),
                    SizedBox(
                      height: height*0.01,
                    ),
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

  errorMessage(double width, double height){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width*0.55,
        height: height*0.02,
        child: Align(
          alignment: Alignment.topRight, 
          child: (isAnyEmpty)?
          const Text("Todos os campos são obrigatórios",style: TextStyle(color: Colors.red),):
                (isPassDifferent)?
          const Text("Senhas não são iguis",style: TextStyle(color: Colors.red),):
                (isInvalidEmail)?
          const Text("Email inválido",style: TextStyle(color: Colors.red),):
          Container(),
        ),
      ),
    );
  }

  exitButton(double width,double height, BuildContext context){
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
          "Voltar",
          style: TextStyle(
            fontSize: height*0.03,
            color: CustomTheme.letras 
          ),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

loginButton(double width,double height, TextEditingController? pass,TextEditingController? confirmPass, TextEditingController? email, BuildContext context){
  return TextButton(
    child: Container(
      decoration: BoxDecoration(
        color: CustomTheme.darkBackground,
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
    setState(() {
      isPassDifferent = false;
      isAnyEmpty = false;
      isInvalidEmail = false;
    });

    if (pass!.text!=""&&confirmPass!.text!=""&&email!.text != "") {
      if ((pass.text == confirmPass.text)) {
        if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text)){
          FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: pass.text)
            .then((value){
              Navigator.of(context).pop();
            },
          );
        }else{
          print("Email =-----------");
          setState(() {
            isInvalidEmail = true;
          });
        }
      }else{
        setState(() {
          isPassDifferent = true;
        });
      }
    }else{
        setState(() {
          isAnyEmpty = true;
        });
      }
    },
  );
}

inputTextdecoration(String text){
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

