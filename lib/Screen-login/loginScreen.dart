import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karaoke_real_one/main.dart';
import '/Screen-login/registerScreen.dart';
import '/Screen-login/resetScreen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:karaoke_real_one/fb_connect.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List userData = [];
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Future loaduser(String userUID) async {
    List tempData = await fb_connect().loadUser(userUID);
    setState(() {
      userData = tempData;
    });
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .then((value) {
        Timer(Duration(seconds: 1), () {
          _btnController.reset();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MyApp();
          }));
        });
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            Timer(Duration(seconds: 1), () {
              _btnController.error();
              Timer(Duration(seconds: 1), () {
                _btnController.reset();
              });
            });
            return AlertDialog(
                content: Stack(children: [
              Text('Please complete the information, OR'),
              Text('\nIf you not a member, Please register!'),
            ]));
          });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
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
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.lock, color: Color(0xff999999)),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black38)),
            )),
      ],
    );
  }

  Widget buildForgotPassBtn() {
    return Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ResetPasswordScreen();
                },
              ),
            );
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
                color: Colors.blueAccent, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget bulidLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RoundedLoadingButton(
        color: Colors.green,
        controller: _btnController,
        onPressed: signIn,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildRegisterBtn() {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegisterScreen();
          }));
        },
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: 'Don\'t have an Account?',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: '  Register now !',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))
        ])));
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
                        'Sign In',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 255, 8),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 70),
                      buildEmail(),
                      SizedBox(height: 10),
                      buildPassword(),
                      buildForgotPassBtn(),
                      SizedBox(height: 25),
                      bulidLoginBtn(),
                      buildRegisterBtn(),
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
