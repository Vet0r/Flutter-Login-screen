import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_clientes/custom_theme.dart';

class ForgotMyPassword extends StatefulWidget {
  const ForgotMyPassword({super.key});

  @override
  State<ForgotMyPassword> createState() => _ForgotMyPasswordState();
}

class _ForgotMyPasswordState extends State<ForgotMyPassword> {
  TextEditingController emailController = TextEditingController();

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
                height: height*0.43,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  border: Border.all(width: 2, color: Colors.white30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: height*0.01,
                    ),
                    message(width),
                    SizedBox(
                      height: height*0.01,
                    ),
                    textFieldForUser(context,width,TextField(
                      controller: emailController,
                      cursorColor: CustomTheme.background,
                      cursorHeight: height*0.03,
                      decoration: inputTextdecoration("Email"),
                      ),
                    ),
                    SizedBox(
                      height: height*0.01,
                    ),
                    sendButton(width,height,emailController,context),
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

  message(double width){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 10),
      child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(
                  fontSize: width*0.05,
                  color: Colors.black,
                ),
                text: "Digite seu email a baixo e iremos te enviar um email para recuperar sua senha. Não esqueça de checar o SPAM",
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

sendButton(double width,double height,TextEditingController? email, BuildContext context){
  return TextButton(
    child: Container(
      decoration: BoxDecoration(
        color: CustomTheme.darkBackground,
        border: Border.all(width: 2, color: Colors.white30),
        borderRadius: BorderRadius.circular(12),
      ),
      width: width*0.40,
      height: height*0.05,
      child: Center(
        child: Text(
          "Enviar",
          style: TextStyle(
            fontSize: height*0.03,
            color: CustomTheme.letras 
          ),
        ),
      ),
    ),
  onPressed: ()async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    Navigator.of(context).pop();
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

textFieldForUser(BuildContext context,double width, TextField campo){
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15,sigmaY: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          border: Border.all(width: 2, color: Colors.white30),
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

