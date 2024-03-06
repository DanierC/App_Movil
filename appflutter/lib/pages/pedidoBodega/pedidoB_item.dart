// -*- coding: utf-8 -*-
import 'package:flutter/material.dart';
import '../../models/pedBodega_model.dart';
import 'package:NivelesClub/models/producto_model.dart';
import 'package:intl/intl.dart';
import 'package:NivelesClub/services/api_producto.dart';
import 'package:NivelesClub/models/usuarios_model.dart';
import 'package:NivelesClub/services/api_usuarios.dart';

class PedidoBItem extends StatelessWidget {
  final PedidoBModel? model;
  final ProductoModel? modelPB;
  final Function? onDelete;
  DateTime utcToLocal(DateTime utc) {
    return utc.toLocal();
  }
  // ignore: prefer_const_constructors_in_immutables
  PedidoBItem({
    Key? key,
    this.model,
    this.modelPB,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: cartItem(context),
      ),
    );
  }

  Widget cartItem(context) {

    String capitalizeWords(String text) {
      List<String> words = text.split(' ');
      words = words.map((word) => word[0].toUpperCase() + word.substring(1)).toList();
      return words.join(' ');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Realizado Por:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              FutureBuilder<List<Usuario2Model>?>(
                future: APIUsuario2.getUsuario2(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Encontrar el producto que tiene el mismo ID que el ID del producto que se muestra en la tarjeta.
                    Usuario2Model? usuario = snapshot.data!.firstWhere((usuario) => usuario.id == model!.id_Usuario);

                    // Si el producto se encontró, mostrar su nombre en la tarjeta.
                    if (usuario != null) {
                      return Text(
                        capitalizeWords(usuario.name.toString()),
                        style: TextStyle(color: Colors.black),
                      );
                    } else {
                      // Si el producto no se encontró, mostrar un mensaje de error.
                      return Text("Error: Usuario no encontrado.");
                    }
                  } else {
                    return Text("Cargando...");
                  }
                },
              ),
              Text(
                "\nCantidad",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.cantidad.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Cantidad Total",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.cantidad_Total.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "\nTipo de cantidad",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.tipo_Cantidad.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "\nProducto",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              FutureBuilder<List<ProductoModel>?>(
                future: APIProducto.getProductos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ProductoModel? producto =
                    snapshot.data!.firstWhere((producto) => producto.id_Articulos == model!.articulos_Bodega_id);

                    if (producto != null) {
                      return Text(
                          capitalizeWords(producto.nombre_Producto.toString()),
                        style: TextStyle(color: Colors.black),
                      );
                    } else {
                      return Text("Error: Producto no encontrado.");
                    }
                  } else {
                    return Text("Cargando...");
                  }
                },
              ),
              Text(
                "\nEstado de pedido",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.estado_Pedido.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "\nFecha",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                DateFormat("dd/MM/yyyy HH:mm").format(utcToLocal(model!.fecha ?? DateTime.now())),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [GestureDetector(
              child: const Icon(Icons.edit),
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/edit-pedB',
                  arguments: {
                    'model': model,
                  },
                );
              },
            ),
              GestureDetector(
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onTap: () {
                  onDelete!(model);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

