import 'package:flutter/material.dart';
import 'package:NivelesClub/models/pedBodega_model.dart';
import 'package:NivelesClub/pages/pedidoBodega/pedidoB_item.dart';
import 'package:NivelesClub/services/api_pedidoB.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class PedidoBList extends StatefulWidget {
  const PedidoBList({Key? key}) : super(key: key);

  @override
  _PedidoBListState createState() => _PedidoBListState();
}

class _PedidoBListState extends State<PedidoBList> {
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
        child: loadPedidoB(),
      ),
    );
  }

  Widget loadPedidoB() {
    return FutureBuilder(
      future: APIPedidoB.getPedidoB(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<PedidoBModel>?> model,
          ) {
        if (model.hasData) {
          return pedidoBList(model.data);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget pedidoBList(pedidoB) {
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
                itemCount: pedidoB.length,
                itemBuilder: (context, index) {
                  return PedidoBItem(
                    model: pedidoB[index],
                    onDelete: (PedidoBModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIPedidoB.deletePedidoB(model.id_Orden_Bodega).then(
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