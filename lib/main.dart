import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work/view/addProducts.dart';
import 'package:work/view/listWorkers.dart';
import 'package:work/view/registroWorker.dart';
import 'package:work/view/loginPage.dart';
import 'package:http/http.dart' as http;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YourWork App',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  SharedPreferences sharedPrefences;
  @override
  void initState(){
    super.initState();
    checkLoginStatus();
    getCategorias();
  }



  checkLoginStatus() async {
    sharedPrefences = await SharedPreferences.getInstance();
    if(sharedPrefences.getString("token")==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>LoginPage()), (Route<dynamic> route )=> false);
    }
  }
  Map data;
  List categoriaData;
  getCategorias() async{
    http.Response response = await http.get("http://192.168.1.6:3000/categorias");
    data = json.decode(response.body);
    setState(() {
      categoriaData = data['categoria'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YourWork APP", style: TextStyle(color: Colors.white )),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              sharedPrefences.clear();
              sharedPrefences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>LoginPage()), (Route<dynamic> route )=> false);
            },
            child: Text("Logout", style: TextStyle(color: Colors.white),),
          )
        ],
      ),
      body : ListView.builder(
        itemCount: categoriaData==null ?0 : categoriaData.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            child: Padding(padding: const EdgeInsets.all(6.0),

             child: Container(constraints: const  BoxConstraints.expand(height: 100.0
             ),
               alignment: Alignment.center,
               padding: const EdgeInsets.all(10.0),
                    decoration:  BoxDecoration(
                      image:  DecorationImage(
                        image: NetworkImage(categoriaData[index]['imagen']),
                        fit: BoxFit.cover

                      ),
                    ),
                     child: Text("${categoriaData[index]["nombre"]}",
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                       fontSize: 40.0
                     ),
                     ),
                  ),
            ),
          );
        },
      ),
      drawer: Drawer(
          child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text("alpha"),
                  accountEmail: new Text("alpha@gmail.com"),
                ),
                new ListTile(
                    title: new Text("Trabajadores activos"),
                    trailing: new Icon(Icons.work),
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ListWorker()),
                    )),
                new ListTile(title: new Text("Publica Anuncio"),
                    trailing: new Icon(Icons.announcement),
                    onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>AddDataProduct()),
                    )),

                new ListTile(title: new Text("Unete a nosotros"),
                  trailing: new Icon(Icons.group_add),
                    onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>RegistroPage()),
                )),
              ]
          )
      ),

    );
  }
}