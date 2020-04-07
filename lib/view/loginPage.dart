import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:work/main.dart';
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {


  bool _isLoading = false;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();




  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor:Colors.transparent));
    return Scaffold(
      body: Container(
        decoration:BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),

        child: _isLoading ? Center(child: CircularProgressIndicator()):ListView(
          children: <Widget>[
            heardSection(),
            textSection(),
            buttonSection(),


          ],
        ),
      ),

    );
  }

  signin(String email, pass) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data={
      'email': email,
      'password': pass,
    };

    var jsonResponse;

    var response = await http.post("http://192.168.1.8:3000/signin", body: data );
    if(response.statusCode==200){
      jsonResponse = json.decode(response.body);

      if(jsonResponse != null){
        setState(() {
          _isLoading =false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>MainPage()), (Route<dynamic> route )=> false);
      }
    }
    else{
      setState(() {
        _isLoading=false;
      });
      print(response.body);
    }
  }

  Container buttonSection(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal:15),
      margin: EdgeInsets.only(top: 15),
      child: RaisedButton(
        onPressed: emailController.text =="" || passwordController.text == "" ? null:(){
          setState(() {
            _isLoading = true;
          });
          signin(emailController.text, passwordController.text);
        },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Signin",style: TextStyle(color:  Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      
    );
  }

  
  Container textSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical:20.0),
      child: Column(children: <Widget>[
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 30.0,),
        TextField(
          controller: passwordController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
      ],
      ),
    );
  }


  Container heardSection(){
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("YourWork App",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold
          )),
    );
  }

}

