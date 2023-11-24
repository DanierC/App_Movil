// -*- coding: utf-8 -*-
import 'package:flutter/material.dart';
import '../../models/musica_model.dart';
import 'package:intl/intl.dart';


class MusicaItem extends StatelessWidget {
  final MusicaModel? model;
  final Function? onDelete;

  MusicaItem({
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
                "Canción",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                capitalizeWords(model!.cancion.toString()),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "\nGénero",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                capitalizeWords(model!.genero.toString()),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Nombre Del Artista",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                capitalizeWords(model!.nombre_Artista.toString()),
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

