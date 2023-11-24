class Usuario {
  String email;
  String password;
  String token;
  String cargo;

  Usuario({
    required this.email,
    required this.password,
    required this.token,
    required this.cargo,
  });

  factory Usuario.fromJson(Map json) {
    return Usuario(
      email: json["email"],
      password: json["password"],
      token: json["token"],
      cargo: json["cargo"],
    );
  }
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'token': token,
    'cargo': cargo,
  };
}