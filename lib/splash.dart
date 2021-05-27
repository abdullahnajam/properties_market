import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        /*Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));*/
      }
    });
    /*if(user!=null){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
    else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
    }*/

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png',width: 150,height: 150,),
              Text("سکون زندگی میں",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w500,color: Colors.white),)
            ],
          )),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ Color(0xffffb8a6),primaryColor]))),
    );
  }
}

