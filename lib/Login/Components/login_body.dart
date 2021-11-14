import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone_practice/DialogBox/errorDialog.dart';
import 'package:olx_clone_practice/DialogBox/loading_dialogbox.dart';
import 'package:olx_clone_practice/Login/login_background.dart';
import 'package:olx_clone_practice/Signup/Components/signup_screen.dart';
import 'package:olx_clone_practice/Welcome/Components/welcolme_screen.dart';
import 'package:olx_clone_practice/Widgets/already_have_an_account_acheck.dart';
import 'package:olx_clone_practice/Widgets/rounded_button.dart';
import 'package:olx_clone_practice/Widgets/rounded_input_field.dart';
import 'package:olx_clone_practice/Widgets/rounded_password_field.dart';

import '../../home_screen.dart';

class LoginBody extends StatefulWidget {


  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  var emailEditingController=TextEditingController();
  var passwordEditingController=TextEditingController();
  FirebaseAuth auth=FirebaseAuth.instance;

  loginAccount(){

    User currentUser;

    showDialog(context: context,
        builder:(_){
      return LoadingDialogBox();
        }
    );

    auth.signInWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text)
        .then((value) {

          currentUser=value.user;

          Route newRoute=MaterialPageRoute(builder: (context)=>HomeScreen());
          Navigator.pushReplacement(context, newRoute);

    }).catchError((error){

      showDialog(context: context,
          builder: (_){

        return ErrorDialog(message:"Failed "+ error.toString(),);
          }
      );
    });

    if(auth.currentUser!=null){

      getUserInfo(currentUser.uid);
    }

  }

  getUserInfo(String uid) async{
        await FirebaseFirestore.instance.collection("Olx Users").doc(uid).get().then((results) {

              String status=results.data()["status"];

              if(status=="approved"){

                Route newRoute=MaterialPageRoute(builder: (context)=>HomeScreen());
                Navigator.pushReplacement(context, newRoute);
              }
              else{
                showDialog(context: context,
                    builder:(context){

                      return ErrorDialog(message: "You are blocked by the Admin",);
                    }
                );
                auth.signOut();
                Route newRoute=MaterialPageRoute(builder: (context)=>WelcomeScreen());
                Navigator.pushReplacement(context, newRoute);
              }

        });
  }

  @override
  Widget build(BuildContext context) {
    return LoginBackGround(

      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[

            RoundedInputField(
              hintText: "Email",
              icon: Icons.email,
              onChanged: (value){

                emailEditingController.text=value;
              },
            ),

            SizedBox(height: 10.0,),

            RoundedPasswordField(

              onChanged: (value){

                passwordEditingController.text=value;
              },
            ),
            SizedBox(height: 10.0,),

            RoundedButton(
              press: (){

               loginAccount();
              },
              text: "Login",

              color: Colors.deepPurple[100],
              textColor: Colors.black,

            ),
            SizedBox(height: 10.0,),

            AlreadyHaveAnAccountCheck(
              press:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen())),
              login: false,


            )


          ],
        ),
      ),
    );
  }


}
