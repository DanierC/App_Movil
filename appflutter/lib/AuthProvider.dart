import 'package:flutter/foundation.dart';
import 'package:appflutter/usuario.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _cargo;
  String? get token => _token;
  Usuario? currentUser;

  String? get cargo => _cargo;

  void setToken(String? token) {
    _token = token;
    notifyListeners();
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
    currentUser = null;

    // Notificar a los escuchadores (si los tienes) que los datos han cambiado
    notifyListeners();
  }
}