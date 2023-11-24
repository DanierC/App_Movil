import 'dart:convert';

List<MusicaModel> musicaFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<MusicaModel>((json) => MusicaModel.fromJson(json))
      .toList();
}

class MusicaModel {
  late int? id_Musica;
  late String? cancion;
  late String? genero;
  late String? nombre_Artista;

  MusicaModel({
    this.id_Musica,
    this.cancion,
    this.genero,
    this.nombre_Artista,
  });

  factory MusicaModel.fromJson(Map<String, dynamic> json) {
    return MusicaModel(
      id_Musica: json['id_Musica'] as int?,
      cancion: json['cancion'] as String?,
      genero: json['genero'] as String?,
      nombre_Artista: json['nombre_Artista'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_Musica'] = id_Musica;
    data['cancion'] = cancion;
    data['genero'] = genero;
    data['nombre_Artista'] = nombre_Artista;
    return data;
  }
}