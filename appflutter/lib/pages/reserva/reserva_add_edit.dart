import 'dart:io';

import 'package:flutter/material.dart';
import 'package:appflutter/models/reservar_model.dart';
import 'package:appflutter/services/api_reserva.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../config.dart';

class ReservaAddEdit extends StatefulWidget {
  const ReservaAddEdit({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReservaAddEditState createState() => _ReservaAddEditState();
}

class _ReservaAddEditState extends State<ReservaAddEdit> {
  ReservaModel? reservaModel;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  List<Object> images = [];
  bool isEditMode = false;
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Formulario Reserva'),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: reservaForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    reservaModel = ReservaModel();

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        reservaModel = arguments['model'];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Map<String, List<String>> opciones = ReservaModel().getChoices();

  Widget reservaForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: DropdownButton<String>(
              value: reservaModel!.ubicacion_Mesa,
              items: opciones['ubicacion_Mesa']?.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              )).toList(),
              onChanged: (String? value) {
                setState(() {
                  reservaModel!.ubicacion_Mesa = value;
                });
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: DropdownButton<String>(
              value: reservaModel!.estado_Reserva,
              items: opciones['estado_Reserva']?.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              )).toList(),
              onChanged: (String? value) {
                setState(() {
                  reservaModel!.estado_Reserva = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Save",
                  () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });

                  APIReserva.saveReserva(
                    reservaModel!,
                    isEditMode,
                    isImageSelected,
                  ).then(
                        (response) {
                      setState(() {
                        isApiCallProcess = false;
                      });

                      if (response) {
                        Navigator.pop(context);
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Error occur",
                          "OK",
                              () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                  );
                }
              },
              btnColor: HexColor("283B71"),
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }



  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}