import 'dart:wasm';

import 'package:work/controllers/databasehelpers.dart';
import 'package:work/main.dart';
import 'package:flutter/material.dart';

class AddDataAnuncio extends StatefulWidget {

  AddDataAnuncio({Key key , this.title}) : super(key : key);
  final String title;

  @override
  _AddDataProductState createState() => _AddDataProductState();
}

class _AddDataProductState extends State<AddDataAnuncio> {

  DataBaseHelper databaseHelper = new DataBaseHelper();


  final TextEditingController _tituloController = new TextEditingController();
  final TextEditingController _descripcionController = new TextEditingController();
  final TextEditingController _categoriaController = new TextEditingController();
  final TextEditingController _valorController = new TextEditingController();
  final TextEditingController _contactoController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrega tu anuncio',
      home: Scaffold(
        appBar: AppBar(
          title:  Text('Añadir anuncio'),
          backgroundColor: Colors.green
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(top: 62,left: 12.0,right: 12.0,bottom: 12.0),
            children: <Widget>[

              Container(
                height: 50,
                child: new TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    hintText: 'Título de tu anuncio',
                    icon: new Icon(Icons.title),
                  ),
                ),
              ),

              Container(
                height: 50,
                child: new TextField(
                  controller: _descripcionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Describe lo que necesitas',
                    icon: new Icon(Icons.description),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: new TextField(
                  controller: _categoriaController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Categoría a la que aplica',
                    icon: new Icon(Icons.category),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: new TextField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Realiza tu oferta por tu solicitud',
                    icon: new Icon(Icons.attach_money),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: new TextField(
                  controller: _contactoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Número de contacto',
                    icon: new Icon(Icons.phone),
                  ),
                ),
              ),
              new Padding(padding: new EdgeInsets.only(top: 44.0),),
              Container(
                height: 50,
                child: new RaisedButton(
                  onPressed: (){
                    databaseHelper.addDataAnuncio(
                        _tituloController.text.trim(), _descripcionController.text.trim(), _categoriaController.text.trim(),
                    int.parse(_valorController.text.trim()),int.parse(_contactoController.text.trim()));
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new MainPage(),
                        )
                    );
                  },
                  color: Colors.green,
                  child: new Text(
                    'Añadir',
                    style: new TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.green),),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }



}