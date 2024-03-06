// -*- coding: utf-8 -*-
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:NivelesClub/usuario.dart';
import 'package:NivelesClub/menu.dart';
import 'package:provider/provider.dart';
import 'package:NivelesClub/AuthProvider.dart';
import 'package:NivelesClub/pages/producto/producto_add_edit.dart';
import 'package:NivelesClub/pages/producto/producto_list.dart';
import 'package:NivelesClub/pages/evento/evento_add_edit.dart';
import 'package:NivelesClub/pages/evento/evento_list.dart';
import 'package:NivelesClub/pages/registrar/registrar_add_edit.dart';
import 'package:NivelesClub/pages/registrar/registrar_list.dart';
import 'package:NivelesClub/pages/pedidoMesero/pedidoM_add_edit.dart';
import 'package:NivelesClub/pages/pedidoMesero/pedidoM_list.dart';
import 'package:NivelesClub/pages/pedidoBodega/pedidoB_edit.dart';
import 'package:NivelesClub/pages/pedidoBodega/pedidoB_add.dart';
import 'package:NivelesClub/pages/pedidoBodega/pedidoB_list.dart';
import 'package:NivelesClub/pages/pedidoBodega/pedidoB_list2.dart';
import 'package:NivelesClub/pages/inventario/inventario_edit.dart';
import 'package:NivelesClub/pages/inventario/inventario_add.dart';
import 'package:NivelesClub/pages/inventario/inventario_list.dart';
import 'package:NivelesClub/pages/reserva/reserva_add_edit.dart';
import 'package:NivelesClub/pages/reserva/reserva_list.dart';
import 'package:NivelesClub/pages/suge_quejas/sugequejas_list.dart';
import 'package:NivelesClub/config.dart';

void main() {
  utf8.decoder; // Esto puede no ser necesario en la versión más reciente de Dart/Flutter
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Otros providers si los tienes
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Niveles Club';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Otros providers si los tienes
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _title,
        home: Scaffold(
          appBar: AppBar(title: const Text(_title)),
          body: const MyStatefulWidget(),
        ),
        routes: {

          '/list-producto': (context) => const ProductosList(),
          '/add-producto': (context) => const ProductoAddEdit(),
          '/edit-producto': (context) => const ProductoAddEdit(),
          '/list-evento': (context) => const EventoList(),
          '/add-evento': (context) => const EventoAddEdit(),
          '/edit-evento': (context) => const EventoAddEdit(),
          '/list-regist': (context) => const UsuarioList(),
          '/add-regist': (context) => const RegistrarAddEdit(),
          '/edit-regist': (context) => const RegistrarAddEdit(),
          '/list-pedM': (context) => const PedidoMList(),
          '/add-pedM': (context) => const PedidoMAddEdit(),
          '/edit-pedM': (context) => const PedidoMAddEdit(),
          '/list-pedB': (context) => const PedidoBList(),
          '/list-pedB': (context) => const PedidoBList2(),
          '/add-pedB': (context) => const PedidoBAdd(),
          '/edit-pedB': (context) => const PedidoBEdit(),
          '/list-invent': (context) => const InventarioList(),
          '/add-invent': (context) => const InventarioAdd(),
          '/edit-invent': (context) => const InventarioEdit(),
          '/list-reserva': (context) => const ReservaList(),
          '/edit-reserva': (context) => const ReservaAddEdit(),
          '/list-sugeq': (context) => const SugeQList(),
          '/home': (context) => Menu(),
        },
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cargoController = TextEditingController();
  TextEditingController idController = TextEditingController();

  final urllogin = Uri.http(Config.apiURL, Config.loginAPI);
  final urlobtenertoken = Uri.http(Config.apiURL, Config.obtenertokenAPI);
  final headers = {"Content-Type": "application/json;charset=UTF-8"};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Niveles Club',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Ingresar',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Acceder'),
              onPressed: () {
                login(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> login(BuildContext context) async {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackbar(
          "${nameController.text.isEmpty ? "-Email " : ""} ${passwordController.text.isEmpty ? "- Contraseña " : ""} requerido");
      return;
    }

    final datosdelposibleusuario = {
      "email": nameController.text,
      "password": passwordController.text,
    };

    final res = await http.post(urllogin,
        headers: headers, body: jsonEncode(datosdelposibleusuario));

    if (res.statusCode == 400) {
      showSnackbar("error");
      return;
    }

    if (res.statusCode != 200) {
      showSnackbar("Ups ha habido al obtener usuario y contraseña ");
      return;
    }

    final res2 = await http.post(urlobtenertoken,
        headers: headers, body: jsonEncode(datosdelposibleusuario));

    if (res2.statusCode == 400) {
      showSnackbar("error");
      return;
    }

    if (res2.statusCode != 200) {
      showSnackbar("Ups ha habido al obtener el token ");
      return;
    }

    final data2 = Map.from(jsonDecode(res2.body));
    final token = data2["token"];

    final res3 = await http.post(urllogin,
        headers: headers, body: jsonEncode(datosdelposibleusuario));

    if (res3.statusCode == 400) {
      showSnackbar("error");
      return;
    }

    if (res3.statusCode != 200) {
      showSnackbar("Ups ha habido al obtener el cargo");
      return;
    }

    final data3 = Map.from(jsonDecode(res3.body));
    final cargo = data3["cargo"];
    final id = data3["id"] as int?;

    if (!Provider.of<AuthProvider>(context, listen: false).isUserAllowedToLogin(cargo)) {
      showSnackbar("No estás autorizado para iniciar sesión como Cliente");
      return;
    }

    if (id != null) {
      final user = Usuario(
        email: nameController.text,
        password: passwordController.text,
        id: id,
        cargo: cargo,
        token: token,
      );

      // Resto del código...
    } else {
      // Manejar el caso en que id sea nulo
      // Puede mostrar un mensaje de error o tomar alguna otra acción apropiada
    }

    // Espera a que se reciba la respuesta del servidor antes de guardar los datos de inicio de sesión en el AuthProvider
    await Future.delayed(const Duration(milliseconds: 1000));
    print(cargo);
    print(token);
    print(id);
    // Espera a que se guarden los datos de inicio de sesión antes de cargar el Menu widget
    await Provider.of<AuthProvider>(context, listen: false).fetchData();
    Provider.of<AuthProvider>(context, listen: false).setToken(token);
    Provider.of<AuthProvider>(context, listen: false).setCargo(cargo);
    Provider.of<AuthProvider>(context, listen: false).setId(id);
    Navigator.pushNamed(context, '/home');
  }
}
