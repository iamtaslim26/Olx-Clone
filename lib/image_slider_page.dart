import 'package:flutter/material.dart';
import 'package:image_slider/image_slider.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'home_screen.dart';

class ImageSliderPage extends StatefulWidget {


  final String status,userName,userNumber,address,title,itemColor,itemPrice,description;
  final String urlImage1,urlImage2,urlImage3;
  final double lat,lon;

  const ImageSliderPage({Key key,
    this.status,
    this.userName,
    this.userNumber,
    this.address,
    this.title,
    this.itemColor,
    this.itemPrice,
    this.description,
    this.urlImage1,
    this.urlImage2,
    this.urlImage3,
    this.lat,
    this.lon}) : super(key: key);



  @override
  _ImageSliderPageState createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<ImageSliderPage> with SingleTickerProviderStateMixin{

  TabController tabController;
  List<String>links=[];


  getLinks(){
    links.add(widget.urlImage1);
    links.add(widget.urlImage2);
    links.add(widget.urlImage3);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLinks();

    tabController=TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    double screen_width=MediaQuery.of(context).size.width;
    double screen_height=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
          },
          icon: Icon(Icons.arrow_back),

        ),
        title: Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 20.0,left: 6.0,right: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Icon(Icons.location_pin),
                      Expanded(
                        child: Text(widget.address,style: TextStyle(letterSpacing: 2.0),
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.fade,
                        ),

                      ),

                    ],
                  ),

                ),

                SizedBox(height: 20.0,),

                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 2.0),

                  ),
                  child: ImageSlider(
                    width: screen_width,
                    height: screen_height/3,
                    showTabIndicator: false,
                    allowManualSlide: true,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(seconds: 4),
                    autoSlide: true,
                    tabController:tabController ,
                    children:links.map((String link) {
                      return ClipRRect(
                        child: Image.network(
                          link,
                          height: 220,
                          width: screen_width,
                          fit: BoxFit.fill,
                        ),
                      );
                    }).toList(),

                  ),
                ),

                SizedBox(height: 20.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // when the index is 0
                    tabController.index==0?Container(height: 0,width: 0,)
                        :
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: (){

                          tabController.animateTo(tabController.index-1);
                          setState(() {

                          });
                        },
                        child:Text("previous",),
                        style:  ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                        ),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(

                        onPressed: (){
                          tabController.animateTo(4);
                          setState(() {

                          });
                        },
                        child:Text("Skip",),
                        style:  ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                        ),

                      ),
                    )   ,
                    // when the index is 0

                    tabController.index==2?Container(height: 0,width: 0,)
                        :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(

                        onPressed: (){
                          tabController.animateTo(tabController.index+1);
                          setState(() {

                          });
                        },
                        child:Text("Next",),
                        style:  ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                        ),

                      ),
                    ),


                  ],
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget> [
                      Row(
                        children: [

                          Icon(Icons.brush_outlined),
                          SizedBox(width: 10.0,),
                          Text(widget.itemColor,style: TextStyle(fontSize: 20,color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),

                      Row(
                        children: [

                          Icon(Icons.phone_android),
                          SizedBox(width: 10.0,),
                          Text(widget.userNumber,style: TextStyle(fontSize: 20,color: Colors.black),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.description,style: TextStyle(fontSize: 20,color: Colors.purple,fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 368),
                    child: ElevatedButton(
                      onPressed: (){
                        MapsLauncher.launchCoordinates(widget.lat, widget.lon);
                      },
                      child: Text("Check Seller Location"),
                    ),
                  ),
                ),
                SizedBox(height: 20,),

              ],
            ),
          ),
        ),
      ),
    );;
  }
}
