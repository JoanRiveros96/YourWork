import 'dart:async';
import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:work/main.dart';
import 'package:work/view/detailProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:work/main.dart';



class workerCat extends StatefulWidget {

  final String cat;
  workerCat(this.cat);

  @override
  _workerCatState createState() => _workerCatState();
}
class _workerCatState extends State<workerCat> {

  @override
  void initState() {
    super.initState();
    getWorkerCat();

  }

  Map data;
  List workerCatData;
  getWorkerCat() async{
    http.Response response = await http.get("http://192.168.1.6:3000/worker/categorias/"+widget.cat);
    data = json.decode(response.body);
    setState(() {
      workerCatData = data['worker'];
    });
  }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text( widget.cat),
          backgroundColor: Colors.green,
        ),
        body : ListView.builder(

          itemCount: workerCatData==null ?0 : workerCatData.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(backgroundImage: NetworkImage(workerCatData[index]['Avatar']),
                        radius: 50
                    ),
                    Column(

                      children: <Widget>[
                        Text("\t"+"${workerCatData[index]["nombre"]}",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold

                          ),
                        ),

                        Text("Calificacion: ""${workerCatData[index]["calificacion"]}",

                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
             ),
            );
          },
        )
    );
  }
}
