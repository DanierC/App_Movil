import 'dart:io';

import 'package:flutter/material.dart';
import 'package:appflutter/models/evento_model.dart';
import 'package:appflutter/services/api_evento.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../config.dart';

class EventoAddEdit extends StatefulWidget {
  const EventoAddEdit({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventoAddEditState createState() => _EventoAddEditState();
}

class _EventoAddEditState extends State<EventoAddEdit> {
  EventoModel? eventoModel;
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
          title: const Text('Formulario Evento'),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: eventoForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    eventoModel = EventoModel();

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        eventoModel = arguments['model'];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Widget eventoForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              //const Icon(Icons.person),
              "Precio Palco",
              "Precio Palco",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'El precio no puede ser vacio o null ';
                }
                if (double.tryParse(onValidateVal) == null) {
                  return 'Insertar un numero valido con dos decimales ';
                }

                return null;
              },
                  (onSavedVal) => {
                    if (double.tryParse(onSavedVal) != null) {
                      eventoModel!.precio_Palco = int.parse(onSavedVal),
                    } else {
                      // Manejar el caso en el que la entrada no es un número válido.
                    }
              },
              initialValue: eventoModel!.precio_Palco == null
                  ? ""
                  : eventoModel!.precio_Palco.toString(),
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
              suffixIcon: const Icon(Icons.monetization_on),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              //const Icon(Icons.person),
              "Cantidad de Personas",
              "Cantidad de Personas",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'La cantidad no puede ser vacio o null ';
                }
                if (double.tryParse(onValidateVal) == null) {
                  return 'Insertar un numero valido con dos decimales ';
                }

                return null;
              },
                  (onSavedVal) => {
                    if (double.tryParse(onSavedVal) != null) {
                      eventoModel!.cantidad_Personas= int.parse(onSavedVal),
                    } else {
                      // Manejar el caso en el que la entrada no es un número válido.
                    }
              },
              initialValue: eventoModel!.cantidad_Personas == null
                  ? ""
                  : eventoModel!.cantidad_Personas.toString(),
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Guardar Evento",
                  () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });

                  APIEvento.saveEvento(
                    eventoModel!,
                    isEditMode,
                    isImageSelected,
                  ).then(
                        (response) {
                      setState(() {
                        isApiCallProcess = false;
                      });

                      if (response) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/list-evento',
                              (route) => false,
                        );
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


  }

  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
