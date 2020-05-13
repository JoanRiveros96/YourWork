import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:work/view/detalleWorker.dart';

class ListAnuncios extends StatefulWidget {
  @override
  _ListAnunciosState createState() => _ListAnunciosState();
}

class _ListAnunciosState extends State<ListAnuncios> {
  @override
  void initState() {
    super.initState();
    getAnuncios();
  }

  Map data;
  List anuncioData;
  getAnuncios() async {
    http.Response response = await http.get("http://192.168.1.6:3000/anuncios");
    data = json.decode(response.body);
    setState(() {
      anuncioData = data['anuncio'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Solicitudes de trabajo'),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
          itemCount: anuncioData == null ? 0 : anuncioData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailWorker(anuncioData[index]['nombre'])),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "\t" + "${anuncioData[index]["titulo"]}",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text(
                              "${anuncioData[index]["descripcion"]}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Categoria:" +
                                  "${anuncioData[index]["categoria"]}",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.redAccent),
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
