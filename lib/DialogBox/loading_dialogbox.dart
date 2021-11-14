import 'package:flutter/material.dart';

class LoadingDialogBox extends StatelessWidget {

  final String message;

  const LoadingDialogBox({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          CircularProgressIndicator(),
          SizedBox(height: 10.0,),

          Text("Please Wait")
        ],
      ),
    );
  }
}
