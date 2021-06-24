import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:propertymarket/model/news_model.dart';
class NewsDetails extends StatefulWidget {
  NewsModel news;
  bool language;

  NewsDetails(this.news,this.language);

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
              ),

            ),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text('newsDetail'.tr(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),

              ],
            ),
          ),

          Container(
            height: 200,
            child: CachedNetworkImage(
              imageUrl: widget.news.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),

          ),
          SizedBox(height: 10,),
          Text(widget.language?widget.news.details:widget.news.details_ar)

        ],
      ),
    );
  }
}
