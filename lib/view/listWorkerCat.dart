import 'dart:convert';

import 'package:flutter/painting.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:work/view/detalleWorker.dart';

class WorkerCat extends StatefulWidget {
  final String cat;
  WorkerCat(this.cat);

  @override
  _WorkerCatState createState() => _WorkerCatState();
}

class _WorkerCatState extends State<WorkerCat> {
  @override
  void initState() {
    super.initState();
    getWorkerCat();
  }

  Map data;
  List workerCatData;
  getWorkerCat() async {
    http.Response response = await http
        .get("http://192.168.1.6:3000/worker/categorias/" + widget.cat);
    data = json.decode(response.body);
    setState(() {
      workerCatData = data['worker'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.cat),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
          itemCount: workerCatData == null ? 0 : workerCatData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailWorker(workerCatData[index]['nombre'])),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                          backgroundImage:
                              NetworkImage(workerCatData[index]['Avatar']),
                          radius: 50),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "\t" + "${workerCatData[index]["nombre"]}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Calificacion: "
                              "${workerCatData[index]["calificacion"]}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
