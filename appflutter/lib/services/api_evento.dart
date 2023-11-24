import 'package:flutter/foundation.dart';
import 'package:appflutter/models/evento_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

class APIEvento {
  static var client = http.Client();

  static Future<List<EventoModel>?> getEvento() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.eventosAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return compute(eventoFromJson, response.body);

      //return true;
    } else {
      return null;
    }
  }

  static Future<bool> saveEvento(
      EventoModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var eventoURL = "${Config.eventosAPI}";

    if (isEditMode) {
      eventoURL = "$eventoURL${model.id_Foto.toString()}/";
    }

    var url = Uri.http(Config.apiURL, eventoURL);

    var requestMethod = isEditMode ? "PUT" : "POST";



    var request = http.MultipartRequest(requestMethod, url);
    request.fields["precio_Palco"] =
        model.precio_Palco!.toString();
    request.fields["cantidad_Personas"] =
        model.cantidad_Personas!.toString();


    if (model.foto != null && isFileSelected) {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'foto',
        model.foto!,
      );

      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteEvento(EventoId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.eventosAPI}$EventoId/");

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
