import 'dart:convert';

List<SugeQModel> sugeQFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<SugeQModel>((json) => SugeQModel.fromJson(json))
      .toList();
}

class SugeQModel {
  late int? id_SugeQuejas;
  late String? suge_Queja;
  late String? estado;
  late DateTime? fecha;




  SugeQModel({
    this.id_SugeQuejas,
    this.suge_Queja,
    this.estado,
    this.fecha,
  });

  factory SugeQModel.fromJson(Map<String, dynamic> json) {
    return SugeQModel(
      id_SugeQuejas: json['id_SugeQuejas'] as int?,
      estado: json['estado'] as String?,
      suge_Queja: json['suge_Queja'] as String?,
      fecha: DateTime.parse(json['fecha'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_SugeQuejas'] = id_SugeQuejas;
    data['estado'] = estado;
    data['suge_Queja'] = suge_Queja;
    data['fecha'] = fecha?.toIso8601String();
    return data;
  }
}
