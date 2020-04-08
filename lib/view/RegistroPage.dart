import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:work/main.dart';

class RegistroPage extends StatefulWidget{
  @override
  _RegistroPageState createState() => _RegistroPageState();

}

class _RegistroPageState extends State<RegistroPage> {

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor:Colors.transparent));
    return Scaffold(
      body: Container(
        decoration:BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),

        child: _isLoading ? Center(child: CircularProgressIndicator()):ListView(
          children: <Widget>[
            heardSection(),
            //textSection(),
            //buttonSection(),
            //signupSection(),


          ],
        ),
      ),

    );
  }

Container heardSection(){
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("BIENVENIDO A NUESTRA APP",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold
          )),
    );
  }
}