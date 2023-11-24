import 'dart:convert';

List<Usuario2Model> usuario2FromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Usuario2Model>((json) => Usuario2Model.fromJson(json))
      .toList();
}

class Usuario2Model {
  late int? id;
  late String? email;
  late String? cargo;
  late String? name;
  late String? apellido_Usuario;
  late String? genero_Usuario;
  late String? cedula;
  late String? telefono;


  Usuario2Model({
    this.id,
    this.email,
    this.cargo,
    this.name,
    this.apellido_Usuario,
    this.genero_Usuario,
    this.cedula,
    this.telefono,

  });

  factory Usuario2Model.fromJson(Map<String, dynamic> json) {
    return Usuario2Model(
      id: json['id'] as int,
      email: json['email'] as String?,
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
    data['cargo'] = cargo;
    data['name'] = name;
    data['apellido_Usuario'] = apellido_Usuario;
    data['genero_Usuario'] = genero_Usuario;
    data['cedula'] = cedula;
    data['telefono'] = telefono;
    return data;
  }
}