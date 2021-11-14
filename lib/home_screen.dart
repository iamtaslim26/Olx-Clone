import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:olx_clone_practice/profile_screen.dart';
import 'package:olx_clone_practice/upload_add_page.dart';

import 'Welcome/Components/welcolme_screen.dart';
import 'globalvariables.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'image_slider_page.dart';

class HomeScreen extends StatefulWidget {


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  FirebaseAuth auth=FirebaseAuth.instance;
  
  QuerySnapshot ads;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentAddress();
    getUserData();
    
    FirebaseFirestore.instance.collection("Items").where("status",isEqualTo: "Approved").get()
    .then((value) {

      setState(() {

        ads=value;
      });
    });

  }

  getCurrentAddress()async{

    Position newPosition=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position=newPosition;

    placemarks=await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark=placemarks[0];

    String newCompleteAddress=
        "${placemark.subThoroughfare} ${placemark.thoroughfare},"
        "${placemark.subThoroughfare} ${placemark.locality},"
        "${placemark.subAdministrativeArea},"
        "${placemark.administrativeArea} ${placemark.postalCode}"
        "${placemark.country}";

    completeAddress=newCompleteAddress;
    print("Failed "+completeAddress);
    return completeAddress;

  }
  
  getUserData()async{
    await FirebaseFirestore.instance.collection("Olx Users").doc(userId).get().then((result) {

      setState(() {
          userImageUrl=result.data()["imageUrl"];
          getUserName=result.data()["userName"];

          
      });
      print(userImageUrl);
    });
  }

  Future showEditDialogBox(String id, oldUserName, oldUserNumber, oldItemColor, oldItemPrice, oldDescription, oldItemModel) {

        showDialog(context: context,
            barrierDismissible: false,
            builder: (context){
              return AlertDialog(

                    title: Text("Update Data",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,

                      ),),

                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                          SizedBox(height: 10,),
                          TextFormField(
                            initialValue: oldUserNumber,
                            decoration: InputDecoration(
                              hintText: "Enter your number",

                            ),
                            onChanged: (value){
                              setState(() {
                                oldUserNumber=value;
                              });
                            },
                          ),
                          SizedBox(height: 10,),
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
                          SizedBox(height: 10,),
                          TextFormField(
                            initialValue: oldItemPrice,
                            decoration: InputDecoration(
                              hintText: "Enter Item Price",

                            ),
                            onChanged: (value){
                              setState(() {
                                oldItemPrice=value;
                              });
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            initialValue: oldDescription,
                            decoration: InputDecoration(
                              hintText: "Enter Description",

                            ),
                            onChanged: (value){
                              setState(() {
                                oldDescription=value;
                              });
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            initialValue: oldItemModel,
                            decoration: InputDecoration(
                              hintText: "Enter Item Model",

                            ),
                            onChanged: (value){
                              setState(() {
                                oldItemModel=value;
                              });
                            },
                          ),
                          SizedBox(height: 10.0,),


                        ],

                      ),
                    ),
                actions: [
                  ElevatedButton(
                      onPressed: (){
                          Map<String,dynamic>data={
                            "userName":oldUserName,
                            "description":oldDescription,
                            "itemColor":oldItemColor,
                            "itemModel":oldItemModel,
                            "itemPrice":oldItemPrice,
                            "userNumber":oldUserNumber,
                          };

                          FirebaseFirestore.instance.collection("Items").doc(id).update(data)
                          .then((value) {

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

                            Fluttertoast.showToast(msg: "Data Updated Successfully . .",timeInSecForIosWeb: 2);
                          }).catchError((error){

                            Fluttertoast.showToast(msg: "Failed....  "+error.toString(),timeInSecForIosWeb: 2);
                          });
                      },
                      child:Text("Update",style: TextStyle(color: Colors.white),),

                  ),

                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                      },
                      child: Text("Cancel",style: TextStyle(color: Colors.white),),
                  ),
                ],


              );
            }
        );
  }

  Future DeletePost(String id) {

    showDialog(context: context,
        builder: (context){
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text("Do you want to delete this Item ?",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                onPressed: (){

                  FirebaseFirestore.instance.collection("Items").doc(id).delete().then((value) {

                    Navigator.push(context, MaterialPageRoute(builder:(context)=>HomeScreen()));
                    Fluttertoast.showToast(msg: "Item Deleted Successfully",timeInSecForIosWeb: 2);

                  }).catchError((error){

                    Fluttertoast.showToast(msg: "Failed....  "+error.toString(),timeInSecForIosWeb: 2);
                  });
                  },
                  child: Text("Yes",style: TextStyle(color: Colors.white),),
                  ),

                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                },
                    child: Text("No",style: TextStyle(color: Colors.white),)),
              ],
            );
        }
    );
  }



  @override
  Widget build(BuildContext context) {

    Widget showItemList(){

      if(ads!=null){

        return ListView.builder(
            itemCount: ads.docs.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context,index){
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(

                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: (){},
                          child: Container(
                            
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  ads.docs[index].get("imgPro"),
                                )
                              )
                            ),
                          ),
                        ),
                        title: Text(ads.docs[index].get("userName"),
                        style:TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Varella",
                          color: Colors.black
                        )
                          ,),
                        trailing: ads.docs[index].get("uid")==auth.currentUser.uid?
                            // Show Edit and delete option,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            GestureDetector(
                              onTap: (){
                                  //Edit Code

                                showEditDialogBox(
                                  ads.docs[index].id,
                                  ads.docs[index].get("userName"),
                                  ads.docs[index].get("userNumber"),
                                  ads.docs[index].get("itemColor"),
                                  ads.docs[index].get("itemPrice"),
                                  ads.docs[index].get("description"),
                                  ads.docs[index].get("itemModel"),

                                );
                              },
                              child: Icon(Icons.edit,color: Colors.black,),
                            ),

                            SizedBox(width: 15.0,),

                            GestureDetector(
                              onDoubleTap: (){
                                //delete Code

                                DeletePost(ads.docs[index].id);
                              },
                              child: Icon(Icons.delete,color: Colors.black,),
                            ),
                          ],
                        ):Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                          ],
                        ),
                      ),
                    ),

                     GestureDetector(
                      onDoubleTap: (){
                        //Image Slider Code

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
                      child: Image.network(ads.docs[index].get("urlImage1")),
                     ),
                    SizedBox(height: 20,),
                    
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("\$"+ ads.docs[index].get("itemPrice"),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Varella",
                      ),),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 16,right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Row(

                            children: [
                              Icon(Icons.image_sharp),
                              SizedBox(width: 5,),
                              Text(ads.docs[index].get("itemModel"),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              ),

                              Row(
                                children: [
                                  Icon(Icons.watch_later_outlined),
                                  SizedBox(width: 5,),
                                  Text(timeago.format(ads.docs[index].get("time").toDate())),
                                ],
                              )

                            ],
                          )
                        ],
                      ),
                    ),

                     SizedBox(height: 10,),

                  ],
                ),
              );
            }
        );
      }
      else{
        return Center(
          child: Text("Loading......."),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
          },
          icon: Icon(Icons.refresh_outlined),
        ),
        actions: <Widget>[
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(
              sellerId:auth.currentUser.uid,
            )));
          },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.person,color: Colors.white,),
              )
          ),

          TextButton(onPressed: (){

          },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.search,color: Colors.white,),
              )
          ),
          TextButton(onPressed: (){
            auth.signOut().then((value) {

              Route newRoute2=MaterialPageRoute(builder: (context)=>WelcomeScreen());
              Navigator.pushReplacement(context, newRoute2);
            });
          },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.logout,color: Colors.white,),
              )
          ),
        ],
        title: Text("Home Page"),

        flexibleSpace: Container(

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const FractionalOffset(0.0, 0.0),
              end:  const FractionalOffset(1.0, 0.0),
              tileMode: TileMode.clamp,
              colors: [Colors.purple,Colors.deepPurple]
            )
          ),
        ),
      ),

      body: Center(
        child: Container(
          child: showItemList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadPost()));
        },
        tooltip: "Add Post",
        child: Icon(Icons.add),backgroundColor: Colors.purple,
      ),

    );
  }




}
