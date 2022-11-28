import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:karaoke_real_one/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:karaoke_real_one/Screen-login/LoginPage.dart';
import 'package:karaoke_real_one/root_app.dart';
import 'package:karaoke_real_one/fb_connect.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _HomePage();
}

class _HomePage extends State<MyApp> {
  List userData = [];
  List usersRanking = [];
  List listSongs = [];

  Future loaduser(String userUID) async {
    List tempData = await fb_connect().loadUser(userUID);
    return tempData;
  }

  Future loadRanking() async {
    List tempData = await fb_connect().loadRanking();
    return tempData;
  }

  Future loadSongs() async{
    List tempData = await fb_connect().getSongList();
    return tempData;
  }

  Future fetchingSongList(String userName) async {
    List tempData = await fb_connect().fetchingSongList(userName);
    return tempData;
  }

  Future<bool> allFunction(String userUID) async {
    listSongs = await loadSongs();
    userData = await loaduser(userUID);
    usersRanking = await loadRanking();
    userData[0]['songs'] = await fetchingSongList(userData[0]['userName']);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black, dividerColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }

  Widget Home() {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      return myMainBody(user.uid);
    }else{
      return LoginPage();
    }
  }

  Widget myMainBody(String userUID) {
    return FutureBuilder(
      future: allFunction(userUID),
      builder:(context, snapshot){
        if(snapshot.connectionState != ConnectionState.done){
          return loadScreen();
        }
        return RootApp(userData: userData, rankingData: usersRanking, appSongs: listSongs);
      }, 
    );
  }

  Widget loadScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Color.fromARGB(255, 0, 255, 8),
          size: 200,
        ),
      ),
    );
  }
}
