import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/model/slideshow.dart';
import 'package:propertymarket/navigator/admin_drawer.dart';
import 'package:propertymarket/values/constants.dart';
class AddSlideShow extends StatefulWidget {
  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<AddSlideShow> {
  Future<List<SlideShow>> getSlideList() async {
    List<SlideShow> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("slideshow").once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          SlideShow partnerModel = new SlideShow(
            individualKey,
            DATA[individualKey]['image'],
          );
          print("key ${partnerModel.id}");
          list.add(partnerModel);

        }
      }
    });
    return list;
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: _drawerKey,
        drawer: AdminDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
                  ),

                ),
                child: Stack(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.menu,color: primaryColor,)
                      ),
                      onTap: ()=>_openDrawer(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("SlideShow",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                    ),


                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<SlideShow>>(
                  future: getSlideList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(

                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:  BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data[index].image,
                                          fit: BoxFit.cover,
                                          height: 200,
                                          width: double.maxFinite,
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                      Container(
                                        margin:EdgeInsets.all(5),
                                        child: RaisedButton(
                                          onPressed: ()async{
                                            final databaseReference = FirebaseDatabase.instance.reference();
                                            await databaseReference.child("slideshow").child(snapshot.data[index].id).remove().then((value) {
                                              Navigator.pushReplacement(
                                                  context, MaterialPageRoute(builder: (BuildContext context) => AddSlideShow()));
                                            });
                                          },
                                          color: Colors.red,
                                          child: Text("Delete",style: TextStyle(color: Colors.white),),


                                        )
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            });
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text("no data")
                          ),
                        );
                      }
                    }
                    else if (snapshot.hasError) {
                      return Text('Error : ${snapshot.error}');
                    } else {
                      return new Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )

            ],
          ),
        )

    );
  }
}
