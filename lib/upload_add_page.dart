import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone_practice/DialogBox/loading_dialogbox.dart';
import 'package:olx_clone_practice/globalvariables.dart';
import 'package:olx_clone_practice/home_screen.dart';
import 'package:toast/toast.dart';
import "package:path/path.dart "as Path;

class UploadPost extends StatefulWidget {

  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {

  bool isUploading = false,
      next = false;
  double val = 0;

  CollectionReference imgRef;
  firebaseStorage.Reference reference;

  String imgFile = "";
  String imgFile1 = "";
  String imgFile2 = "";

  List<File>image = [];
  List<String>urlList = [];
  final picker = ImagePicker();

  FirebaseAuth auth = FirebaseAuth.instance;
  String userName = "";
  String userNumber = "";
  String itemPrice = "";
  String itemColor = "";
  String itemModel = "";
  String itemDescription = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          next == true ? "Please Write Item's Info" : "Choose Item's Images",
          style: TextStyle(fontSize: 18.0,
              color: Colors.white,
              fontFamily: "Lobster",
              letterSpacing: 2.0),
        ),

        actions: <Widget>[
          next == true ? Container()
              : ElevatedButton(
            onPressed: () {
              if (image.length == 3) {
                setState(() {
                  isUploading = true;
                  next = true;
                });
              }
              else {
                showToast(
                    "Please Select 3 images",
                    duration: 2,
                    gravity: Toast.CENTER

                );
              }
            },
            child: Text("Next",
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Valera",
                  color: Colors.white
              ),
            ),

          )
        ],
        flexibleSpace: Container(

          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  tileMode: TileMode.clamp,
                  colors: [Colors.purple, Colors.deepPurple]
              )
          ),
        ),

      ),
      body: next == true ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              TextField(
                onChanged: (value) {
                  this.userName = value;
                },
                decoration: InputDecoration(
                  hintText: "Write your name",
                ),

              ),
              SizedBox(height: 10.0,),
              TextField(
                onChanged: (value) {
                  this.userNumber = value;
                },
                decoration: InputDecoration(
                  hintText: "Write your Number",
                ),

              ),

              SizedBox(height: 10.0,),
              TextField(
                onChanged: (value) {
                  this.itemPrice = value;
                },
                decoration: InputDecoration(
                  hintText: "Write Item Price",
                ),

              ),
              SizedBox(height: 10.0,),
              TextField(
                onChanged: (value) {
                  this.itemColor = value;
                },
                decoration: InputDecoration(
                  hintText: "Write ItemColor. . ",
                ),

              ),
              SizedBox(height: 10.0,),
              TextField(
                onChanged: (value) {
                  this.itemModel = value;
                },
                decoration: InputDecoration(
                  hintText: "Write Item Model",
                ),

              ),
              SizedBox(height: 10.0,),
              TextField(
                onChanged: (value) {
                  this.itemDescription = value;
                },
                decoration: InputDecoration(
                  hintText: "Write Description. . .",
                ),

              ),

              SizedBox(height: 10.0,),

              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 2,
                child: ElevatedButton(

                  child: Text("Upload", style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    showDialog(context: context,
                        builder: (_) {
                          return LoadingDialogBox();
                        });
                    uploadFile().whenComplete(() {
                      Map<String, dynamic>addData = {

                        "userName": this.userName,
                        "userNumber": this.userNumber,
                        "itemModel": this.itemModel,
                        "itemColor": this.itemColor,
                        "itemPrice": this.itemPrice,
                        "description": this.itemDescription,
                        "urlImage1": urlList[0].toString(),
                        "urlImage2": urlList[1].toString(),
                        "urlImage3": urlList[2].toString(),
                        "imgPro": userImageUrl,
                        "lat": position.latitude,
                        "lon": position.longitude,
                        "time": DateTime.now(),
                        "status": "Not Approved",
                        "address": completeAddress,
                        "uid": auth.currentUser.uid,

                      };

                      FirebaseFirestore.instance.collection("Items").add(
                          addData).then((value) {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HomeScreen()));

                        //Fluttertoast.showToast(msg: "Data Uploaded Succesfully. . .",timeInSecForIosWeb: 3);
                        print("Data saved");
                      }).catchError((error) {
                        // Fluttertoast.showToast(msg: "Failed...   "+error.toString(),timeInSecForIosWeb: 2);

                      });
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0,)

            ],
          ),
        ),
      ) : Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,

                  ),
                  itemCount: image.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0 ?
                    Center(
                      child: IconButton(
                        onPressed: () {
                          isUploading == false ? chooseImage() : null;
                        },

                        icon: Icon(Icons.add),
                      ),
                    ) : Container(
                      margin: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(image[index - 1]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }

              ),

            ),
          ),
          isUploading ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Uploading.....",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 20.0,),
                CircularProgressIndicator(
                  value: val,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                )
              ],
            ),
          ) : Container()
        ],
      ),
    );
  }

  void showToast(String message, {int duration, gravity}) {
    Toast.show(message, context, duration: duration, gravity: gravity);
  }

  chooseImage() async {
    final pickImage = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    setState(() {
      image.add(File(pickImage.path));
    });

    if (pickImage.path == null) {
      retrieveLostData();
    }
  }


  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();

    if (response.isEmpty) {
      return;
    }
    else if (response.file != null) {
      return image.add(File(response.file.path));
    }
    else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    var time = DateTime.now();
    int i = 1;
    for (var img in image) {
      setState(() {
        val = i / image.length;
        print("Here the val is " + val.toString());
      });
      reference = firebaseStorage.FirebaseStorage.instance.ref().child(
          "image/${img.path}");

      await reference.putFile(img).whenComplete(() async {
        await reference.getDownloadURL().then((value) {
          urlList.add(value);
          i++;
        });
      });
    }
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      imgRef = FirebaseFirestore.instance.collection("imageUrls");
    }
  }
}