import 'package:flutter/foundation.dart';
import 'package:appflutter/models/inventario_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'dart:async';
import 'package:intl/intl.dart';
class APIInventario {
  static var client = http.Client();
  static StreamController<List<InventarioModel>> _inventarioStreamController =
  StreamController<List<InventarioModel>>.broadcast();

  // Obtener el stream asociado
  static Stream<List<InventarioModel>> get inventarioStream =>
      _inventarioStreamController.stream;

  static Future<List<InventarioModel>?> getInventario() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.inventarioAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return compute(inventarioFromJson, response.body);

      //return true;
    } else {
      return null;
    }
  }

  static Future<bool> saveInventario(
      InventarioModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var inventarioURL = "${Config.inventarioAPI}";

    if (isEditMode) {
      inventarioURL = "$inventarioURL${model.id_Inventario.toString()}/";
    }

    var url = Uri.http(Config.apiURL, inventarioURL);

    var requestMethod = isEditMode ? "PUT" : "POST";

    String formatUTCtoLocal(DateTime utcDateTime) {
      final localTimeZone = DateTime.now().timeZoneOffset;
      final localDateTime = utcDateTime.add(localTimeZone);
      return DateFormat("dd/MM/yyyy HH:mm").format(localDateTime);
    }
    var request = http.MultipartRequest(requestMethod, url);
    request.fields["id_Articulos_Inventario"] = model.id_Articulos_Inventario!.toString();
    request.fields["cantidad_Inicial"] = model.cantidad_Inicial!.toString();
    request.fields["cantidad_Final"] = model.cantidad_Final!.toString();
    request.fields["pedidos_Bodega"] = model.pedidos_Bodega!.toString();
    request.fields["cantidad_TotalVenta"] = model.cantidad_TotalVenta!.toString();
    request.fields["total_Venta"] = model.total_Venta!.toString();
    request.fields["fecha"] = formatUTCtoLocal(model.fecha ?? DateTime.now());


    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteInventario(InventarioId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.inventarioAPI}$InventarioId/");

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
