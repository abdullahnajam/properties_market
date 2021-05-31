import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/model/property.dart';
import 'package:propertymarket/values/constants.dart';
class PropertyDetail extends StatefulWidget {
  Property _property;

  PropertyDetail(this._property);

  @override
  _PropertyDetailState createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  IconData _iconData=Icons.favorite_border;
  Color _color=Colors.white;
  bool isFavourite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFavouriteFromDatabase();

  }

  checkFavouriteFromDatabase()async{
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("users").child(user.uid).child("favourites").child(widget._property.id).once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        setState(() {
          _iconData=Icons.favorite;
          _color=Colors.red;
          isFavourite=true;
        });
      }
    });
  }
  checkFavourite(){
    if(isFavourite){
      removeFromFavourites();
    }
    else{
      addToFavourites();
    }
  }
  addToFavourites(){
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child("users").child(user.uid).child("favourites").child(widget._property.id).set({
      'title': widget._property.price,
      'id': widget._property.id

    }).then((value) {
      setState(() {
        _iconData=Icons.favorite;
        _color=Colors.red;
        isFavourite=true;
      });
    })
        .catchError((error, stackTrace) {
      print("inner: $error");

    });
  }
  removeFromFavourites(){
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child("users").child(user.uid).child("favourites").child(widget._property.id).remove().then((value) {
      setState(() {
        _iconData=Icons.favorite_border;
        _color=Colors.white;
        isFavourite=false;
      });
    })
        .catchError((error, stackTrace) {
      print("inner: $error");

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            child: ListView(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: DecorationImage(
                        image: NetworkImage(widget._property.image),
                        fit: BoxFit.cover
                    ),

                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Property Details",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),),
                            IconButton(icon: Icon(_iconData,color: _color), onPressed: checkFavourite),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.grey[200],
                  child: Text(widget._property.price,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
                ),
                Container(color: Colors.grey[300],height: 3,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/bed.png",width: 20,height: 20,),
                        SizedBox(width: 5,),
                        Text(widget._property.beds),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset("assets/images/bath.png",width: 20,height: 20,),
                        SizedBox(width: 5,),
                        Text(widget._property.bath),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset("assets/images/square.png",width: 20,height: 20,),
                        SizedBox(width: 5,),
                        Text("${widget._property.measurementArea} Sq. ft."),
                      ],
                    ),


                  ],
                ),
                SizedBox(height: 10,),
                Container(color: Colors.grey[300],height: 3,),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Details",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        padding:EdgeInsets.only(top: 3,bottom: 3) ,
                        color: Colors.grey[200],
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Icon(Icons.house_outlined),
                                  SizedBox(width: 10,),
                                  Text("Type",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(widget._property.typeOfProperty,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        padding:EdgeInsets.only(top: 3,bottom: 3) ,
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Icon(Icons.monetization_on_outlined),
                                  SizedBox(width: 10,),
                                  Text("Price",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(widget._property.price,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        padding:EdgeInsets.only(top: 3,bottom: 3) ,
                        color: Colors.grey[200],
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Icon(Icons.king_bed_outlined),
                                  SizedBox(width: 10,),
                                  Text("Bed(s)",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(widget._property.beds,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        padding:EdgeInsets.only(top: 3,bottom: 3) ,
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Icon(Icons.square_foot_outlined),
                                  SizedBox(width: 10,),
                                  Text("Area",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(widget._property.measurementArea,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        padding:EdgeInsets.only(top: 3,bottom: 3) ,
                        color: Colors.grey[200],
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_outline),
                                  SizedBox(width: 10,),
                                  Text("Purpose",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(widget._property.propertyCategory,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Location",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(widget._property.location,style: TextStyle(color: Colors.grey,fontSize: 15),),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Description",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(widget._property.description,style: TextStyle(color: Colors.grey,fontSize: 15),),
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 7,bottom: 7),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.phone_outlined,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Call",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white),),
                        ],
                      )
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 7,bottom: 7),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Email",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white),),
                        ],
                      )
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 7,bottom: 7),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/images/whatsapp.png",color: Colors.white,width: 25,height: 25,),
                          SizedBox(width: 5,),
                          Text("Whatsapp",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white),),
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
