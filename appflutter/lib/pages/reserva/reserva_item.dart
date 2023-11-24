// -*- coding: utf-8 -*-
import 'package:flutter/material.dart';
import '../../models/reservar_model.dart';

import 'package:intl/intl.dart';


class ReservaItem extends StatelessWidget {
  final ReservaModel? model;

  final Function? onDelete;
  DateTime utcToLocal(DateTime utc) {
    return utc.toLocal();
  }

  ReservaItem({
    Key? key,
    this.model,

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
                model!.cantidad_Personas.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "\nUbicación De La Mesa",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.ubicacion_Mesa.toString(),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "\nEstado De La Reserva",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                model!.estado_Reserva.toString(),
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
                child: const Icon(Icons.edit),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/edit-reserva',
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

