import 'package:flutter/foundation.dart';
import 'package:appflutter/models/pedBodega_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'package:intl/intl.dart';
class APIPedidoB {
  static var client = http.Client();

  static Future<List<PedidoBModel>?> getPedidoB() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.pedidoBAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return compute(pedidoBFromJson, response.body);


    } else {
      return null;
    }
  }

  static Future<bool> savePedidoB(
      PedidoBModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var pedidoBURL = "${Config.pedidoBAPI}";

    if (isEditMode) {
      pedidoBURL = "$pedidoBURL${model.id_Orden_Bodega.toString()}/";
    }

    var url = Uri.http(Config.apiURL, pedidoBURL);

    var requestMethod = isEditMode ? "PUT" : "POST";


    String formatUTCtoLocal(DateTime utcDateTime) {
      final localTimeZone = DateTime.now().timeZoneOffset;
      final localDateTime = utcDateTime.add(localTimeZone);
      return DateFormat("dd/MM/yyyy HH:mm").format(localDateTime);
    }
    var request = http.MultipartRequest(requestMethod, url);
    request.fields["cantidad"] =
        model.cantidad!.toString();
    request.fields["id_Usuario"] =
        model.id_Usuario!.toString();
    request.fields["estado_Pedido"] = model.estado_Pedido!;
    request.fields["cantidad_Total"] = model.cantidad_Total!.toString();
    request.fields['tipo_Cantidad'] = model.tipo_Cantidad!;
    request.fields["articulos_Bodega_id"] =
        model.articulos_Bodega_id!.toString();
    request.fields["fecha"] = formatUTCtoLocal(model.fecha ?? DateTime.now());



    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deletePedidoB(PedidoBId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.pedidoBAPI}$PedidoBId/");

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
