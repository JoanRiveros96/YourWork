import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work/view/addProducts.dart';
import 'package:work/view/listProducts.dart';
import 'package:work/view/loginPage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YourWork App',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
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
  }

  

  checkLoginStatus() async {
    sharedPrefences = await SharedPreferences.getInstance();
    if(sharedPrefences.getString("token")==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>LoginPage()), (Route<dynamic> route )=> false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nodejs-Mongodb", style: TextStyle(color: Colors.white )),
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
      body: Center(child: Text("MainPage")),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("alpha"),
              accountEmail: new Text("alpha@gmail.com"),
              ),
              new ListTile(
              title: new Text("List workers"),
              trailing: new Icon(Icons.help),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ListProducts()),
              )),
              new ListTile(title: new Text("Add Worker"),
              trailing: new Icon(Icons.add),
              onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>AddDataProduct()),
              )),
              
              new ListTile(title: new Text("Register worker"),
              trailing: new Icon(Icons.add),
              onTap: (){},
              ),
          ]
        )
      ),
      
    );
  }
}