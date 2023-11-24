import 'package:flutter/foundation.dart';
import 'package:appflutter/models/usuarios_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'dart:convert';

class APIUsuario2 {
  static var client = http.Client();

  static Future<List<Usuario2Model>?> getUsuario2() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.listAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return compute(usuario2FromJson, (utf8.decode(response.bodyBytes)));

      //return true;
    } else {
      return null;
    }
  }


  static Future<bool> deleteUsuario(userId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.listAPI}$userId/");

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
