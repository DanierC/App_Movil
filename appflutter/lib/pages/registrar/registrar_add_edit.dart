import 'dart:io';

import 'package:flutter/material.dart';
import 'package:NivelesClub/models/registrar_model.dart';
import 'package:NivelesClub/services/api_registrar.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter/services.dart';

import '../../config.dart';

class RegistrarAddEdit extends StatefulWidget {
  const RegistrarAddEdit({Key? key}) : super(key: key);

  @override
  _RegistrarAddEditState createState() => _RegistrarAddEditState();
}

class _RegistrarAddEditState extends State<RegistrarAddEdit> {
  UsuarioModel? usuarioModel;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  List<Object> images = [];
  bool isEditMode = false;
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: registrarForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    usuarioModel = UsuarioModel();

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        usuarioModel = arguments['model'];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Map<String, List<String>> opciones = UsuarioModel().getChoices();

  Widget registrarForm() {
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
              "Email",
              "Email",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'El email del usuario no puede ser vacio o nulo';
                }

                return null;
              },
                  (onSavedVal) => {
                usuarioModel!.email = onSavedVal,
              },
              initialValue: usuarioModel!.email ?? "",
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              "Password",
              "Password",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'La contraseña no puede ser vacía o nula';
                }

                // Verificar que la contraseña cumple con los criterios
                if (!_isPasswordValid(onValidateVal)) {
                  return 'La contraseña debe tener más de 8 caracteres, \n al menos 1 número, '
                      '1 letra mayúscula, \n1 letra minúscula y 1 caracter especial';
                }

                return null;
              },
                  (onSavedVal) => {
                usuarioModel!.password = onSavedVal,
              },
              initialValue: usuarioModel!.password ?? "",
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cargo:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              DropdownButton<String>(
                value: usuarioModel!.cargo,
                items: opciones['cargo']?.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                )).toList(),
                onChanged: (String? value) {
                  setState(() {
                    usuarioModel!.cargo = value;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              "Nombre",
              "Nombre",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'El nombre del usuario no puede ser vacio o nulo';
                }

                return null;
              },
                  (onSavedVal) => {
                usuarioModel!.name = onSavedVal,
              },
              initialValue: usuarioModel!.name ?? "",
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              "Apellido",
              "Apellido",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'El apellido del usuario no puede ser vacio o nulo';
                }

                return null;
              },
                  (onSavedVal) => {
                usuarioModel!.apellido_Usuario = onSavedVal,
              },
              initialValue: usuarioModel!.apellido_Usuario ?? "",
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Género:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: usuarioModel!.genero_Usuario,
                items: opciones['genero_Usuario']?.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                )).toList(),
                onChanged: (String? value) {
                  setState(() {
                    usuarioModel!.genero_Usuario = value;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              "Cédula",
              "Cédula",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'La cédula no puede ser vacía o nula';
                }

                if (!RegExp(r'^[0-9]+$').hasMatch(onValidateVal)) {
                  return 'Solo se pueden ingresar números';
                }
              },
                  (onSavedVal) => usuarioModel!.cedula = onSavedVal,
              initialValue: usuarioModel!.cedula ?? "",
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,

              "Telefono",
              "Telefono",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'El telefono no puede ser vacio o nulo';
                }

                if (!RegExp(r'^[0-9]+$').hasMatch(onValidateVal)) {
                  return 'Solo se pueden ingresar números';
                }
              },
                  (onSavedVal) => {
                usuarioModel!.telefono = onSavedVal,
              },
              initialValue: usuarioModel!.telefono ?? "",
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Center(
            child: FormHelper.submitButton(
              "Guardar",
                  () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });

                  APIRegistrar.saveRegistrar(
                    usuarioModel!,
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



  }

  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
  bool _isPasswordValid(String password) {
    // Utilizar expresiones regulares para verificar la complejidad de la contraseña
    RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]).{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }
