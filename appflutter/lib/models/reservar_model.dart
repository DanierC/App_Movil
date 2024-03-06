import 'dart:convert';

List<ReservaModel> reservaFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ReservaModel>((json) => ReservaModel.fromJson(json))
      .toList();
}

class ReservaModel {
  late int? id_Reservas;
  late String? nombre_Reserva;
  late int? cantidad_Personas;
  late String? ubicacion_Mesa;
  late String? estado_Reserva;
  late DateTime? fecha;

  Map<String, List<String>> getChoices() {
    return {
      'ubicacion_Mesa': ['Cualquiera','1','2','3','4','5','6','7','8','9','10','11'],
      'estado_Reserva': ['Pendiente','Confirmado', 'Denegado'],
    };
  }


  ReservaModel({
    this.id_Reservas,
    this.nombre_Reserva,
    this.cantidad_Personas,
    this.ubicacion_Mesa,
    this.estado_Reserva,
    this.fecha,
  });

  factory ReservaModel.fromJson(Map<String, dynamic> json) {
    return ReservaModel(
      id_Reservas: json['id_Reservas'] as int?,
      nombre_Reserva: json['nombre_Reserva'] as String?,
      cantidad_Personas: json['cantidad_Personas'] as int?,
      ubicacion_Mesa: json['ubicacion_Mesa'] as String?,
      estado_Reserva: json['estado_Reserva'] as String?,
      fecha: DateTime.parse(json['fecha'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_Reservas'] = id_Reservas;
    data['nombre_Reserva'] = nombre_Reserva;
    data['cantidad_Personas'] = cantidad_Personas;
    data['ubicacion_Mesa'] = ubicacion_Mesa;
    data['estado_Reserva'] = estado_Reserva;
    data['fecha'] = fecha?.toIso8601String();
    return data;
  }
}
