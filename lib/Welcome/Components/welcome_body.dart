import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olx_clone_practice/Login/Components/login_screen.dart';
import 'package:olx_clone_practice/Signup/Components/signup_screen.dart';
import 'package:olx_clone_practice/Welcome/welcome_background.dart';
import 'package:olx_clone_practice/Widgets/rounded_button.dart';

class WelcomeBody extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;
    return WelcomeBackGround(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Text("Olx Clone",style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              fontFamily: "Signatra",
              color: Colors.deepPurple,
            ),),
            
            SizedBox(height: 20.0,),
            SvgPicture.asset("assets/icons/chat.svg",
             height: size.height*0.45,
            ),
            SizedBox(height: 20.0,),

            RoundedButton(
              color: Colors.deepPurple,
              press: (){

                Route newRoute1=MaterialPageRoute(builder: (context)=>LoginScreen());
                Navigator.push(context, newRoute1);
              },
              textColor: Colors.white,
              text:"Login",
            ),
            SizedBox(height: 20.0,),

            RoundedButton(
              color: Colors.deepPurple,
              press: (){

                Route newRoute1=MaterialPageRoute(builder: (context)=>SignUpScreen());
                Navigator.push(context, newRoute1);
              },
              textColor: Colors.white,
              text:"Register",
            )
          ],
        ),
      ),
    );
  }
}
