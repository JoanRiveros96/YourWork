import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:work/main.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

enum PhotoSource { FILE, NETWORK }

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  List<File> _photos = List<File>();

  File fotPhoto;

  File antPhoto;

  List<String> _photosUrls = List<String>();

  List<PhotoSource> _photosSources = List<PhotoSource>();
  List<GalleryItem> _galleryItems = List<GalleryItem>();

  bool _isLoading = false;
  bool _antFoto = false;
  bool _fotFoto = false;
  final TextEditingController nombreController = new TextEditingController();
  final TextEditingController cedulaController = new TextEditingController();
  String fotPhotoUrl = " ";
  final TextEditingController ubicacionController = new TextEditingController();

  final TextEditingController celularController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nacimientoController =
      new TextEditingController();
  String antPhotoUrl = " ";
  final TextEditingController formPrinController = new TextEditingController();
  final TextEditingController formSecController = new TextEditingController();
  final TextEditingController categoriaController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  heardSection(),
                  textSection(),
                  signupSection()
                ],
              ),
      ),
    );
  }

  void _CamaraFot() async {
    File imagen = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (imagen != null) {
      _addPhotoFot(imagen);
    }
  }

  void _GaleriaFot() async {
    File imagen = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (imagen != null) {
      _addPhotoFot(imagen);
    }
  }

  void _CamaraAnt() async {
    File imagen = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (imagen != null) {
      _addPhotoAnt(imagen);
    }
  }

  void _GaleriaAnt() async {
    File imagen = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (imagen != null) {
      _addPhotoAnt(imagen);
    }
  }

  _addPhotoFot(File imagen) async {
    String fileExtension = path.extension(imagen.path);

    _galleryItems.add(
      GalleryItem(
        id: Uuid().v1(),
        resource: imagen.path,
        isSvg: fileExtension.toLowerCase() == ".svg",
      ),
    );
    setState(() {
      _photos.add(imagen);
      antPhoto = imagen;
      _photosSources.add(PhotoSource.FILE);
    });
    GenerateImageUrl generateImageUrl = GenerateImageUrl();
    await generateImageUrl.call(fileExtension);

    String uploadUrl;
    if (generateImageUrl.isGenerated != null && generateImageUrl.isGenerated) {
      uploadUrl = generateImageUrl.uploadUrl;
    } else {
      throw generateImageUrl.message;
    }

    bool isUploaded = await uploadFile(context, uploadUrl, imagen);
    if (isUploaded) {
      setState(() {
        _photosUrls.add(generateImageUrl.downloadUrl);
        fotPhotoUrl = generateImageUrl.downloadUrl;
      });
    }
  }

  _addPhotoAnt(File imagen) async {
    String fileExtension = path.extension(imagen.path);

    _galleryItems.add(
      GalleryItem(
        id: Uuid().v1(),
        resource: imagen.path,
        isSvg: fileExtension.toLowerCase() == ".svg",
      ),
    );
    setState(() {
      _photos.add(imagen);
      antPhoto = imagen;
      _photosSources.add(PhotoSource.FILE);
    });
    GenerateImageUrl generateImageUrl = GenerateImageUrl();
    await generateImageUrl.call(fileExtension);

    String uploadUrl;
    if (generateImageUrl.isGenerated != null && generateImageUrl.isGenerated) {
      uploadUrl = generateImageUrl.uploadUrl;
    } else {
      throw generateImageUrl.message;
    }

    bool isUploaded = await uploadFile(context, uploadUrl, imagen);
    if (isUploaded) {
      setState(() {
        _photosUrls.add(generateImageUrl.downloadUrl);
        antPhotoUrl = generateImageUrl.downloadUrl;
      });
    }
  }

  Future<bool> uploadFile(context, String url, File image) async {
    try {
      UploadFile uploadFile = UploadFile();
      await uploadFile.call(url, image);

      if (uploadFile.isUploaded != null && uploadFile.isUploaded) {
        return true;
      } else {
        throw uploadFile.message;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> _optionsDialogBoxAnt() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Tomar una foto'),
                    onTap: _CamaraAnt,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Seleccionar de la galeria'),
                    onTap: _GaleriaAnt,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _optionsDialogBoxFot() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Tomar una foto'),
                    onTap: _CamaraFot,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Seleccionar de la galeria'),
                    onTap: _GaleriaFot,
                  ),
                ],
              ),
            ),
          );
        });
  }

  signup(String nombre, cc, avatar, ubicacion, celular, email, nacimiento,
      antecedentes, categoria, formPrin, formSec) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'nombre': nombre,
      'cc': cc,
      'Avatar': avatar,
      'ubicacion': ubicacion,
      'celular': celular,
      'email': email,
      'nacimiento': nacimiento,
      'Antecedentes': antecedentes,
      'categoria': categoria,
      'formacionPrincipal': formPrin,
      'formacionSecundaria': formSec,
      'calificacion': '3',
      'status': 'false'
    };
    var jsonResponse;
    var response =
        await http.post("http://192.168.1.6:3000/workers", body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Container heardSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Genera ingresos usando tus habilidades",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white70,
              fontSize: 30.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: nombreController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.white70),
                hintText: "Nombre completo",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: cedulaController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.perm_identity, color: Colors.white70),
                hintText: "Cedula",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: RaisedButton(
                  color: _fotFoto ? Colors.green : Colors.white,
                  onPressed: () => [
                    setState(() => _fotFoto = !_fotFoto),
                    _optionsDialogBoxFot()
                  ],
                  child: Text("Foto"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "URL" + fotPhotoUrl,
                  maxLines: 3,
                  softWrap: true,
                  style:
                      TextStyle(fontSize: 4.0, backgroundColor: Colors.green),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: ubicacionController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.home, color: Colors.white70),
                hintText: "Ubicacion",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: celularController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.phone, color: Colors.white70),
                hintText: "Celular",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.email, color: Colors.white70),
                hintText: "Email",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: nacimientoController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.date_range, color: Colors.white70),
                hintText: "Fecha de nacimiento",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: RaisedButton(
                  color: _antFoto ? Colors.green : Colors.white,
                  onPressed: () => [
                    setState(() => _antFoto = !_antFoto),
                    _optionsDialogBoxAnt()
                  ],
                  child: Text("Antecedentes"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "URL" + antPhotoUrl,
                  maxLines: 3,
                  softWrap: true,
                  style:
                      TextStyle(fontSize: 4.0, backgroundColor: Colors.green),
                ),
              )
            ],
          ),
          TextField(
            controller: formPrinController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.school, color: Colors.white70),
                hintText: "Formacion principal",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: formSecController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.school, color: Colors.white70),
                hintText: "Formacion secundaria",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: categoriaController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.category, color: Colors.white70),
                hintText: "Categoria",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Container signupSection() {
    var signupButton = RaisedButton(
      onPressed: nombreController.text == "" ||
              cedulaController.text == "" ||
              fotPhotoUrl == "" ||
              ubicacionController.text == "" ||
              celularController.text == "" ||
              emailController.text == "" ||
              nacimientoController.text == "" ||
              antPhotoUrl == "" ||
              formPrinController.text == "" ||
              categoriaController.text == ""
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });

              signup(
                  nombreController.text,
                  cedulaController.text,
                  fotPhotoUrl,
                  ubicacionController.text,
                  celularController.text,
                  emailController.text,
                  nacimientoController.text,
                  antPhotoUrl,
                  categoriaController.text,
                  formPrinController.text,
                  formSecController.text);
            },
      elevation: 0.0,
      color: Colors.green,
      child: Text(
        "Registrate",
        style: TextStyle(color: Colors.white70, fontSize: 25),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(15),
      child: signupButton,
    );
  }
}

class GenerateImageUrl {
  bool success;
  String message;

  bool isGenerated;
  String uploadUrl;
  String downloadUrl;

  Future<void> call(String fileType) async {
    try {
      Map body = {"fileType": fileType};

      var response = await http.post(
        //For IOS
        //'http://localhost:5000/generatePresignedUrl',
        //For Android
        'http://192.168.1.6:5000/generatePresignedUrl',
        body: body,
      );

      var result = jsonDecode(response.body);

      print(result);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];

        if (response.statusCode == 201) {
          isGenerated = true;
          uploadUrl = result["uploadUrl"];
          downloadUrl = result["downloadUrl"];
        }
      }
    } catch (e) {
      throw ('Error getting url');
    }
  }
}

class GalleryItem {
  GalleryItem({this.id, this.resource, this.isSvg = false});

  final String id;
  String resource;
  final bool isSvg;
}

class UploadFile {
  bool success;
  String message;

  bool isUploaded;

  Future<void> call(String url, File image) async {
    try {
      var response = await http.put(url, body: image.readAsBytesSync());
      if (response.statusCode == 200) {
        isUploaded = true;
      }
    } catch (e) {
      throw ('Error uploading photo');
    }
  }
}
