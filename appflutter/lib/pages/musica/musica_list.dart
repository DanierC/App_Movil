import 'package:flutter/material.dart';
import 'package:NivelesClub/models/musica_model.dart';
import 'package:NivelesClub/pages/musica/musica_item.dart';
import 'package:NivelesClub/services/api_musica.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class MusicaList extends StatefulWidget {
  const MusicaList({Key? key}) : super(key: key);

  @override
  _MusicaListState createState() => _MusicaListState();
}

class _MusicaListState extends State<MusicaList> {
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
  }

  Future<List<MusicaModel>?> _getMusica() async {
    return APIMusica.getMusica();
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
            // Llama a tu función de carga de música al hacer pull-to-refresh
            setState(() {
              isApiCallProcess = true;
            });
            await _getMusica();
            setState(() {
              isApiCallProcess = false;
            });
          },
          child: FutureBuilder(
            future: _getMusica(),
            builder: (
                BuildContext context,
                AsyncSnapshot<List<MusicaModel>?> model,
                ) {
              if (model.hasData) {
                return MusicaListView(model.data);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget MusicaListView(List<MusicaModel>? musica) {
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
                itemCount: musica?.length ?? 0,
                itemBuilder: (context, index) {
                  return MusicaItem(
                    model: musica![index],
                    onDelete: (MusicaModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIMusica.deleteMusica(model.id_Musica).then(
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
