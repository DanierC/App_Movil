import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Puedes personalizar el mensaje de bienvenida aquí
    String mensajeBienvenida = '¡Bienvenido!';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mensajeBienvenida,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Puedes agregar más widgets aquí según sea necesario
        ],
      ),
    );
  }
}


