import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'loginScreen.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // text controllers
  final _emailController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim())
          .then((value) {});
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Stack(children: [
              Text('Password reset link has sent !'),
              Text('\nPlease check your email'),
            ]));
          });
      Timer(Duration(seconds: 1), () {
        _btnController.success();
        Timer(Duration(seconds: 1), () {
          _btnController.reset();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));
        });
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Stack(children: [
              Text('Please complete the information, OR'),
              Text('\nThis email is invalid !'),
            ]));
          });
      Timer(Duration(seconds: 1), () {
        _btnController.error();
        Timer(Duration(seconds: 1), () {
          _btnController.reset();
        });
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget text() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please enter your email',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          '\t\t\t\t\tpassword reset link will',
          style: TextStyle(
              color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '\t\t\t\t\t\t\t\t\t\tsent to your email',
          style: TextStyle(
              color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
              color: Colors.white60, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]),
            height: 50,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.email, color: Color(0xff999999)),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.black38)),
            )),
      ],
    );
  }

  Widget bulidResetBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RoundedLoadingButton(
        color: Colors.green,
        controller: _btnController,
        onPressed: passwordReset,
        child: Text(
          'SEND',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x99000000),
                        Color(0xB3000000),
                        Color(0xcc000000),
                        Color(0xE6000000),
                      ]),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Reset Password',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 255, 8),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 80),
                      text(),
                      SizedBox(height: 30),
                      buildEmail(),
                      SizedBox(height: 30),
                      bulidResetBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
