import 'package:flutter/foundation.dart';
import 'package:NivelesClub/models/registrar_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

class APIRegistrar {
  static var client = http.Client();

  static Future<List<UsuarioModel>?> getUsuario() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.registrarAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return usuarioFromJson( response.body);

      //return true;
    } else {
      return null;
    }
  }

  static Future<bool> saveRegistrar(
      UsuarioModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var registURL = "${Config.registrarAPI}";

    if (isEditMode) {
      registURL = "$registURL${model.id.toString()}/";
    }

    var url = Uri.http(Config.apiURL, registURL);

    var requestMethod = isEditMode ? "PUT" : "POST";


    var request = http.MultipartRequest(requestMethod, url);

    request.fields['email'] = model.email!;
    request.fields['password'] = model.password!;
    request.fields['cargo'] = model.cargo!;
    request.fields['name'] = model.name!;
    request.fields['apellido_Usuario'] = model.apellido_Usuario!;
    request.fields['genero_Usuario'] = model.genero_Usuario!;
    request.fields['cedula'] = model.cedula!;
    request.fields['telefono'] = model.telefono!;

    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteRegistrar(registId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.registrarAPI}$registId/");

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }



}
