import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work/view/addAnuncios.dart';
import 'package:work/view/listWorkers.dart';
import 'package:work/view/listWorkerCat.dart';
import 'package:work/view/registroWorker.dart';
import 'package:work/view/listAnuncios.dart';
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
//  final String user;
//  MainPage(this.user);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPrefences;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    getCategorias();
  }

  checkLoginStatus() async {
    sharedPrefences = await SharedPreferences.getInstance();
    if (sharedPrefences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Map data;
  List categoriaData;
  List categoria;
  getCategorias() async {
    http.Response response =
        await http.get("http://192.168.1.6:3000/categorias");
    data = json.decode(response.body);
    setState(() {
      categoriaData = data['categoria'];
      categoria = data['categoria'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YourWork APP", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPrefences.clear();

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: categoriaData == null ? 0 : categoriaData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      WorkerCat(categoria[index]['nombre'])),
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  constraints: const BoxConstraints.expand(height: 100.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(categoriaData[index]['imagen']),
                        fit: BoxFit.cover),
                  ),
                  child: Text(
                    "${categoriaData[index]["nombre"]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      drawer: Drawer(
          child: new ListView(children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: new Text("Joan Sebastian Riveros Lozada"),
          accountEmail: new Text("joanriveros96gmail.com"),
        ),
        new ListTile(
            title: new Text("Trabajadores activos"),
            trailing: new Icon(Icons.work),
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => ListWorker()),
                )),
        new ListTile(
            title: new Text("Solicita un servicio"),
            trailing: new Icon(Icons.announcement),
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => AddDataAnuncio()),
                )),
        new ListTile(
            title: new Text("Listado de Servicios"),
            trailing: new Icon(Icons.pageview),
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => ListAnuncios()),
                )),
        new ListTile(
            title: new Text("Unete a nosotros"),
            trailing: new Icon(Icons.group_add),
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => RegistroPage()),
                )),
        Padding(
          padding: EdgeInsets.all(80.0),
        ),
        Container(
          padding: EdgeInsets.all(40.0),
          child: RaisedButton(
            onPressed: () {},
            elevation: 10.0,
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              "Modo Trabajador",
              style: TextStyle(color: Colors.white70, fontSize: 25),
            ),
          ),
        ),
      ])),
    );
  }
}
