import 'package:propertymarket/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/data/img.dart';
import 'package:propertymarket/data/my_colors.dart';
import 'package:propertymarket/navigator/bottom_navigation.dart';
import 'package:propertymarket/screens/favourites.dart';
import 'package:propertymarket/screens/home.dart';
import 'package:propertymarket/widget/my_text.dart';
import 'package:easy_localization/easy_localization.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {


  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }

  Future<void> _showInfoDailog() async {
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
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Phone Number"),
                ),
                ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text("Email"),
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

  Future<void> _showChangeLanguageDailog() async {
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
                    Navigator.pop(context);
                  },
                  title: Text('arabic'.tr()),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('en', 'US');
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
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          InkWell(
            onTap: (){
              Navigator.pushReplacement(context, new MaterialPageRoute(
                  builder: (context) => BottomBar()));
            },
            child: Container(
              alignment: Alignment.center,
              child: Image.asset('icon'.tr(),height: 150,),
            ),
          ),
          SizedBox(height: 30,),
          InkWell(
            onTap: (){
            Navigator.pushReplacement(context, new MaterialPageRoute(
                  builder: (context) => FavouriteList()));
            },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.favorite_border, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text('favourite'.tr(), style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),
          Container(height: 10),
          InkWell(
            onTap: (){
              _showChangeLanguageDailog();
            },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.language, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text('changeLanguage'.tr(), style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),
          Container(height: 10),
          InkWell(onTap: (){
            _showInfoDailog();
          },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.add, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text('addProperty'.tr(), style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
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
                  Expanded(child: Text('logout'.tr(), style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
