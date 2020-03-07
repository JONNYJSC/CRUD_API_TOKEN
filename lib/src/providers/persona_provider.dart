import 'dart:io';
import 'dart:convert';

// import 'package:crud_api_token/src/providers/users_log.dart';
import 'package:crud_api_token/src/utils/session.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:crud_api_token/src/api/webapi.dart';
import 'package:crud_api_token/src/models/persona_model.dart';
import 'package:crud_api_token/src/preferencias_usuario/preferencias_usuario.dart';

class PersonasProvider {
  String _url = WebApi.urlApi;
  final _prefs = new PreferenciasUsuario();
  // final _prefs = Session();

  Future<bool> crearPersona(Persona persona) async {
    final url = '$_url/api/persons';
    final resp = await http.post(url,
        headers: {
          "content-type": "application/json",
          "token": '${_prefs.token}'
        },
        body: profileToJson(persona));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  String profileToJson(Persona data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }

  Future<List<Persona>> cargarPersonas() async {
    final url = '$_url/api/persons';
    final resp = await http.get(url, headers: {"token": '${_prefs.token}'});

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final PersonModel dataP = new PersonModel.fromJson(decodedData);

    if (decodedData == null) return [];

    return dataP.data;
  }

  Future<bool> editarPersona(Persona persona) async {
    final url = '$_url/api/persons/${persona.sId}';
    final resp = await http.put(url,
        headers: {
          "content-type": "application/json",
          "token": '${_prefs.token}'
        },
        body: profileToJson(persona));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<bool> borrarPersona(String id) async {
    final url = '$_url/api/persons/$id';
    final resp = await http.delete(url, headers: {
      "content-type": "application/json",
      "token": '${_prefs.token}'
    });
    print(resp.body);
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Persona persona;
  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(persona.pictures[0].url);
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    imageUploadRequest.files.add(file);
    final streangResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streangResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo Salio mal');
      print(resp.body);
      return null;
    }

    final respdata = json.decode(resp.body);
    print(respdata);
    return respdata['secure_url'];
  }

  /*---------------------------------------------------------------------*/
  Future getUploadimg(_image) async {
    String apiUrl = '$_url/api/persons';
    http.Response response = await http.post(apiUrl, headers: {
      "content-type": "multipart/form-data",
    }, body: {
      'avatar': _image
    });
    print("Result: ${response.body}");
    return json.decode(response.body);
  }

  Future getUploadImg(File _image) async {
    String apiUrl = '$_url/api/persons';
    final length = await _image.length();
    final request = new http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..files.add(new http.MultipartFile('avatar', _image.openRead(), length));
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("Result: ${response.body}");
    return json.decode(response.body);
  }

/*-------------------------------------------------------------------------------------------------------------*/
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  String status = '';
  String base64Image;

  setStatus(String message) {
    //setState(() {
    status = message;
    //});
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    http.post('$_url/api/persons', body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }
}
