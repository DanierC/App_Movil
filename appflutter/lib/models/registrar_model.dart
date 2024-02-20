import 'dart:convert';

List<UsuarioModel> usuarioFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<UsuarioModel>((json) => UsuarioModel.fromJson(json))
      .toList();
}

class UsuarioModel {
  late int? id;
  late String? email;
  late String? password;
  late String? cargo;
  late String? name;
  late String? apellido_Usuario;
  late String? genero_Usuario;
  late String? cedula;
  late String? telefono;



  Map<String, List<String>> getChoices() {
    return {
      'cargo': ['Mesero', 'Dj', 'Proveedor', 'Administrador'],
      'genero_Usuario': ['Masculino', 'Femenino', 'Otro'],
    };
  }

  UsuarioModel({
    this.id,
    this.email,
    this.password,
    this.cargo,
    this.name,
    this.apellido_Usuario,
    this.genero_Usuario,
    this.cedula,
    this.telefono,

  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      cargo: json['cargo'] as String?,
      name: json['name'] as String?,
      apellido_Usuario: json['apellido_Usuario'] as String?,
      genero_Usuario: json['genero_Usuario'] as String?,
      cedula: json['cedula'] as String?,
      telefono: json['telefono'] as String?,

    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['cargo'] = cargo;
    data['name'] = name;
    data['apellido_Usuario'] = apellido_Usuario;
    data['genero_Usuario'] = genero_Usuario;
    data['cedula'] = cedula;
    data['telefono'] = telefono;
    return data;
  }
}