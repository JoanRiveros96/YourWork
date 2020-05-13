import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class DetailWorker extends StatefulWidget {
  final String workDet;
  DetailWorker(this.workDet);
  @override
  _DetailWorkerState createState() => _DetailWorkerState();
}

class _DetailWorkerState extends State<DetailWorker> {
  @override
  void initState() {
    super.initState();
    getDetailWorker();
  }

  Map data;
  List workerCatData;
  getDetailWorker() async {
    http.Response response =
        await http.get("http://192.168.1.6:3000/worker/" + widget.workDet);
    data = json.decode(response.body);
    setState(() {
      workerCatData = data['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workDet),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: workerCatData == null ? 0 : workerCatData.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(workerCatData[index]["Avatar"]),
                    radius: 80,
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    children: <Widget>[
                      Text(
                        "\t nombre: " + "${workerCatData[index]["nombre"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "\t Ubicacion: " +
                            "${workerCatData[index]["ubicacion"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "\t Celular :" + "${workerCatData[index]["celular"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "\t Formacion : " +
                            "${workerCatData[index]["formacionPrincipal"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "\t Categoria : " +
                            "${workerCatData[index]["categoria"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "\t Calificacion : " +
                            "${workerCatData[index]["calificacion"]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(90.0),
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Contactar",
                            style: TextStyle(
                              fontSize: 26.0,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        FlutterOpenWhatsapp.sendSingleMessage(
                            "57" + "${workerCatData[index]['celular']}",
                            "hola, podrias ayudarme con algo");
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
