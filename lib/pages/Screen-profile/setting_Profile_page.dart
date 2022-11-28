import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/Screen-login/LoginPage.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SettingProfilePage extends StatefulWidget {
  @override
  _SettingProfilePageState createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
    Timer(Duration(seconds: 1), () {
      _btnController.error();
      Timer(Duration(seconds: 1), () {
        _btnController.reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Setting",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 1000),
              bulidSignoutBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bulidSignoutBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RoundedLoadingButton(
        color: Colors.redAccent,
        controller: _btnController,
        onPressed: signOut,
        child: Text(
          'LOGOUT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
