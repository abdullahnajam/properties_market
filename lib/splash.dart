import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/admin/admin_home.dart';
import 'package:propertymarket/admin/admin_search_list.dart';
import 'package:propertymarket/auth/login.dart';
import 'package:propertymarket/language_selection.dart';
import 'package:propertymarket/navigator/bottom_navigation.dart';
import 'package:propertymarket/screens/home.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:propertymarket/values/shared_prefs.dart';
import 'package:video_player/video_player.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 4;
  User user;

  getCurrentUser()async{
    user=await FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init(
        testingId: "97294348-249f-4530-b841-55eed93b02f0"
    );
    //_controller = VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _controller = VideoPlayerController.asset("assets/video/intro.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _loadWidget();
    //_controller.setLooping(true);
    getCurrentUser();
  }
  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }
  void navigationPage() {
    _controller.pause();
    SharedPref sharedPref=SharedPref();
    sharedPref.getFirstTimePref().then((value) => {
      if(value){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LanguageSelection()))
      }
      else{
        FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
      } else {
        if(user.uid==adminId){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AdminSearchList()));
        }
        else
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));

      }
    })
      }
    });




  }
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _controller.play();
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                );
              } else {
                return Container(
                  color: primaryColor,
                  //child: CircularProgressIndicator(),
                );
              }
            },
          ),

      ),
    );
  }
}

