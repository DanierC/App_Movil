import 'dart:io';
import 'package:appflutter/usuario.dart';
import 'package:appflutter/pages/registrar/registrar_list.dart';
import 'package:appflutter/pages/reserva/reserva_add_edit.dart';
import 'package:flutter/material.dart';
import 'package:appflutter/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:appflutter/main.dart';
import 'package:appflutter/pages/producto/producto_list.dart';
import 'package:appflutter/pages/evento/evento_list.dart';
import 'package:appflutter/pages/registrar/registrar_add_edit.dart';
import 'package:appflutter/pages/registrar/registrar_item.dart';
import 'package:appflutter/pages/pedidoMesero/pedidoM_add_edit.dart';
import 'package:appflutter/pages/pedidoMesero/pedidoM_list.dart';
import 'package:appflutter/pages/pedidoBodega/pedidoB_edit.dart';
import 'package:appflutter/pages/pedidoBodega/pedidoB_add.dart';
import 'package:appflutter/pages/pedidoBodega/pedidoB_list.dart';
import 'package:appflutter/pages/pedidoBodega/pedidoB_list2.dart';
import 'package:appflutter/pages/musica/musica_list.dart';
import 'package:appflutter/pages/reserva/reserva_list.dart';
import 'package:appflutter/pages/inventario/inventario_list.dart';
/*import 'package:appflutter/pages/reserva/reserva_add_edit.dart';*/
import 'package:appflutter/pages/suge_quejas/sugequejas_list.dart';
import 'package:appflutter/pages/inicio/inicio.dart';

class Menu extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  int _selectDrawerItem = 0;
  getDrawerItemWidget(int pos) {
    final cargo = Provider.of<AuthProvider>(context, listen: false).cargo;

    switch (pos) {
      case 0:
        return const Inicio();
      case 2:
        if (cargo == 'Administrador') {
          return const ProductosList();
        } else {
          return const Center(
            child: Text('No tienes acceso a esta sección'),
          );
        }
      case 3:
        return cargo == 'Administrador' ? const EventoList() : Container();
      case 4:
        return cargo == 'Administrador' ? const UsuarioList() : Container();
      case 5:
        return cargo == 'Mesero' ? const PedidoMAddEdit() : Container();
      case 6:
        return cargo == 'Administrador' ? const PedidoMList() : Container();
      case 7:
        return cargo == 'Administrador' ? const PedidoBList2() : Container();
      case 8:
        return cargo == 'Proveedor' ? const PedidoBList() : Container();
      case 9:
        return cargo == 'Dj' ? const MusicaList() : Container();
      case 10:
        return cargo == 'Administrador' || cargo == 'Mesero' ? const ReservaList() : Container();
      case 11:
        return cargo == 'Administrador' ? const InventarioList() : Container();
      case 12:
        return cargo == 'Administrador' || cargo == 'Mesero' ? const SugeQList() : Container();

    }
  }

  _onSelectItem(int pos) {
    Navigator.of(context).pop();
    setState(() {
      _selectDrawerItem = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cargo = Provider.of<AuthProvider>(context, listen: false).cargo;
    return WillPopScope(
        onWillPop: () async {
      return false;
    },
    child: Scaffold(
    appBar: AppBar(
    title: const Text("Niveles Club"),
    ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const Divider(),const Divider(),
            ListTile(
              title: const Text('Inicio'),
              leading: const Icon(Icons.home),
              selected: (0 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(0);
              },
            ),
            const Divider(),
            if (cargo == 'Administrador') ...[
              ListTile(
                title: const Text('Registrar'),
                leading: const Icon(Icons.person_add),
                selected: (4 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(4);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Administrador') ...[
              ListTile(
                title: const Text('Productos'),
                leading: const Icon(Icons.shopping_basket),
                selected: (2 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(2);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Administrador') ...[
              ListTile(
                title: const Text('Evento'),
                leading: const Icon(Icons.event),
                selected: (3 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(3);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Mesero') ...[
            ListTile(
              title: const Text('Pedir a la Barra'),
              leading: const Icon(Icons.local_bar),
              selected: (5 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(5);
              },
            ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Administrador') ...[
              ListTile(
                title: const Text('Pedido Mesero'),
                leading: const Icon(Icons.assignment),
                selected: (6 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(6);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Administrador') ...[
              ListTile(
                title: const Text('Pedir a la Bodega'),
                leading: const Icon(Icons.local_shipping),
                selected: (7 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(7);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Proveedor') ...[
              ListTile(
                title: const Text('Pedido de Discoteca'),
                leading: const Icon(Icons.local_drink),
                selected: (8 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(8);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Dj') ...[
              ListTile(
                title: const Text('Música'),
                leading: const Icon(Icons.music_note),
                selected: (9 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(9);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Administrador' || cargo == 'Mesero') ...[
              ListTile(
                title: const Text('Reserva'),
                leading: const Icon(Icons.calendar_today),
                selected: (10 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(10);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Administrador') ...[
              ListTile(
                title: const Text('Inventario'),
                leading: const Icon(Icons.inventory),
                selected: (11 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(11);
                },
              ),
            ] else ...[
              Container(),
            ],
            if (cargo == 'Administrador' || cargo == 'Mesero') ...[
              ListTile(
                title: const Text('Sugerencias/Quejas'),
                leading: const Icon(Icons.comment),
                selected: (12 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(12);
                },
              ),
            ] else ...[
              Container(),
            ],
            const Divider(),
            ListTile(
              title: const Text('Cerrar Sesión'),
              leading: const Icon(Icons.touch_app_outlined),
              selected: (3 == _selectDrawerItem),
              onTap: () {
                // Llama al método logout de AuthProvider
                Provider.of<AuthProvider>(context, listen: false).logout();

                // Redirige a la pantalla de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: getDrawerItemWidget(_selectDrawerItem),
    )
    );
  }
}
