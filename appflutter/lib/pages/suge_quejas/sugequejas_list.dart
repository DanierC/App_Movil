import 'package:flutter/material.dart';
import 'package:NivelesClub/models/sugeQuejas_model.dart';
import 'package:NivelesClub/pages/suge_quejas/sugequejas_item.dart';
import 'package:NivelesClub/services/api_sugequejas.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class SugeQList extends StatefulWidget {
  const SugeQList({Key? key}) : super(key: key);

  @override
  _SugeQListState createState() => _SugeQListState();
}

class _SugeQListState extends State<SugeQList> {

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
        child: loadSugeQ(),
      ),
    );
  }

  Widget loadSugeQ() {
    return FutureBuilder(
      future: APISugeQ.getSugeQ(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<SugeQModel>?> model,
          ) {
        if (model.hasData) {
          return sugeqList(model.data);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget sugeqList(sugeq) {
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
                itemCount: sugeq.length,
                itemBuilder: (context, index) {
                  return SugeQItem(
                    model: sugeq[index],
                    onDelete: (SugeQModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APISugeQ.deleteSugeQ(model.id_SugeQuejas).then(
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