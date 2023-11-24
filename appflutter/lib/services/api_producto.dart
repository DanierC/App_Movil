import 'package:flutter/foundation.dart';
import 'package:appflutter/models/producto_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'dart:convert';

class APIProducto {
  static var client = http.Client();

  static Future<List<ProductoModel>?> getProductos() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=UTF-8',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.productosAPI,
    );

    var response = await client.get(
      url,
      headers: {"charset": "UTF-8"},
    );

    if (response.statusCode == 200) {
      return compute(productosFromJson,(utf8.decode(response.bodyBytes)));

    } else {
      return null;
    }
  }

  static Future<bool> saveProducto(
      ProductoModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var productURL = "${Config.productosAPI}";

    if (isEditMode) {
      productURL = "$productURL${model.id_Articulos.toString()}/";
    }

    var url = Uri.http(Config.apiURL, productURL);

    var requestMethod = isEditMode ? "PUT" : "POST";

    var request = http.MultipartRequest(requestMethod, url);
    request.fields["nombre_Producto"] = model.nombre_Producto!;
    request.fields["precio_Producto"] =
        model.precio_Producto!.toString();
    request.fields["costo_Producto"] =
        model.costo_Producto!.toString();

    if (model.imagen_Producto != null && isFileSelected) {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'imagen_Producto',
        model.imagen_Producto!,
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

  static Future<bool> deleteProducto(productId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=UTF-8',
    };

    var url = Uri.http(Config.apiURL, "${Config.productosAPI}$productId/");

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
