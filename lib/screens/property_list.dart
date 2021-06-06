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
import 'package:easy_localization/easy_localization.dart';
enum rentOrBuy { rent, buy }
class PropertyList extends StatefulWidget {
  String country,city,area,type;
  bool isRent;

  PropertyList(this.country, this.city, this.area, this.type, this.isRent);

  @override
  _PropertyListState createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  String selectedCountryId="";
  String selectedCityId="";
  String selectedAreaId="";
  String selectedTypeId="";

  String selectedCountryName='selectCountry'.tr();
  String selectedCityName='selectCity'.tr();
  String selectedAreaName='selectArea'.tr();
  String selectedTypeName='selectType'.tr();

  Future<List<LocationModel>> getCountryList() async {
    List<LocationModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("country").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          LocationModel locationModel = new LocationModel(
            individualKey,
            DATA[individualKey]['name'],
          );
          list.add(locationModel);

        }
      }
    });

    return list;
  }
  Future<List<LocationModel>> getCityList() async {
    List<LocationModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("country").child(selectedCountryId).child("city").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          LocationModel locationModel = new LocationModel(
            individualKey,
            DATA[individualKey]['name'],
          );
          list.add(locationModel);

        }
      }
    });

    return list;
  }
  Future<List<LocationModel>> getAreaList() async {
    List<LocationModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("country").child(selectedCountryId).child("city").child(selectedCityId).child("area").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          LocationModel locationModel = new LocationModel(
            individualKey,
            DATA[individualKey]['name'],
          );
          list.add(locationModel);

        }
      }
    });

    return list;
  }
  Future<List<LocationModel>> getTypeList() async {
    List<LocationModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("type").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          LocationModel locationModel = new LocationModel(
            individualKey,
            DATA[individualKey]['name'],
          );
          list.add(locationModel);

        }
      }
    });

    return list;
  }

  Future<void> _showCountryDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('country'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                FutureBuilder<List<LocationModel>>(
                  future: getCountryList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedCountryName=snapshot.data[index].name;
                                    selectedCountryId=snapshot.data[index].id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text('noData'.tr())
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
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _showCityDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('city'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                FutureBuilder<List<LocationModel>>(
                  future: getCityList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedCityName=snapshot.data[index].name;
                                    selectedCityId=snapshot.data[index].id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text('noData'.tr())
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
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _showAreaDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('area'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                FutureBuilder<List<LocationModel>>(
                  future: getAreaList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedAreaName=snapshot.data[index].name;
                                    selectedAreaId=snapshot.data[index].id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text('noData'.tr())
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
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _showTypeDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('propertyType'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                FutureBuilder<List<LocationModel>>(
                  future: getTypeList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedTypeName=snapshot.data[index].name;
                                    selectedTypeId=snapshot.data[index].id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text('noData'.tr())
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
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  bool isLoaded=false;
  rentOrBuy _rentOrBuy = rentOrBuy.rent;
  bool isRent=true;
  bool sortOpened=false;
  bool filterOpened=false;
  bool isAccessding=false;
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
  List<Property> list=[];
  List<Property> sponsor=[];
  getPropertyList() async {

    final databaseReference = FirebaseDatabase.instance.reference();
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
              DATA[individualKey]['numericalPrice'],
              DATA[individualKey]['payment'],
              DATA[individualKey]['furnish'],
            DATA[individualKey]['agentName'],
            DATA[individualKey]['sponsered'],
            DATA[individualKey]['floor'],
            DATA[individualKey]['serial'],
          );

          if(property.country==widget.country && property.city==widget.city && property.area==widget.area && property.typeOfProperty==widget.type){
            if(widget.isRent && property.propertyCategory=="rent"){
              if(property.sponsered){
                sponsor.add(property);
              }
              else{
                setState(() {
                  list.add(property);
                });
              }


            }
            if(!widget.isRent && property.propertyCategory=="buy"){
              if(property.sponsered){
                sponsor.add(property);
              }
              else{
                setState(() {
                  list.add(property);
                });
              }
            }
          }


        }
        list = new List.from(sponsor)..addAll(list);
      }
    });
    setState(() {
      isLoaded=true;
    });
  }

  getSortedPropertyList() {
    setState(() {
      if(isAccessding){
        list.sort((a, b) => a.numericalPrice.compareTo(b.numericalPrice));
      }
      else{

      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Stack(
            children: [
              Column(
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
                        Container(
                          alignment: Alignment.center,
                          child: Text('propertyList'.tr(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              sortOpened=false;
                              filterOpened=true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text('filter'.tr(),style: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w500),),
                                SizedBox(width: 5,),
                                Image.asset("assets/images/filter.png",width: 20,height: 20,color: primaryColor,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: (){
                            setState(() {
                              sortOpened=true;
                              filterOpened=false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text('sort'.tr(),style: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w500),),
                                SizedBox(width: 5,),
                                Image.asset("assets/images/sort.png",width: 20,height: 20,color: primaryColor,)
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                    margin: EdgeInsets.only(top: 10,right: 10,left: 10),
                  ),
                  isLoaded?
                  list.length>0?Container(
                    margin: EdgeInsets.all(10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context,int index){
                        return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (BuildContext context) => PropertyDetail(list[index])));
                            },
                            child: PropertyTile(list[index])
                        );
                      },
                    ),
                  ):Container(margin: EdgeInsets.only(top: 200),child: Text('noData'.tr()),)
                      :Center(child: CircularProgressIndicator(),)

                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  height: sortOpened?180:0,
                  width: MediaQuery.of(context).size.width,
                  duration: const Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    )
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text('sortBy'.tr(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
                      ),
                      Container(
                          child: ListTile(
                            onTap: (){
                              setState(() {
                                list.sort((a, b) => a.numericalPrice.compareTo(b.numericalPrice));
                                sortOpened=false;
                              });

                            },
                            leading: Icon(Icons.arrow_upward,color: Colors.black,),
                            title: Text('LowToHigh'.tr(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: Colors.black),),

                          )
                      ),
                      Container(

                          child: ListTile(
                            onTap: (){
                              setState(() {
                                list.sort((a, b) => a.numericalPrice.compareTo(b.numericalPrice));
                                list=list.reversed.toList();
                                sortOpened=false;
                              });
                            },
                            leading: Icon(Icons.arrow_downward,color: Colors.black,),
                            title: Text('HighToLow'.tr(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: Colors.black),),

                          )
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  height: filterOpened?MediaQuery.of(context).size.height*0.6:0,
                  width: MediaQuery.of(context).size.width,
                  duration: const Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      )
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text('filter'.tr(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Radio(
                            value: rentOrBuy.rent,
                            groupValue: _rentOrBuy,
                            onChanged: (rentOrBuy value) {
                              setState(() {
                                isRent = true;
                                _rentOrBuy = value;
                              });
                            },
                          ),
                          new Text(
                            'rent'.tr(),
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          new Radio(
                            value: rentOrBuy.buy,
                            groupValue: _rentOrBuy,
                            onChanged: (rentOrBuy value) {
                              setState(() {
                                isRent = false;
                                _rentOrBuy = value;
                              });
                            },
                          ),
                          new Text(
                            'buy'.tr(),
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        onTap: ()=>_showCountryDailog(),
                        leading: Image.asset("assets/images/country.png",width: 30,height: 30,),
                        title: Text(selectedCountryName,style: TextStyle(color: Colors.grey[600]),),
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        onTap: (){
                          if(selectedCountryId!=null){
                            _showCityDailog();
                          }
                          else{
                            Toast.show("Please select above", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }
                        },
                        leading: Image.asset("assets/images/city.png",width: 30,height: 30,),
                        title: Text(selectedCityName,style: TextStyle(color: Colors.grey[600]),),
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        onTap: (){
                          if(selectedCountryId!=null && selectedCityId!=null){
                            _showAreaDailog();
                          }
                          else{
                            Toast.show("Please select above", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }
                        },
                        leading: Image.asset("assets/images/area.png",width: 30,height: 30,),
                        title: Text(selectedAreaName,style: TextStyle(color: Colors.grey[600]),),
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        onTap: ()=>_showTypeDailog(),
                        leading: Image.asset("assets/images/home.png",width: 30,height: 30,),
                        title: Text(selectedTypeName,style: TextStyle(color: Colors.grey[600]),),
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            widget.country=selectedCountryName;
                            widget.city=selectedCityName;
                            widget.area=selectedAreaName;
                            widget.type=selectedTypeName;
                            widget.isRent=isRent;
                            list.clear();
                            filterOpened=false;
                          });
                          getPropertyList();

                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                stops: [
                                  0.4,
                                  0.6,
                                ],
                                colors: [
                                  Color(0xff307bd6),
                                  Color(0xff2895fa),
                                ],
                              )
                          ),
                          child: Text('findProperty'.tr(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),),
                        ),
                      )
                    ],
                  ),
                ),
              )

            ],
          )
        )

    );
  }
}
