import 'package:flutter/foundation.dart';
import 'package:appflutter/models/sugeQuejas_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class APISugeQ {
  static var client = http.Client();

  static Future<List<SugeQModel>?> getSugeQ() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.sugequejasAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return compute(sugeQFromJson, (utf8.decode(response.bodyBytes)));

      //return true;
    } else {
      return null;
    }
  }

  static Future<bool> saveSugeQ(
      SugeQModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var sugeqURL = "${Config.sugequejasAPI}";

    if (isEditMode) {
      sugeqURL = "$sugeqURL${model.id_SugeQuejas.toString()}/";
    }

    var url = Uri.http(Config.apiURL, sugeqURL);

    var requestMethod = isEditMode ? "PUT" : "POST";

    String formatUTCtoLocal(DateTime utcDateTime) {
      final localTimeZone = DateTime.now().timeZoneOffset;
      final localDateTime = utcDateTime.add(localTimeZone);
      return DateFormat("dd/MM/yyyy HH:mm").format(localDateTime);
    }
    var request = http.MultipartRequest(requestMethod, url);
    request.fields['estado'] = model.estado!;
    request.fields['suge_Queja'] = model.suge_Queja!;

    //request.fields["fecha"] = formatUTCtoLocal(model.fecha ?? DateTime.now());



    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteSugeQ(sugeqId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.sugequejasAPI}$sugeqId/");

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
