
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone_practice/DialogBox/errorDialog.dart';
import 'package:olx_clone_practice/DialogBox/loading_dialogbox.dart';
import 'package:olx_clone_practice/Login/Components/login_screen.dart';
import 'package:olx_clone_practice/Signup/signup_background.dart';
import 'package:olx_clone_practice/Widgets/already_have_an_account_acheck.dart';
import 'package:olx_clone_practice/Widgets/rounded_button.dart';
import 'package:olx_clone_practice/Widgets/rounded_input_field.dart';
import 'package:olx_clone_practice/Widgets/rounded_password_field.dart';
import 'package:olx_clone_practice/globalvariables.dart';
import 'package:olx_clone_practice/home_screen.dart';

class SignUpBody extends StatefulWidget {


  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {

  File imagePath;
  String imageUrl="";

  var emailEditingController=TextEditingController();
  var passwordEditingController=TextEditingController();
  var nameEditingController=TextEditingController();
  var phoneEditingController=TextEditingController();

  FirebaseAuth auth=FirebaseAuth.instance;

  uploadImage()async{

    showDialog(
        context: context,
        builder: (_){
          return LoadingDialogBox();
        }
    );

    String filePath=DateTime.now().millisecondsSinceEpoch.toString();
    firebaseStorage.Reference reference=firebaseStorage.FirebaseStorage.instance.ref().child("ProfilePicture").child(filePath);
    firebaseStorage.UploadTask uploadTask=reference.putFile(imagePath);
    firebaseStorage.TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then((url) => {

      imageUrl=url,
      print(imageUrl),
      registerUser(),

    });

  }

  registerUser()async{

    User currentUser;

    auth.createUserWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text)
        .then((value) {

          currentUser=value.user;
          userId=currentUser.uid;
          userEmail=currentUser.email;
          getUserName=nameEditingController.text.trim();

          uploadDataToFirebaseDatabase();

          Route newRoute=MaterialPageRoute(builder: (context)=>HomeScreen());
          Navigator.pushReplacement(context, newRoute);

    }).catchError((error){

      showDialog(context: context,
          builder: (_){
            return ErrorDialog(message: "Failed   "+error.toString());
          }
      );
    });

    if(auth.currentUser!=null){

      Route newRoute=MaterialPageRoute(builder: (context)=>HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    }
  }

  uploadDataToFirebaseDatabase(){

    Map<String,dynamic>userData={

      "userEmail":emailEditingController.text.trim(),
      "uid":userId,
      "imageUrl":imageUrl,
      "phone":phoneEditingController.text.trim(),
      "userName":nameEditingController.text.trim(),
      "status":"approved"

    };

    FirebaseFirestore.instance.collection("Olx Users").doc(userId).set(userData);


  }


  pickImage()async{

    final image=await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {

        imagePath=File(image.path);
    });

  }


  @override
  Widget build(BuildContext context) {

    double screen_height=MediaQuery.of(context).size.height;
    double screen_width=MediaQuery.of(context).size.width;

    return SignupBackGround(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            InkWell(
              onTap: (){
                pickImage();
              },
              child: CircleAvatar(
                radius: screen_width*.20,
                backgroundImage: imagePath==null?null:FileImage(imagePath),
                child: imagePath==null?
                    Icon(Icons.add_a_photo,size: screen_width*.20,color: Colors.white,):null,
                backgroundColor: Colors.purple[200],
              ),
            ),
            SizedBox(height: 20.0,),

            RoundedInputField(
              hintText: "Email",
              icon: Icons.email,
              onChanged: (value){
                emailEditingController.text=value;
              },
            ),
            SizedBox(height: 20.0,),

            RoundedInputField(
              hintText: "name",
              icon: Icons.person,
              onChanged: (value){
                nameEditingController.text=value;
              },
            ),
            SizedBox(height: 20.0,),


            RoundedInputField(
              hintText: "phone Number",
              icon: Icons.phone_android,
              onChanged: (value){

                phoneEditingController.text=value;
              },
            ),
            SizedBox(height: 20.0,),


            RoundedPasswordField(
              onChanged: (value){
                passwordEditingController.text=value;
              },
            ),
            SizedBox(height: 20.0,),
            RoundedButton(
              color: Colors.purple[200],
              text: "Register",
              press: (){
                    uploadImage();
              },
              textColor: Colors.black,
            ),
            SizedBox(height: 20.0,),
            AlreadyHaveAnAccountCheck(
              press: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

              },
              login: false,
            )


          ],
        ),
      ),
    );
  }
}
