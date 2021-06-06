import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/admin/add_country.dart';
import 'package:propertymarket/admin/admin_home.dart';
import 'package:propertymarket/admin/admin_property_type.dart';
import 'package:propertymarket/admin/my_info.dart';
import 'package:propertymarket/admin/slideshow.dart';
import 'package:propertymarket/auth/login.dart';
import 'package:propertymarket/data/my_colors.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:propertymarket/widget/my_text.dart';
import 'package:toast/toast.dart';
class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final _controller=TextEditingController();
  Future<void> _changePasswordDailog() async {
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
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Change Password",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText:"Enter New Password",contentPadding: EdgeInsets.only(left: 10)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      color: primaryColor,
                      onPressed: (){
                        if(_controller.text!=""){
                          final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                          User currentUser = firebaseAuth.currentUser;
                          currentUser.updatePassword(_controller.text).whenComplete((){
                            Toast.show("Successfully Changed", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                            Navigator.pop(context);
                          }).catchError((onError){
                            Toast.show(onError.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

                          });
                        }
                        else{
                          Toast.show("Enter Value", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

                        }
                      },
                      child: Text("Change Password",style: TextStyle(color: Colors.white),),
                    )
                ),
                SizedBox(height: 15,),
              ],
            ),
          ),
        );
      },
    );
  }
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (BuildContext context) => AddCountry()));
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
                  context, MaterialPageRoute(builder: (BuildContext context) => MyInfo()));
            },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.contact_mail_outlined, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Update Contact", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
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
          InkWell(onTap: (){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (BuildContext context) => ViewPropertyType()));
          },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.category_outlined, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Type", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),

          Container(height: 10),
          InkWell(
            onTap: (){
              _changePasswordDailog();
            },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.vpn_key_outlined, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Change password", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
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
