import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone_practice/Welcome/Components/welcolme_screen.dart';
import 'package:olx_clone_practice/home_screen.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  splashScreenCode(){
    Timer(Duration(seconds: 2),(){

        if(FirebaseAuth.instance.currentUser!=null){

          Route newRoute2=MaterialPageRoute(builder: (context)=>HomeScreen());
          Navigator.pushReplacement(context, newRoute2);
        }
        else{
          Route newRoute2=MaterialPageRoute(builder: (context)=>WelcomeScreen());
          Navigator.pushReplacement(context, newRoute2);
        }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    splashScreenCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: TileMode.clamp,
            colors: [Colors.purple,Colors.deepPurple],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [1.0,0.0],

          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),

                    child: Image.asset("assets/images/logo.png",height: 300,),

                ),
              ),
              SizedBox(height: 20.0,),
              Center(
                child: Text("Sale or Purchase and Exchange Products in this App",
                  style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: "Lobster")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
