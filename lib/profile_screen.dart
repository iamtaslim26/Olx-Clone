import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx_clone_practice/globalvariables.dart';
import 'package:olx_clone_practice/home_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'image_slider_page.dart';

class ProfileScreen extends StatefulWidget {

  final String sellerId;

  const ProfileScreen({Key key, this.sellerId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  QuerySnapshot ads;

  initState(){
    super.initState();

      getDetails();
  }

   getDetails() {
     
    FirebaseFirestore.instance.collection("Items").where("uid",isEqualTo: widget.sellerId).get()
        .then((value) {
          
          setState(() {
             ads=value;
            addImageUrl=ads.docs[0].get("imgPro");
            addUserName=ads.docs[0].get("userName");
          });
    });
  }

   buildBackButton() {
    IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );

  }

   buildUserImage(){
     return Container(
       width: 50,
       height: 50,
       decoration: BoxDecoration(
           shape: BoxShape.circle,
           image: DecorationImage(
               image: NetworkImage(addImageUrl),
             fit: BoxFit.cover
           )
       ),
     );
   }

  Future<bool>showDialogForupdateData(selectedDoc,oldUserName,oldUserNumber,oldDescription,oldItemColor,oldItemModel, oldItemPrice){

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text("Update Data",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    initialValue: oldUserName,
                    decoration: InputDecoration(
                      hintText: "Enter your name",

                    ),
                    onChanged: (value){
                      setState(() {
                        oldUserName=value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0,),

                  TextFormField(
                    initialValue: oldUserNumber,
                    decoration: InputDecoration(
                      hintText: "Enter your Number",

                    ),
                    onChanged: (value){
                      setState(() {
                        oldUserNumber=value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0,),

                  TextFormField(
                    initialValue: oldItemPrice,
                    decoration: InputDecoration(
                      hintText: "Enter the Price",

                    ),
                    onChanged: (value){
                      setState(() {
                        oldItemPrice=value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0,),

                  TextFormField(
                    initialValue: oldItemColor,
                    decoration: InputDecoration(
                      hintText: "Enter Item Color",

                    ),
                    onChanged: (value){
                      setState(() {
                        oldItemColor=value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0,),

                  TextFormField(
                    initialValue: oldItemModel,
                    decoration: InputDecoration(
                      hintText: "Enter your Model",

                    ),
                    onChanged: (value){
                      setState(() {
                        oldItemModel=value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0,),

                  TextFormField(
                    initialValue: oldDescription,
                    decoration: InputDecoration(
                      hintText: "Write Description",

                    ),
                    onChanged: (value){
                      setState(() {
                        oldDescription=value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (){

                          Map<String,dynamic>updateData={

                            "userName":oldUserName,
                            "description":oldDescription,
                            "itemColor":oldItemColor,
                            "itemModel":oldItemModel,
                            "itemPrice":oldItemPrice,
                            "userNumber":oldUserNumber,

                          };

                          FirebaseFirestore.instance.collection("Items").doc(selectedDoc).update(updateData)
                              .then((value){

                            Fluttertoast.showToast(msg: "Data Updated Successfully. . .",timeInSecForIosWeb: 2);

                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

                          }).catchError((error){

                            Fluttertoast.showToast(msg: "Something is Wrong. . .");
                          });
                        },
                        child: Text("Update"),
                      ),

                      SizedBox(width: 30.0,),

                      ElevatedButton(
                        onPressed: (){

                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  deleteAdd(selectedDoc) {
    showDialog(
        context: context,
        barrierDismissible: false,

        builder: (context) {
          return AlertDialog(

            title: Text("Do you want to Delete this Product?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),

            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){

                    FirebaseFirestore.instance.collection("Items").doc(selectedDoc).delete().then((value) {

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                      Fluttertoast.showToast(msg: "Add Deleted Successfully. . . ",timeInSecForIosWeb: 3);


                    }).catchError((error){

                      Fluttertoast.showToast(msg: "Failed....   "+error.toString());
                    });

                  },
                  child: Text("Yes"),
                ),

                SizedBox(width: 30,),

                ElevatedButton(
                  onPressed: (){

                    Navigator.pop(context);
                  },
                  child: Text("No"),
                ),
              ],
            ),
          );
        }
    );

  }



    @override
  Widget build(BuildContext context) {

      Widget showItemList() {

        if(ads!=null){

          return ListView.builder(
              itemCount: ads.docs.length,
              itemBuilder: (context,index){

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(

                    children:<Widget> [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            leading: GestureDetector(
                              onTap: (){

                                // visit UserProfile Code
                                // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>ProfileScreen(
                                //   sellerId:ads.docs[index].get("uid"),
                                // )));
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(ads.docs[index].get("imgPro"),)
                                    )

                                ),
                              ),
                            ),
                            title: GestureDetector(
                              onTap: (){},
                              child: Text(ads.docs[index].get("userName"),
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),
                              ),
                            ),
                            trailing: ads.docs[index].get("uid")==userId
                                ? //show Edit and Delete Button
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children:<Widget> [

                                GestureDetector(
                                  onTap: (){
                                    if(FirebaseAuth.instance.currentUser.uid==userId) {
                                      showDialogForupdateData(
                                        ads.docs[index].id,
                                        ads.docs[index].get("userName"),
                                        ads.docs[index].get("userNumber"),
                                        ads.docs[index].get("description"),
                                        ads.docs[index].get("itemColor"),
                                        ads.docs[index].get("itemModel"),
                                        ads.docs[index].get("itemPrice"),

                                      );
                                    }
                                  },
                                  child: Icon(Icons.edit,),

                                ),
                                SizedBox(width: 20.0,),

                                GestureDetector(
                                  onDoubleTap: (){

                                    deleteAdd(ads.docs[index].id);
                                  },
                                  child: Icon(Icons.delete_forever_sharp,),

                                ),


                              ],
                            )
                                : // for different User
                            Row(

                              mainAxisSize: MainAxisSize.min,
                              children:<Widget> [

                              ],
                            )

                        ),
                      ),
                      GestureDetector(  // ImageSLider
                        onDoubleTap: (){

                          Route newRoute=MaterialPageRoute(builder: (context)=>ImageSliderPage(

                            title:ads.docs[index].get("itemModel"),
                            itemColor:ads.docs[index].get("itemColor"),
                            userNumber:ads.docs[index].get("userNumber"),
                            userName:ads.docs[index].get("userName"),
                            itemPrice:ads.docs[index].get("itemPrice"),
                            address:ads.docs[index].get("address"),
                            description:ads.docs[index].get("description"),
                            status:ads.docs[index].get("status"),
                            lat:ads.docs[index].get("lat"),
                            lon:ads.docs[index].get("lon"),
                            urlImage1:ads.docs[index].get("urlImage1"),
                            urlImage2:ads.docs[index].get("urlImage2"),
                            urlImage3:ads.docs[index].get("urlImage3"),



                          ));
                          Navigator.pushReplacement(context, newRoute);
                        },
                        child: Image.network(
                          ads.docs[index].get("urlImage1"),
                          fit: BoxFit.fill,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "\$"+ads.docs[index].get("itemPrice"),
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Varella"),

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget> [
                            Row(
                              children: <Widget>[

                                Padding(  // Item Model
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(ads.docs[index].get("itemModel")),
                                    alignment: Alignment.topLeft,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                // get the Time as Timeago

                                Text(timeago.format((ads.docs[index].get("time")).toDate())),
                              ],
                            )

                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        }
        // here we jhave to write the else code
        else{
          Center(
            child: Text("Loading....."),
          );
        }
      }

    return Scaffold(
      appBar: AppBar(
        leading: buildBackButton(),
        title: Row(
          children: [
            buildUserImage(),
            SizedBox(width: 10,),
            Text(addUserName),
          ],


        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient:LinearGradient(
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0,0.0),
                tileMode: TileMode.clamp,
                stops: [0.0,1.0],
                colors: [Colors.purple[300],Colors.green],
              )
          ),
        ),

      ),
      body: showItemList(),
    );
  }

 


}
