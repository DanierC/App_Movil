import 'package:flutter/material.dart';
import 'package:NivelesClub/models/evento_model.dart';
import 'package:NivelesClub/pages/evento/evento_item.dart';
import 'package:NivelesClub/services/api_evento.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class EventoList extends StatefulWidget {
  const EventoList({Key? key}) : super(key: key);

  @override
  _EventoListState createState() => _EventoListState();
}

class _EventoListState extends State<EventoList> {
  bool isApiCallProcess = false;
  List<EventoModel>? _eventos;

  @override
  void initState() {
    super.initState();
    _loadEventos();
  }

  Future<void> _loadEventos() async {
    setState(() {
      isApiCallProcess = true;
    });

    try {
      List<EventoModel>? eventos = await APIEvento.getEvento();
      if (eventos != null) {
        setState(() {
          _eventos = eventos;
          isApiCallProcess = false;
        });
      }
    } catch (error) {
      setState(() {
        isApiCallProcess = false;
      });
      // Manejar errores si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        key: UniqueKey(),
        child: Column(
          children: [
            SizedBox(height: 20), // Espacio adicional
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/add-evento',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Adicionar Evento',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                SizedBox(width: 20), // Espacio adicional
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/home',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Menú',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
              child: loadEvento(),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadEvento() {
    return FutureBuilder(
      future: APIEvento.getEvento(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<EventoModel>?> model,
          ) {
        if (model.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (model.hasError) {
          return Center(
            child: Text('Error al cargar los datos'),
          );
        } else {
          return eventoList(model.data!);
        }
      },
    );
  }

  Widget eventoList(List<EventoModel> eventos) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (eventos.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                return EventoItem(
                  model: eventos[index],
                  onDelete: (EventoModel model) {
                    _deleteEvento(model);
                  },
                );
              },
            ),
          if (eventos.isEmpty)
            const Center(
              child: Text('No hay eventos disponibles'),
            ),
        ],
      ),
    );
  }

  void _deleteEvento(EventoModel model) async {
    setState(() {
      isApiCallProcess = true;
    });

    try {
      await APIEvento.deleteEvento(model.id_Foto);
      await _loadEventos();
    } catch (error) {
      setState(() {
        isApiCallProcess = false;
      });
      // Manejar errores si es necesario
    }
  }
}
