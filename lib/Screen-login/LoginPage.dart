import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'loginScreen.dart';
import 'registerScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  Future loginPage() async {
    Timer(Duration(seconds: 1), () {
      _btnController1.reset();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
    });
  }

  Future registerPage() async {
    Timer(Duration(seconds: 1), () {
      _btnController2.reset();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RegisterScreen();
      }));
    });
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
                        '\t\tKaraoke Singing\nMobile Application',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 255, 8),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 350),
                      bulidLoginBtn(),
                      bulidRegisterBtn(),
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

  Widget bulidLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RoundedLoadingButton(
        onPressed: loginPage,
        color: Colors.green,
        controller: _btnController1,
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

  Widget bulidRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RoundedLoadingButton(
        valueColor: Colors.white,
        onPressed: registerPage,
        color: Colors.green,
        controller: _btnController2,
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
}
