import 'package:flutter/foundation.dart';
import 'package:NivelesClub/models/reservar_model.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'package:intl/intl.dart';
class APIReserva {
  static var client = http.Client();

  static Future<List<ReservaModel>?> getReserva() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.reservaAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return compute(reservaFromJson, response.body);

      //return true;
    } else {
      return null;
    }
  }

  static Future<bool> saveReserva(
      ReservaModel model,
      bool isEditMode,
      bool isFileSelected,
      ) async {
    var reservaURL = "${Config.reservaAPI}";

    if (isEditMode) {
      reservaURL = "$reservaURL${model.id_Reservas.toString()}/";
    }

    var url = Uri.http(Config.apiURL, reservaURL);

    var requestMethod = isEditMode ? "PUT" : "POST";

    String formatUTCtoLocal(DateTime utcDateTime) {
      final localTimeZone = DateTime.now().timeZoneOffset;
      final localDateTime = utcDateTime.add(localTimeZone);
      return DateFormat("dd/MM/yyyy HH:mm").format(localDateTime);
    }
    var request = http.MultipartRequest(requestMethod, url);
    // request.fields["cantidad"] = model.cantidad_Personas!.toString();
    request.fields['ubicacion_Mesa'] = model.ubicacion_Mesa!;
    request.fields["estado_Reserva"] = model.estado_Reserva!;
    //request.fields["fecha"] = formatUTCtoLocal(model.fecha ?? DateTime.now());

    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteReserva(ReservaId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.reservaAPI}$ReservaId/");

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
