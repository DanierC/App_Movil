import 'package:flutter/material.dart';
import 'package:NivelesClub/models/reservar_model.dart';
import 'package:NivelesClub/pages/reserva/reserva_item.dart';
import 'package:NivelesClub/services/api_reserva.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class ReservaList extends StatefulWidget {
  const ReservaList({Key? key}) : super(key: key);

  @override
  _ReservaListState createState() => _ReservaListState();
}

class _ReservaListState extends State<ReservaList> {
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        key: UniqueKey(),
        child: RefreshIndicator(
          onRefresh: () async {
            await _refreshList();
          },
          child: loadReserva(),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    print("Refreshing list...");
    setState(() {
      isApiCallProcess = true;
    });

    try {
      List<ReservaModel>? updatedReserva = await APIReserva.getReserva();
      if (updatedReserva != null) {
        setState(() {
          isApiCallProcess = false;
        });
      }
    } catch (error) {
      setState(() {
        isApiCallProcess = false;
      });
    }
  }

  Widget loadReserva() {
    return FutureBuilder(
      future: APIReserva.getReserva(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<ReservaModel>?> model,
          ) {
        if (model.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (model.hasError) {
          return const Center(
            child: Text('Error al cargar reservas'),
          );
        } else if (!model.hasData || model.data!.isEmpty) {
          return const Center(
            child: Text('No hay reservas disponibles'),
          );
        } else {
          return reservaList(model.data);
        }
      },
    );
  }

  Widget reservaList(reserva) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: reserva.length,
                itemBuilder: (context, index) {
                  return ReservaItem(
                    model: reserva[index],
                    onDelete: (ReservaModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIReserva.deleteReserva(model.id_Reservas).then(
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
