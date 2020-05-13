import 'dart:wasm';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper {
  var status;
  var token;
  String serverUrlAnuncios = "http://192.168.1.6:3000/anuncios";

  //function getData
  Future<List> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrlAnuncios";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
    // print(response.body);
  }

  //function for register products
  void addDataAnuncio(
      String _tituloController,
      String _descripcionController,
      String _categoriaController,
      num _valorController,
      num _contactoController) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    // String myUrl = "$serverUrl/api";
    String myUrl = "http://192.168.1.6:3000/anuncios";
    final response = await http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "titulo": "$_tituloController",
      "descripcion": "$_descripcionController",
      "categoria": "$_categoriaController",
      "valor": "$_valorController",
      "contact": "$_contactoController"
    });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  //function for update or put
  void editAnuncio(String _id, String titulo, String descripcion,
      String categoria, Int32 valor, Int32 contacto) async {
    String myUrl = "http://192.168.1.6:3000/anuncio/$_id";
    http.put(myUrl, body: {
      "titulo": "$titulo",
      "descripcion": "$descripcion",
      "categoria": "$categoria",
      "valor": "$valor",
      "contact": "$contacto"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //function for delete
  Future<void> removeRegister(String _id) async {
    String myUrl = "http://192.168.1.6:3000/anuncio/$_id";

    Response res = await http.delete("$myUrl");

    if (res.statusCode == 200) {
      print("DELETED");
    } else {
      throw "Can't delete post.";
    }
  }

  //function save
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

//function read
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }
}
