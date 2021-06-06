import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:propertymarket/model/property.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
class PropertyTile extends StatefulWidget {
  Property property;

  PropertyTile(this.property);

  @override
  _PropertyTileState createState() => _PropertyTileState();
}

class _PropertyTileState extends State<PropertyTile> {




  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.property.image[0],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            )
          ),
          Expanded(
            flex: 7,
            child: Container(
              margin: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(timeAgoSinceDate(widget.property.datePosted),style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300),),
                  SizedBox(height: 10,),
                  widget.property.sponsered?Row(
                    children: [
                      Image.asset("assets/images/sponsor.png",width: 20,height: 20,),
                      SizedBox(width: 10,),
                      Text("Sponsored",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                    ],
                  ):Container(),
                  Text(widget.property.price,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.black),),
                  SizedBox(height: 5,),
                  Text(widget.property.location,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.black),),
                  SizedBox(height: 5,),
                  Text("${'flat'.tr()} ${widget.property.propertyCategory}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                  SizedBox(height: 7,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/bed.png",width: 15,height: 15,),
                          SizedBox(width: 5,),
                          Text(widget.property.beds),
                          SizedBox(width: 5,),
                          Image.asset("assets/images/bath.png",width: 15,height: 15,),
                          SizedBox(width: 5,),
                          Text(widget.property.bath),
                          SizedBox(width: 5,),
                          Image.asset("assets/images/square.png",width: 15,height: 15,),
                          SizedBox(width: 5,),
                          Text("${widget.property.measurementArea} m"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Email",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.white),),
                        ),
                        onTap: (){

                          final Uri _emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: widget.property.email,
                              queryParameters: {
                                'subject': 'Hi there, I am looking to list a property'
                              }
                          );
                          launch(_emailLaunchUri.toString());

                        },
                      ),
                      InkWell(
                        onTap: (){
                          FlutterOpenWhatsapp.sendSingleMessage(widget.property.whatsapp, "Hi there, I am looking to list a property");
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Whatsapp",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.white),),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          launch("tel://${widget.property.whatsapp}");
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Call",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.white),),
                        ),
                      ),



                    ],
                  )

                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
