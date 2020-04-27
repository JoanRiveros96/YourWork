import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';
import 'package:work/main.dart';

class RegistroPage extends StatefulWidget{
  @override
  _RegistroPageState createState() => _RegistroPageState();

}

class _RegistroPageState extends State<RegistroPage> {

  bool _isLoading = false;
  final TextEditingController nombreController = new TextEditingController();
  final TextEditingController cedulaController = new TextEditingController();
  final TextEditingController fotoController = new TextEditingController();
  final TextEditingController ubicacionController = new TextEditingController();
  final TextEditingController celularController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController antecedentesController = new TextEditingController();
  final TextEditingController formPrinController = new TextEditingController();
  final TextEditingController formSecController = new TextEditingController();
  final TextEditingController categoriaController = new TextEditingController();


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
            //signupSection()



          ],
        ),
      ),

    );
  }
  void _Camara(){
    var imagen =  ImagePicker.pickImage(
      source: ImageSource.camera,
    );
  }

  void _Galeria(){
    var imagen =  ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }

  Future<void> _optionsDialogBox() {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: _Camara,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: _Galeria,
                  ),
                ],
              ),
            ),
          );
        });
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

//  Container signupSection(){
//    var signupButton = RaisedButton(
//      onPressed: nombreController.text =="" || emailController.text == "" || contrasenaController.text == "" || confContrasenaController.text =="" ? null:() {
//
//        setState(() {
//          _isLoading = true;
//        });
//        if(contrasenaController.text == confContrasenaController.text) {
//          signup(nombreController.text, emailController.text,confContrasenaController.text);
//        }
//      },
//      elevation: 0.0,
//      color: Colors.blue,
//      child: Text("Registrate",style: TextStyle(color:  Colors.white70)),
//
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//    );
//
//    return Container(
//      width: MediaQuery.of(context).size.width,
//      height: 40,
//      padding: EdgeInsets.symmetric(horizontal:15),
//      margin: EdgeInsets.only(top: 15),
//      child: signupButton,
//
//
//    );
//  }

  Container heardSection(){
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Genera ingresos usando tus habilidades",
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
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical:20.0),
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
        SizedBox(height: 20.0,),
        TextField(
          controller: cedulaController,
          cursorColor: Colors.white,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.perm_identity, color: Colors.white70),
              hintText: "Cedula",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 20.0,),
        TextField(
          controller: fotoController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.add_a_photo, color: Colors.white70),
              hintText: "Foto",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 20.0,),
        TextField(
          controller: ubicacionController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.home, color: Colors.white70),
              hintText: "Ubicacion",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 20.0,),
        TextField(
          controller: celularController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.phone, color: Colors.white70),
              hintText: "Celular",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 20.0,),
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 20.0,),
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: _optionsDialogBox,
                child: Text("Antecedentes"),
              ),
            ),
          ],
        ),
        TextField(
          controller: formPrinController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.home, color: Colors.white70),
              hintText: "Formacion principal",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 20.0,),
        TextField(
          controller: formSecController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.home, color: Colors.white70),
              hintText: "Formacion secundaria",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
        SizedBox(height: 20.0,),
        TextField(
          controller: categoriaController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle (color: Colors.white70),
          decoration: InputDecoration(
              icon: Icon(Icons.home, color: Colors.white70),
              hintText: "Categoria",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color:Colors.white70)
          ),
        ),
      ],
      ),
    );
  }
}