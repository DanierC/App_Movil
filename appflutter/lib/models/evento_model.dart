import 'dart:convert';

List<EventoModel> eventoFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<EventoModel>((json) => EventoModel.fromJson(json))
      .toList();
}

class EventoModel {
  late int? id_Foto;
  late String? imagen_Evento;
  late int? precio_Palco;
  late int? cantidad_Personas;

  EventoModel({
    this.id_Foto,
    this.imagen_Evento,
    this.precio_Palco,
    this.cantidad_Personas,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) {
    return EventoModel(
      id_Foto: json['id_Foto'] as int?,
      imagen_Evento: json['imagen_Evento'] as String?,
      precio_Palco: json['precio_Palco'] as int?,
      cantidad_Personas: json['cantidad_Personas'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_Foto'] = id_Foto;
    data['imagen_Evento'] = imagen_Evento;
    data['precio_Palco'] = precio_Palco;
    data['cantidad_Personas'] = cantidad_Personas;
    return data;
  }
}