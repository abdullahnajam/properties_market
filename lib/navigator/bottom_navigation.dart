import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/auth/login.dart';
import 'package:propertymarket/model/info.dart';
import 'package:propertymarket/screens/favourites.dart';
import 'package:propertymarket/screens/home.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:propertymarket/values/shared_prefs.dart';

class BottomBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomBar>{

  int _currentIndex = 0;

  List<Widget> _children=[];
  Future<MyInformation> getSlideList() async {
    MyInformation _myInfo;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("info").once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        _myInfo = new MyInformation(
          dataSnapshot.value['email'],
          dataSnapshot.value['phone'],
        );

      }
    });
    return _myInfo;
  }
  logout()async{
    await FirebaseAuth.instance.signOut().whenComplete((){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => Login()));
    });
  }
  _showInfoDailog() async {
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
                  child: Text("Contact Information",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                FutureBuilder<MyInformation>(
                  future: getSlideList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return Column(
                          children: [
                            Container(
                                child: ListTile(
                                  leading: Icon(Icons.phone),
                                  title: Text(snapshot.data.phone),
                                )
                            ),
                            Divider(color: Colors.grey,),
                            Container(
                                child: ListTile(
                                  leading: Icon(Icons.email),
                                  title: Text(snapshot.data.email),
                                )
                            ),
                          ],
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

  _showChangeLanguageDailog() async {
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
                  child: Text('changeLanguage'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('ar', 'EG');
                    SharedPref sharedPref=new SharedPref();
                    sharedPref.setPref(false);
                    Navigator.pop(context);
                  },
                  title: Text('arabic'.tr()),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('en', 'US');
                    SharedPref sharedPref=new SharedPref();
                    sharedPref.setPref(true);
                    Navigator.pop(context);
                  },
                  title: Text("English"),
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

  @override
  void initState() {
    super.initState();
    _children = [
      HomePage(),
      Container(),
      Container(),
      Container(),
      FavouriteList(),


    ];
  }

  void onTabTapped(int index) {
    if(index==0){
      setState(() {
        _currentIndex = index;
      });
    }
    else if(index==1){
      _showChangeLanguageDailog();
    }
    else if(index==2){
      _showInfoDailog();
    }

    else if(index==3){
      logout();
    }
    else if(index==4){
      User user=FirebaseAuth.instance.currentUser;
      if(user==null){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
      }
      else{
        setState(() {
          _currentIndex = index;
        });
      }

    }


  }




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor:Color(0xffabc6ff),
        selectedItemColor: primaryColor,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            label: "Search"
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.language_outlined),
              label: "Language"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Add"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key_outlined),
              label: "Logout"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: "Favourite"
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
