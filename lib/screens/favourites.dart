import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/model/location.dart';
import 'package:propertymarket/model/property.dart';
import 'package:propertymarket/navigator/menu_drawer.dart';
import 'package:propertymarket/screens/property_detail.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:propertymarket/widget/property_tile.dart';
import 'package:toast/toast.dart';
class FavouriteList extends StatefulWidget {

  FavouriteList();

  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPropertyList();
  }
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  List<String> key=[];

  Future<List<Property>> getPropertyList() async {
    List<Property> list=[];
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("users").child(user.uid).child("favourites").once().then((DataSnapshot dataSnapshot){
      setState(() {
        key.add(dataSnapshot.key);
      });

      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Property property = new Property(
              individualKey,
              DATA[individualKey]['image'],
              DATA[individualKey]['price'].toString(),
              DATA[individualKey]['location'],
              DATA[individualKey]['country'],
              DATA[individualKey]['city'],
              DATA[individualKey]['area'],
              DATA[individualKey]['typeOfProperty'],
              DATA[individualKey]['propertyCategory'],
              DATA[individualKey]['whatsapp'].toString(),
              DATA[individualKey]['call'].toString(),
              DATA[individualKey]['email'],
              DATA[individualKey]['beds'].toString(),
              DATA[individualKey]['bath'].toString(),
              DATA[individualKey]['measurementArea'].toString(),
              DATA[individualKey]['datePosted'],
              DATA[individualKey]['description'],
              DATA[individualKey]['numericalPrice']
          );
          list.add(property);



        }
      }
    }).whenComplete(() async{
      await databaseReference.child("property").once().then((DataSnapshot dataSnapshot){


        if(dataSnapshot.value!=null){
          var KEYS= dataSnapshot.value.keys;
          var DATA=dataSnapshot.value;


          for(var individualKey in KEYS) {
            Property property = new Property(
                individualKey,
                DATA[individualKey]['image'],
                DATA[individualKey]['price'].toString(),
                DATA[individualKey]['location'],
                DATA[individualKey]['country'],
                DATA[individualKey]['city'],
                DATA[individualKey]['area'],
                DATA[individualKey]['typeOfProperty'],
                DATA[individualKey]['propertyCategory'],
                DATA[individualKey]['whatsapp'].toString(),
                DATA[individualKey]['call'].toString(),
                DATA[individualKey]['email'],
                DATA[individualKey]['beds'].toString(),
                DATA[individualKey]['bath'].toString(),
                DATA[individualKey]['measurementArea'].toString(),
                DATA[individualKey]['datePosted'],
                DATA[individualKey]['description'],
                DATA[individualKey]['numericalPrice']
            );
            for(int i=0;i<key.length;i++){
              if(key[i]==individualKey)
                list.add(property);
            }




          }
        }
      });

    });
    return list;

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: _drawerKey,
        drawer: MenuDrawer(),
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
                        child: Text("Favourites",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: FutureBuilder<List<Property>>(
                    future: getPropertyList(),
                    builder: (context,snapshot){
                      if (snapshot.hasData) {
                        if (snapshot.data != null && snapshot.data.length>0) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (BuildContext context) => PropertyDetail(snapshot.data[index])));
                                  },
                                  child: PropertyTile(snapshot.data[index])
                              );
                            },
                          );
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
