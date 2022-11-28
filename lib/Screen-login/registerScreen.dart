import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:firebase_database/firebase_database.dart';

import 'loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userAgeController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Future signUp() async {
    try {
      if (passwordConfirmed()) {
        final x = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
            .then((value) {
          Timer(Duration(seconds: 1), () {
            _btnController.success();
            Timer(Duration(seconds: 1), () {
              _btnController.reset();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }));
            });
          });
        });

        final user = FirebaseAuth.instance.currentUser!;

        addUserDetails(
          _emailController.text.trim(),
          _userNameController.text.trim(),
          int.parse(_userAgeController.text.trim()),
          user.uid
        );
      }
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
                Text('\nThis email has been uesed'),
                Text('\n\nPlease try again !'),
              ]),
            );
          });
    }
  }

  // Future addUserDetails(
  //   String userEmail,
  //   String userName,
  //   int userAge,
  // ) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'userEmail': userEmail,
  //     'userName': userName,
  //     'userAge': userAge,
  //   });
  // }

  void addUserDetails(String userEmail, String userName, int userAge, String userUID) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/"+userUID);
    await ref.set({
      "userEmail": userEmail,
      "userName": userName,
      "userAge": userAge,
      "stars": 0,
      "songs_count": 0,
      "rating": 0,
      "img": "https://i.pinimg.com/280x280_RS/2e/45/66/2e4566fd829bcf9eb11ccdb5f252b02f.jpg"
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _userNameController.dispose();
    _userAgeController.dispose();
    super.dispose();
  }

  Widget builduserName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
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
              controller: _userNameController,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.email, color: Color(0xff999999)),
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.black38)),
            )),
      ],
    );
  }

  Widget builduserAge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Age',
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
              controller: _userAgeController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.email, color: Color(0xff999999)),
                  hintText: 'Age',
                  hintStyle: TextStyle(color: Colors.black38)),
            )),
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

  Widget buildCPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
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
              controller: _confirmpasswordController,
              obscureText: true,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.lock, color: Color(0xff999999)),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(color: Colors.black38)),
            )),
      ],
    );
  }

  Widget bulidRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RoundedLoadingButton(
        onPressed: signUp,
        color: Colors.green,
        controller: _btnController,
        child: Text(
          'REGISTER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildSingInBtn() {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));
        },
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: 'I\'m a member !',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: '  Login now !',
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
                        'Sign Up',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 255, 8),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      builduserName(),
                      SizedBox(height: 10),
                      builduserAge(),
                      SizedBox(height: 10),
                      buildEmail(),
                      SizedBox(height: 10),
                      buildPassword(),
                      SizedBox(height: 10),
                      buildCPassword(),
                      SizedBox(height: 25),
                      bulidRegisterBtn(),
                      buildSingInBtn(),
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
