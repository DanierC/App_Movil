import 'package:flutter/foundation.dart';
import 'package:NivelesClub/usuario.dart';

class AuthProvider with ChangeNotifier {
  static AuthProvider? _instance; // Instancia única
  factory AuthProvider() {
    if (_instance == null) {
      _instance = AuthProvider._internal();
    }
    return _instance!;
  }

  AuthProvider._internal();
  int? _id;
  String? _token;
  String? _cargo;
  String? get token => _token;
  Usuario? currentUser;
  bool get isLoggedIn => _token != null && _cargo != null;
  String? get cargo => _cargo;
  int? get id => _id;

  void setToken(String? token) {
    _token = token;
    print('Token guardado: $token');
    notifyListeners(); // Notificar a los oyentes sobre el cambio
  }

  void setId(int? id) {
    _id = id;
    print('id guardado: $id');
    notifyListeners(); // Notificar a los oyentes sobre el cambio
  }


  void setCargo(String? cargo) {
    _cargo = cargo;
    notifyListeners();
  }
  Future<void> fetchData() async {

  }

  void logout() {
    // Limpiar los datos, por ejemplo, establecer el usuario actual como null
    // y cualquier otro dato relacionado con la sesión
    setToken(null);
    setId(null);
    setCargo(null);


    // Notificar a los escuchadores (si los tienes) que los datos han cambiado
    notifyListeners();
  }

  bool isUserAllowedToLogin(String cargo) {

    return cargo != 'Cliente';
  }
}