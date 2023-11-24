// -*- coding: utf-8 -*-
import 'package:flutter/material.dart';
import '../../models/pedMesero_model.dart';
import 'package:appflutter/models/producto_model.dart';

import 'package:appflutter/services/api_producto.dart';

class PedidoMItem extends StatelessWidget {
  final PedidoModel? model;
  final ProductoModel? modelP;
  final Function? onDelete;


  PedidoMItem({
    Key? key,
    this.model,
    this.modelP,
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
                "\nProducto",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              FutureBuilder<List<ProductoModel>?>(
                future: APIProducto.getProductos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Encontrar el producto que tiene el mismo ID que el ID del producto que se muestra en la tarjeta.
                    ProductoModel? product = snapshot.data!.firstWhere((product) => product.id_Articulos == model!.articulo_Id);

                    // Si el producto se encontró, mostrar su nombre en la tarjeta.
                    if (product != null) {
                      return Text(
                          capitalizeWords(product.nombre_Producto.toString()),
                        style: TextStyle(color: Colors.black),
                      );
                    } else {
                      // Si el producto no se encontró, mostrar un mensaje de error.
                      return Text("Error: Producto no encontrado.");
                    }
                  } else {
                    return Text("Cargando...");
                  }
                },
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

