import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/admin/add_property.dart';
import 'package:propertymarket/admin/admin_property_detail_view.dart';
import 'package:propertymarket/model/property.dart';
import 'package:propertymarket/navigator/admin_drawer.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:propertymarket/values/shared_prefs.dart';
class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
  Future<List<Property>> getPropertyList() async {
    List<Property> list=[];
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("property").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Property property = new Property(
              individualKey,
              DATA[individualKey]['image'],
              DATA[individualKey]['name'],
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
              DATA[individualKey]['numericalPrice'],
              DATA[individualKey]['payment'],
              DATA[individualKey]['furnish'],
            DATA[individualKey]['agentName'],
            DATA[individualKey]['sponsered'],
            DATA[individualKey]['floor'],
            DATA[individualKey]['serial'],
              DATA[individualKey]['name_ar'],
              DATA[individualKey]['agentName_ar'],
              DATA[individualKey]['area_ar'],
              DATA[individualKey]['city_ar'],
              DATA[individualKey]['country_ar'],
              DATA[individualKey]['description_ar'],
              DATA[individualKey]['furnish_ar'],
              DATA[individualKey]['payment_ar'],
              DATA[individualKey]['typeOfProperty_ar'],
              DATA[individualKey]['propertyCategoryAr'],
            DATA[individualKey]['price_en'],
            DATA[individualKey]['price_ar'],
          );
          list.add(property);


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
    context.locale = Locale('en', 'US');
    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: _drawerKey,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (BuildContext context) => AddProperty()));
          },
        ),
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
                      child: Text("Properties",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                    ),


                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Property>>(
                  future: getPropertyList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (BuildContext context) => AdminPropertyDetail(snapshot.data[index])));
                                },

                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data[index].image[0],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          )
                                      ),
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(timeAgoSinceDate(snapshot.data[index].datePosted),style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300),),
                                                SizedBox(height: 10,),
                                                Text(snapshot.data[index].name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.black),),
                                                SizedBox(height: 5,),
                                                Text(snapshot.data[index].location,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.black),),
                                                SizedBox(height: 5,),
                                                Text("Flat for ${snapshot.data[index].propertyCategory}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                                SizedBox(height: 5,),
                                                Text("Serial Number # ${snapshot.data[index].serial}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                                SizedBox(height: 7,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset("assets/images/bed.png",width: 15,height: 15,),
                                                        SizedBox(width: 5,),
                                                        Text(snapshot.data[index].beds),
                                                        SizedBox(width: 5,),
                                                        Image.asset("assets/images/bath.png",width: 15,height: 15,),
                                                        SizedBox(width: 5,),
                                                        Text(snapshot.data[index].bath),
                                                        SizedBox(width: 5,),
                                                        Image.asset("assets/images/square.png",width: 15,height: 15,),
                                                        SizedBox(width: 5,),
                                                        Text("${snapshot.data[index].measurementArea} Sq. ft."),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),

                                              ],
                                            ),
                                          )
                                      ),
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

  @override
  void initState() {
    super.initState();
    SharedPref sharedPref=new SharedPref();
    sharedPref.setPref(true);

  }
}
