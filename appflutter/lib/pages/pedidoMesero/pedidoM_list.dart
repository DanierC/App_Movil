import 'package:flutter/material.dart';
import 'package:NivelesClub/models/pedMesero_model.dart';
import 'package:NivelesClub/pages/pedidoMesero/pedidoM_item.dart';
import 'package:NivelesClub/services/api_pedidoM.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class PedidoMList extends StatefulWidget {
  const PedidoMList({Key? key}) : super(key: key);

  @override
  _PedidoMListState createState() => _PedidoMListState();
}

class _PedidoMListState extends State<PedidoMList> {
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
          child: loadPedidoM(),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    setState(() {
      isApiCallProcess = true;
    });

    try {
      List<PedidoModel>? updatedPedidoM = await APIPedidoM.getPedidoM();
      if (updatedPedidoM != null) {
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

  Widget loadPedidoM() {
    return FutureBuilder(
      future: APIPedidoM.getPedidoM(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<PedidoModel>?> model,
          ) {
        if (model.hasData) {
          return pedidoMList(model.data);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget pedidoMList(pedidoM) {
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
                itemCount: pedidoM.length,
                itemBuilder: (context, index) {
                  return PedidoMItem(
                    model: pedidoM[index],
                    onDelete: (PedidoModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIPedidoM.deletePedidoM(model.id_Orden).then(
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