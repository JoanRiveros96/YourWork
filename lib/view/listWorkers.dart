import 'dart:async';
import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:work/view/detailProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:work/view/detalleWorker.dart';

class ListWorker extends StatefulWidget {
  @override
  _ListWorkerState createState() => _ListWorkerState();
}

class _ListWorkerState extends State<ListWorker> {

  @override
  void initState() {
    super.initState();
    getWorker();
  }

  Map data;
  List workerData;
  getWorker() async{
    http.Response response = await http.get("http://192.168.1.6:3000/workers");
    data = json.decode(response.body);
    setState(() {
     workerData = data['worker'];
    });
  }

  @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Trabajadores activos'),
       backgroundColor: Colors.green,
     ),
      body : ListView.builder(

        itemCount: workerData==null ?0 : workerData.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(onTap: ()=> Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>detailWorker(workerData[index]['nombre'])
                ),
              ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(backgroundImage: NetworkImage(workerData[index]['Avatar']),
                      radius: 50
                    ),
                    Column(

                      children: <Widget>[
                        Text("\t"+"${workerData[index]["nombre"]}",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold

                          ),
                        ),

                        Text("${workerData[index]["categoria"]}",

                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,

                          ),
                        ),
                        Text("Calificacion:"+"${workerData[index]["calificacion"]}",

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
            ),
          );
        },
      )
   );
 }
}
