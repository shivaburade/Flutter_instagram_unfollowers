import 'package:flutter/material.dart';
import 'package:instagram_unfollowers/models/Instagram_util.dart';
import 'package:instagram_unfollowers/unfollowers.dart';
import 'package:instagram_unfollowers/fans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget{

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String uid;
  Instagram ig;
  Home(this.uid){
    ig = Instagram(uid);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  DefaultTabController(
          length: 2,
          child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.reorder), onPressed: (){}),
              IconButton(icon: Icon(Icons.account_circle), onPressed: (){},)
            ],
          ),
          bottom: TabBar(tabs: [
                  Tab(text: "Unfollowers",),
                  Tab(text: "Fans")
                ],),
        ),
        body: TabBarView(children: [
          Unfollowers(uid, ig),
          Fans(uid, ig)
        ]),
      ),
    );
  }
  
}