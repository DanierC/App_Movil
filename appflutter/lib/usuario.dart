class Usuario {
  int id;
  String email;
  String password;
  String token;
  String cargo;

  Usuario({
    required this.id,
    required this.email,
    required this.password,
    required this.token,
    required this.cargo,
  });

  factory Usuario.fromJson(Map json) {
    return Usuario(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      token: json["token"],
      cargo: json["cargo"],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'token': token,
    'cargo': cargo,
  };
}