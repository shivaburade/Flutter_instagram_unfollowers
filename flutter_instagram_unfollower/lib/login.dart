import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_unfollowers/home.dart';
import 'package:instagram_unfollowers/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var isEnabled = false;
  String url = "http://192.168.29.17:5000/";
  
  var uname = TextEditingController();

  var pass = TextEditingController();

  void do_login(){

  var reqBody = Map<String, dynamic>();
  reqBody["username"] = uname.text;
  reqBody["password"] = pass.text;
  http.post(url+"login", body: reqBody).then((value) {
    
    //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
     var obj = json.decode(value.body);
     print(obj);
     if(obj['Code'] == 400){
       print('error');
     }else{
       sp.setString("UID", obj['ID']);
       print(sp.getString("UID"));
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Home(sp.getString("UID"))));
     }
  });

  }

  void on_change(){
    if(uname.text.isNotEmpty && pass.text.length > 7)
      setState(() {
        isEnabled = true;
      });
      else
        setState(() {
        isEnabled = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    uname.addListener(on_change);
    pass.addListener(on_change);


    return Scaffold(
        body: Container(

          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(margin: EdgeInsets.only(bottom: 30), child: Text("Instagram", style: TextStyle(fontFamily: "Billabong", fontSize: 60),)),
            Container(margin: EdgeInsets.only(bottom: 10), child: TextField(controller: uname, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))), contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0), hintText: "Username",))),
            Container(margin: EdgeInsets.only(bottom: 10), child: TextField(controller: pass, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))), contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0), hintText: "Password"), obscureText: true,)),
            
            Container(width: MediaQuery.of(context).size.width, child: RaisedButton( onPressed: isEnabled ? do_login:null, child: Text("Log In"),  color: Colors.deepPurple, textColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), ))
        ],)
      ,),
    );
  }
}