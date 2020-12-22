import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class User {
  String userId;
  String link;
  String username;
  String profilePicUrl;
  bool following;
  User({this.userId, this.username, this.profilePicUrl, this.following}){
    link = "https://instagram.com/"+this.username;
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['ID'].toString(),
      username: json['username'] as String,
      profilePicUrl: json['profile_pic_url'] as String,
      following: json["following"] as bool
    );
  }
}

class Instagram{

String uid;
String url = "http://192.168.29.17:5000/";
Instagram(this.uid);
List<User> unfollowers;
int totalUnfollowers;
List<User> fans;
int totalFans;

List<User> parsePosts(String responseBody){
    final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

void _setTotalUnfollowers(String responseBody){
  totalUnfollowers = json.decode(responseBody)['total_keys'];
  print("Total Unfollowers" + totalUnfollowers.toString());
}
void _setTotalFans(String responseBody){
  totalFans = json.decode(responseBody)['total_keys'];
  print("Total Unfollowers" + totalUnfollowers.toString());
}
Future<List<User>> getUnfollowers() async {
    if(unfollowers != null && unfollowers.length == totalUnfollowers){
      print("Unfollowers Length: " + unfollowers.length.toString());
      return unfollowers;
    }
    var reqBody = Map<String, dynamic>();
    reqBody["ID"] = uid;
    reqBody["max_keys"] = unfollowers == null ? "0" : unfollowers.length.toString();
    var response = await http.post(url+"unfollowers", body: reqBody);
    print(response.statusCode);
    if(unfollowers == null)
      unfollowers = parsePosts(response.body);
    else{
      _setTotalUnfollowers(response.body);
      unfollowers.addAll(parsePosts(response.body));
      print("Unfollowers Length: " + unfollowers.length.toString());
    }
    
    return unfollowers;
  }

Future<List<User>> getFans() async {
    if(fans != null && fans.length == totalFans){
      print("Fans Length: " + fans.length.toString());
      return fans;
    }
    
    var reqBody = Map<String, dynamic>();
    reqBody["ID"] = uid;
    reqBody["max_keys"] = fans == null ? "0" : fans.length.toString();;
    var response = await http.post(url+"fans", body: reqBody);
    print(response.statusCode); 
    if(fans == null)
      fans = parsePosts(response.body);
    else{
      _setTotalFans(response.body);
      fans.addAll(parsePosts(response.body));
      print("Fans Length: " + fans.length.toString());
    }
      

    return fans;
  }

Future<void> openProfile(url)
  async {
    print(url);
    if (await canLaunch(url)) {
        await launch(url,universalLinksOnly: true,);
    } else {
        print('There was a problem to open the url: $url');
    }
}

Future<String> unfollow(uid, unfollower_id)
  async {
    var reqBody = Map<String, dynamic>();
    reqBody["ID"] = uid;
    reqBody["UID"] = unfollower_id;
    var response = await http.post(url+"unfollow", body: reqBody);
    return json.decode(response.body)["data"];
}

Future<String> follow(uid, follower_id)
  async {
    var reqBody = Map<String, dynamic>();
    reqBody["ID"] = uid;
    reqBody["UID"] = follower_id;
    var response = await http.post(url+"follow", body: reqBody);
    return json.decode(response.body)["data"];  
}

}

