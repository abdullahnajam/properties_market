import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/admin/admin_home.dart';
import 'package:propertymarket/admin/slideshow.dart';
import 'package:propertymarket/auth/login.dart';
import 'package:propertymarket/data/my_colors.dart';
import 'package:propertymarket/widget/my_text.dart';
class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          Container(
            alignment: Alignment.center,
            child: Image.asset("assets/images/logo_english.jpeg",height: 150,),
          ),
          SizedBox(height: 30,),
          InkWell(
            onTap: (){

            },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.place_outlined, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Location", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),
          Container(height: 10),
          InkWell(
            onTap: (){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (BuildContext context) => AdminHome()));
            },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.home_outlined, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Property", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),
          Container(height: 10),
          InkWell(onTap: (){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (BuildContext context) => AddSlideShow()));
          },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.image_outlined, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Slideshow", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),

          Container(height: 10),
          InkWell(
            onTap: () async{
              await FirebaseAuth.instance.signOut().whenComplete((){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => Login()));
              });
            },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.power_settings_new, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Logout", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
