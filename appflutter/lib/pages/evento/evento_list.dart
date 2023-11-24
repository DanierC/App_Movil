import 'package:flutter/material.dart';
import 'package:appflutter/models/evento_model.dart';
import 'package:appflutter/pages/evento/evento_item.dart';
import 'package:appflutter/services/api_evento.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class EventoList extends StatefulWidget {
  const EventoList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventoListState createState() => _EventoListState();
}

class _EventoListState extends State<EventoList> {
  // List<ProductModel> products = List<ProductModel>.empty(growable: true);
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('Django - CRUD'),
        elevation: 0,
      ),*/
      backgroundColor: Colors.grey[200],
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        key: UniqueKey(),
        child: loadEvento(),
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
        if (model.hasData) {
          return eventoList(model.data);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget eventoList(evento) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                // ignore: sort_child_properties_last
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
                              vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: const Text(
                        'Adicionar Evento',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/home',
                        );
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => Home()),                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: const Text(
                        'Menú',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),

              //Navigator.pushNamed(context,'/add-product',);
              //Add Product
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: evento.length,
                itemBuilder: (context, index) {
                  return EventoItem(
                    model: evento[index],
                    onDelete: (EventoModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIEvento.deleteEvento(model.id_Foto).then(
                            (response) {
                          setState(() {
                            isApiCallProcess = false;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}