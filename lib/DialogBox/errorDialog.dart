import 'package:flutter/material.dart';
import 'package:olx_clone_practice/Welcome/Components/welcolme_screen.dart';

class ErrorDialog extends StatelessWidget {

  final String message;

  const ErrorDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      key: key,
      actions: [

        ElevatedButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen())),
            child: Center(child: Text("Ok")),
        )
      ],

    );
  }
}
