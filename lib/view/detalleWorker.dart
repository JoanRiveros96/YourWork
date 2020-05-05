import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';


class detailWorker extends StatefulWidget {

  final String workDet;
  detailWorker(this.workDet);
  @override
  _detailWorkerState createState() => _detailWorkerState();
}

class _detailWorkerState extends State<detailWorker> {

  @override
  void initState() {
    super.initState();
    getDetailWorker();

  }


  Map data;
  List workerCatData;
  getDetailWorker() async{
    http.Response response = await http.get("http://192.168.1.6:3000/worker/"+widget.workDet);
    data = json.decode(response.body);
    setState(() {
      workerCatData = data['data'];
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text( widget.workDet),
          backgroundColor: Colors.green,
        ),
      body: ListView.builder(
        itemCount: workerCatData==null ?0 : workerCatData.length,
        itemBuilder:(BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(workerCatData[index]["Avatar"]),
                    radius: 80,
                  ),SizedBox(height: 20.0),
                  Column(
                    children: <Widget>[
                      Text("\t nombre: "+ "${workerCatData[index]["nombre"]}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      ),SizedBox(height: 20.0),
                      Text("\t Ubicacion: "+ "${workerCatData[index]["ubicacion"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),SizedBox(height: 20.0),
                      Text("\t Celular :"+ "${workerCatData[index]["celular"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),SizedBox(height: 20.0),
                      Text("\t Formacion : "+ "${workerCatData[index]["formacionPrincipal"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),SizedBox(height: 20.0),
                      Text("\t Categoria : "+ "${workerCatData[index]["categoria"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),SizedBox(height: 20.0),
                      Text("\t Calificacion : "+ "${workerCatData[index]["calificacion"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),SizedBox(height: 20.0),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
//        body : new Container(
//            child: Card(
//              child: Padding(
//                padding: const EdgeInsets.all(10.0),
//                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    CircleAvatar(backgroundImage: NetworkImage(data['Avatar']),
//                        radius: 50
//                    ),
//                    Column(
//
//                      children: <Widget>[
//
//                        Text("\t"+"${data["nombre"]}",
//                          style: TextStyle(
//                              fontSize: 20.0,
//                              fontWeight: FontWeight.bold
//
//                          ),
//                        ),
//                        Text("Calificacion: ""${data["calificacion"]}",
//
//                          style: TextStyle(
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.w700,
//

    );
  }
}

