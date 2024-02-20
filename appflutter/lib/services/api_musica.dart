import 'package:flutter/foundation.dart';
import 'package:appflutter/models/musica_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'dart:convert';
import '../AuthProvider.dart';

class APIMusica {
  static var client = http.Client();

  static Future<List<MusicaModel>?> getMusica() async {
    AuthProvider authProvider = AuthProvider(); // Obtiene la instancia única de AuthProvider
    String? tokenA = authProvider.token;
    print('Token guardado: $tokenA');
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tokenA',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.musicaAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return compute(musicaFromJson, (utf8.decode(response.bodyBytes)));

      //return true;
    } else {
      return null;
    }
  }

  static Future<bool> saveMusica(
      MusicaModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var musicaURL = "${Config.musicaAPI}";

    if (isEditMode) {
      musicaURL = "$musicaURL${model.id_Musica.toString()}/";
    }

    var url = Uri.http(Config.apiURL, musicaURL);

    var requestMethod = isEditMode ? "PUT" : "POST";



    var request = http.MultipartRequest(requestMethod, url);
    request.fields["cancion"] = model.cancion!;
    request.fields["genero"] = model.genero!;
    request.fields["nombre_Artista"] = model.nombre_Artista!;

    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteMusica(MusicaId) async {
    AuthProvider authProvider = AuthProvider(); // Obtiene la instancia única de AuthProvider
    String? tokenA = authProvider.token;
    print('Token guardado: $tokenA');
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      "Authorization": "Token $tokenA",
    };

    var url = Uri.http(Config.apiURL, "${Config.musicaAPI}$MusicaId/");

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
