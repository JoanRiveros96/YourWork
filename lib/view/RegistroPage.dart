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
  final TextEditingController nombreController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController contrasenaController = new TextEditingController();
  final TextEditingController confContrasenaController = new TextEditingController();

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
            textSection(),
            signupSection()



          ],
        ),
      ),

    );
  }

  signup(String nombre, email, contrasena) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data={
      'nombre': nombre,
      'cc': '0000',
      'Avatar': 'empty',
      'ubicacion': 'empty',
      'celular': '0000',
      'email': email,
      'password': contrasena,
      'nacimiento': '01/01/2020'
    };

    var jsonResponse;

    var response = await http.post("http://192.168.1.6:3000/signup", body: data );
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

  Container signupSection(){
    var signupButton = RaisedButton(
      onPressed: nombreController.text =="" || emailController.text == "" || contrasenaController.text == "" || confContrasenaController.text =="" ? null:() {

          setState(() {
            _isLoading = true;
          });
          if(contrasenaController.text == confContrasenaController.text) {
            signup(nombreController.text, emailController.text,confContrasenaController.text);
          }
      },
      elevation: 0.0,
      color: Colors.blue,
      child: Text("Registrate",style: TextStyle(color:  Colors.white70)),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal:15),
      margin: EdgeInsets.only(top: 15),
      child: signupButton,


    );
  }

Container heardSection(){
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Encuentra el servicio que estas buscando",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white70,

              fontSize: 30.0,
              fontWeight: FontWeight.bold
          )),
    );
  }

  Container textSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical:20.0),
      child: Column(children: <Widget>[
        TextField(
          controller: nombreController,
          cursorColor: Colors.white,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.white70),
              hintText: "Nombre completo",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 30.0,),
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
          controller: contrasenaController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.lock_open, color: Colors.white70),
              hintText: "Contraseña",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 30.0,),
        TextField(
          controller: confContrasenaController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Confirma tu Contraseña",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
      ],
      ),
    );
  }
}