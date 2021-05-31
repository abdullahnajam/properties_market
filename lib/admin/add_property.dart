import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propertymarket/model/location.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:toast/toast.dart';

enum rentOrBuy { rent, buy }
class AddProperty extends StatefulWidget {
  @override
  _AddPropertyState createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  rentOrBuy _rentOrBuy = rentOrBuy.rent;
  bool isRent=true;
  final priceController=TextEditingController();
  final wordPriceController=TextEditingController();
  final bedController=TextEditingController();
  final bathController=TextEditingController();
  final areaSqrftController=TextEditingController();
  final phoneController=TextEditingController();
  final emailController=TextEditingController();
  final countryController=TextEditingController();
  final cityController=TextEditingController();
  final areaController=TextEditingController();
  final typeController=TextEditingController();
  final descriptionController=TextEditingController();

  String selectedCountryId="";
  String selectedCityId="";
  String selectedAreaId="";
  String selectedTypeId="";

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
                  child: Text("Countries",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
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
                                    countryController.text=snapshot.data[index].name;
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
                              child: Text("No data found")
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
                  child: Text("City",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
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
                                    cityController.text=snapshot.data[index].name;
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
                              child: Text("No data found")
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
                  child: Text("Area",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
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
                                    areaController.text=snapshot.data[index].name;
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
                              child: Text("No data found")
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
                  child: Text("Property Type",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
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
                                    typeController.text=snapshot.data[index].name;
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
                              child: Text("No data found")
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

  String photoUrl="";

  submitData(){
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child("property").push().set({
      'price': wordPriceController.text,
      'numericalPrice': priceController.text,
      'beds': bedController.text,
      'bath': bathController.text,
      'call': phoneController.text,
      'city': cityController.text,
      'country': countryController.text,
      'datePosted': DateTime.now().toString(),
      'description': descriptionController.text,
      'email': emailController.text,
      'image': photoUrl,
      'location': "${areaController.text}, ${cityController.text}, ${countryController.text}",
      'measurementArea': areaSqrftController.text,
      'area': areaController.text,
      'typeOfProperty': typeController.text,
      'propertyCategory': isRent?"rent":"buy",
      'whatsapp': phoneController.text,

    }).then((value) {
      Toast.show("Submitted", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);


    }).catchError((onError){
      Toast.show(onError.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    });
  }

  File imagefile;
  void fileSet(File file){
    setState(() {
      if(file!=null){
        imagefile=file;
      }
    });
  }
  Future<File> _chooseGallery() async{
    await ImagePicker.pickImage(source: ImageSource.gallery).then((value) => fileSet(value));

  }
  Future<File> _choosecamera() async{
    await ImagePicker.pickImage(source: ImageSource.camera).then((value) => fileSet(value));

  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _chooseGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _choosecamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = imagefile.path;
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imagefile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) {
            photoUrl=value;
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          imagefile==null?
          Container(
            width: double.infinity,
            height: 180,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: (){
                _showPicker(context);
              },
              child: Image.asset("assets/images/add.png",width: 50,height: 50,),
            )
          ):
          GestureDetector(
            onTap: ()=>_showPicker(context),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imagefile),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
          Table(
            columnWidths: {0: FractionColumnWidth(.3), 1: FractionColumnWidth(.7)},
            border: TableBorder.all(width: 0.5,color: Colors.grey),
            children: [
              TableRow(
                  children: [
                Container(
                  child: Text('Price',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5),
                ),
                Container(
                  child: TextField(
                    maxLines: 1,
                    controller: wordPriceController,
                    decoration: InputDecoration(hintText:"Price in words",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                  ),
                ),
              ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Price',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        controller:priceController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(hintText:"Price in Digits",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Beds',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        controller: bedController,
                        decoration: InputDecoration(hintText:"0",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Baths',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 1,
                        controller: bathController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText:"0",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Area',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 1,
                        controller: areaSqrftController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText:"In square feet",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Description',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 3,
                        controller: descriptionController,
                        decoration: InputDecoration(hintText:"Property Description",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),

              TableRow(
                  children: [
                    Container(
                      child: Text('Phone Number',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 1,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(hintText:"Enter Phone Number",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Email',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 1,
                        controller: emailController,
                        decoration: InputDecoration(hintText:"Enter Email",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Country',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 1,
                        controller: countryController,
                        readOnly: true,
                        onTap: (){
                          _showCountryDailog();
                        },
                        decoration: InputDecoration(hintText:"Enter Country",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('City',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 1,
                        controller: cityController,
                        readOnly: true,
                        onTap: (){
                          _showCityDailog();
                        },
                        decoration: InputDecoration(hintText:"Enter City",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Area',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 1,
                        controller: areaController,
                        readOnly: true,
                        onTap: (){
                          _showAreaDailog();
                        },
                        decoration: InputDecoration(hintText:"Enter Area",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),
              TableRow(
                  children: [
                    Container(
                      child: Text('Property Type',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: TextField(
                        maxLines: 1,
                        readOnly: true,
                        controller: typeController,
                        onTap: (){
                          _showTypeDailog();
                        },
                        decoration: InputDecoration(hintText:"Enter Property Type",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                      ),
                    ),
                  ]),




            ],
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
                'Rent',
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
                'Buy',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              onPressed: (){
                submitData();

              },
              color: primaryColor,
              child: Text("Add Property",style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}
