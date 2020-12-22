import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:instagram_unfollowers/models/Instagram_util.dart';



class Unfollowers extends StatefulWidget{
String uid;
Instagram ig;
Unfollowers(this.uid, this.ig){}

  @override
  _UnfollowersState createState() => _UnfollowersState();
}

class _UnfollowersState extends State<Unfollowers> {
  var igData;
  var _isloading = false;
  var localData;
ScrollController controller;

  Widget buildList(snapshot){

    return ListView.builder(
              controller: controller,
              itemCount: snapshot.data.length,
              itemBuilder: (context, position){
               
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(snapshot.data[position].profilePicUrl),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(snapshot.data[position].username),
                    trailing: Switch(value: snapshot.data[position].following, onChanged: (state){
                      //print(state);
                       print(snapshot.data[position].username +'following:' + snapshot.data[position].userId);
                       this.widget.ig.unfollow(this.widget.uid, snapshot.data[position].userId).then((value) => print(value));
                       
                      setState(() {
                        snapshot.data[position].following = state;
                      });
                    }),
                    onTap: (){
                      var url = 'https://www.instagram.com/'+snapshot.data[position].username;
                      this.widget.ig.openProfile(url);              
                    },
                ),
                  ));
              },
              );

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    igData = this.widget.ig.getUnfollowers();
    controller = new ScrollController();
    controller.addListener(() {

      if(controller.position.pixels == controller.position.maxScrollExtent){
        print('new data to be loaded');

         setState(() {
          _isloading = true;
          igData = this.widget.ig.getUnfollowers();
          });
        Timer(Duration(seconds: 2), (){
          setState(() {
             _isloading = false;
          });
        });
      }

    });
  }


  Widget buildFuture(){

  return FutureBuilder<List<User>>(
        future: igData, 
        builder: (context, snapshot){
          
            if(snapshot.hasError)
            {
              print(snapshot.error);
              if(localData == null)
                return Text("There is some error fetching data");
              else
                return buildList(localData);
            }
            
            if(snapshot.hasData){
              localData = snapshot;
              return buildList(snapshot);
            }else{
              
              return Center(child: CircularProgressIndicator());
            }
        },
      );
  }

Widget buildLoader(){
  return _isloading ? Align(
            child: new Container(
              width: 70.0,
              height: 70.0,
              child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Center(child: new CircularProgressIndicator())),
            ),
            alignment: FractionalOffset.bottomCenter,
          ) : new SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  
     return Stack(
          children: <Widget>[
      buildFuture(),
      buildLoader(),
          ]
      );
  }
}

