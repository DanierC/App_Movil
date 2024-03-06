// -*- coding: utf-8 -*-
import 'package:flutter/material.dart';
import '../../models/inventario_model.dart';
import 'package:NivelesClub/models/producto_model.dart';
import 'package:intl/intl.dart';
import 'package:NivelesClub/services/api_producto.dart';

class InventarioItem extends StatelessWidget {
  final InventarioModel? model;
  final ProductoModel? modelPB;
  final Function? onDelete;
  DateTime utcToLocal(DateTime utc) {
    return utc.toLocal();
  }

  InventarioItem({
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
                "\nProducto",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              FutureBuilder<List<ProductoModel>?>(
                future: APIProducto.getProductos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ProductoModel? producto =
                    snapshot.data!.firstWhere((producto) => producto.id_Articulos == model!.id_Articulos_Inventario);

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
                "Cantidad Inicial",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.cantidad_Inicial.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Cantidad Final",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.cantidad_Final.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Cantidad pedido bodega",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.pedidos_Bodega.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Cantidad total vendido",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.cantidad_TotalVenta.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Venta total",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.total_Venta.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "\nFecha",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                DateFormat("dd/MM/yyyy").format(utcToLocal(model!.fecha ?? DateTime.now())),
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
            children: [
              GestureDetector(
              child: Icon(
                Icons.edit,
                color: Colors.red,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/add-invent',
                  arguments: {
                    'model': model,
                  },
                );
              },
            ),
              GestureDetector(
              child: const Icon(Icons.edit),
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/edit-invent',
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

