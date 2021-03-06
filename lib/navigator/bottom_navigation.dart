import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/auth/login.dart';
import 'package:propertymarket/model/info.dart';
import 'package:propertymarket/screens/favourites.dart';
import 'package:propertymarket/screens/home.dart';
import 'package:propertymarket/screens/news.dart';
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
      Navigator.push(
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
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) => BottomBar()));
                  },
                  title: Text('arabic'.tr()),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('en', 'US');
                    SharedPref sharedPref=new SharedPref();
                    sharedPref.setPref(true);
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) => BottomBar()));
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
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();


    _children = [
      HomePage(),
      News(),
      Container(),
      Container(),
      Container(),
      FavouriteList(),


    ];
    Admob.requestTrackingAuthorization();
    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: androidInterstitialVideo,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    interstitialAd.load();

  }
  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType Ad failed!');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                print("snack bar popped");
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void onTabTapped(int index) async{
    if(index==0){
      if (await interstitialAd.isLoaded) {
        interstitialAd.show();
        setState(() {
          _currentIndex = index;
        });
      }
      else {
        setState(() {
          _currentIndex = index;
        });
      }

    }
    if(index==1){
      if (await interstitialAd.isLoaded) {
        interstitialAd.show();
        setState(() {
          _currentIndex = index;
        });
      }
      else {
        setState(() {
          _currentIndex = index;
        });

      }
    }
    else if(index==2){
      _showChangeLanguageDailog();
    }
    else if(index==3){
      _showInfoDailog();
    }

    else if(index==4){
      logout();
    }
    else if(index==5){
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
              label: 'search'.tr()
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.assignment_outlined),
              label: 'news'.tr()
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.language_outlined),
              label: 'language'.tr()
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'add'.tr()
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key_outlined),
              label: FirebaseAuth.instance.currentUser==null?'login'.tr():'logout'.tr()
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'favourite'.tr()
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
