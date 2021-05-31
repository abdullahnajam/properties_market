import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/admin/admin_home.dart';
import 'package:propertymarket/auth/login.dart';
import 'package:propertymarket/screens/home.dart';
import 'package:propertymarket/values/constants.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5;
  User user;

  getCurrentUser()async{
    user=await FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _loadWidget();
  }
  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }
  void navigationPage() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Login()));
      } else {
        if(user=="dShLOfPfm8bbAC9AeSdAShxOuRP2"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AdminHome()));
        }
        else
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));

      }
    });


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png',width: 350,height: 350,),
            ],
          )),

      ),
    );
  }
}

