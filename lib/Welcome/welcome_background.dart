import 'package:flutter/material.dart';

class WelcomeBackGround extends StatelessWidget {

    final Widget child;

  const WelcomeBackGround({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      color: Colors.white,

      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children:<Widget> [

          Positioned(
              top: 0,
              left: 0,
              child: Image.asset("assets/images/main_top.png",
                width: size.width*0.3,
              )
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset("assets/images/main_bottom.png",
                width: size.width*0.2,
              )
          ),
          child,
        ],
      ),
    );
  }
}
