// -*- coding: utf-8 -*-
import 'package:flutter/material.dart';
import '../../models/pedBodega_model.dart';
import 'package:appflutter/models/producto_model.dart';
import 'package:intl/intl.dart';
import 'package:appflutter/services/api_producto.dart';

class PedidoBItem2 extends StatelessWidget {
  final PedidoBModel? model;
  final ProductoModel? modelPB;
  final Function? onDelete;
  DateTime utcToLocal(DateTime utc) {
    return utc.toLocal();
  }
  // ignore: prefer_const_constructors_in_immutables
  PedidoBItem2({
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
                "Cantidad",
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
                "\nTipo De Cantidad",
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
                DateFormat("dd/MM/yyyy HH:mm").format(utcToLocal(model!.fecha ?? DateTime.now())),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

