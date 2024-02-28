import 'package:flutter/foundation.dart';
import 'package:appflutter/models/pedMesero_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

class APIPedidoM {
  static var client = http.Client();

  static Future<List<PedidoModel>?> getPedidoM() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.pedidoMAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return compute(pedidoMFromJson, response.body);


    } else {
      return null;
    }
  }

  static Future<bool> savePedidoM(
      PedidoModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var pedidoMURL = "${Config.pedidoMAPI}";

    if (isEditMode) {
      pedidoMURL = "$pedidoMURL${model.id_Orden.toString()}/";
    }

    var url = Uri.http(Config.apiURL, pedidoMURL);

    var requestMethod = isEditMode ? "PUT" : "POST";



    var request = http.MultipartRequest(requestMethod, url);
    request.fields["cantidad"] =
        model.cantidad!.toString();
    request.fields["id_Usuario"] =
        model.id_Usuario!.toString();
    request.fields["articulo_Id"] =
        model.articulo_Id!.toString();

    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deletePedidoM(PedidoMId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.pedidoMAPI}$PedidoMId/");

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
