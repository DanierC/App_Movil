import 'dart:io';

import 'package:flutter/material.dart';
import 'package:NivelesClub/models/pedMesero_model.dart';
import 'package:NivelesClub/models/producto_model.dart';
import 'package:NivelesClub/services/api_pedidoM.dart';
import 'package:NivelesClub/services/api_producto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../AuthProvider.dart';
import '../../config.dart';

class PedidoMAddEdit extends StatefulWidget {
  const PedidoMAddEdit({Key? key}) : super(key: key);

  @override
  _PedidoMAddEditState createState() => _PedidoMAddEditState();
}

class _PedidoMAddEditState extends State<PedidoMAddEdit> {
  List<ProductoModel> listaDeProductos = [];

  PedidoModel? pedidoModel;
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
            child: pedidoMForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pedidoModel = PedidoModel();
    APIProducto.getProductos().then((productos) {
      setState(() {
        listaDeProductos = productos ?? [];
      });
    });
    AuthProvider authProvider = AuthProvider();
    pedidoModel!.id_Usuario = authProvider.id; // Asigna el id del usuario
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        pedidoModel = arguments['model'];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Widget pedidoMForm() {
    String capitalizeWords(String text) {
      List<String> words = text.split(' ');
      words = words.map((word) => word[0].toUpperCase() + word.substring(1)).toList();
      return words.join(' ');
    }
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
              "Cantidad",
              "Cantidad",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'La cantidad no puede ser vacio o null ';
                }
                if (double.tryParse(onValidateVal) == null) {
                  return 'Insertar un numero valido.';
                }

                return null;
              },
                  (onSavedVal) => {
                    if (double.tryParse(onSavedVal) != null) {
                      pedidoModel!.cantidad = int.parse(onSavedVal),
                    } else {
                      // Manejar el caso en el que la entrada no es un número válido.
                    }
              },
              initialValue: pedidoModel!.cantidad == null
                  ? ""
                  : pedidoModel!.cantidad.toString(),
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child:Column(
              children: [
              Text(
              "\nProducto",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            DropdownButton<int>(
              value: pedidoModel!.articulo_Id,
              items: listaDeProductos.map((ProductoModel producto) {
                return DropdownMenuItem<int>(
                  value: producto.id_Articulos ?? 0,
                  child: Text(capitalizeWords(producto.nombre_Producto ?? "")),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  pedidoModel!.articulo_Id = value;
                });
              },
            ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Hacer Pedido",
                  () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });
                  AuthProvider authProvider = AuthProvider();
                  int? idUsuario = authProvider.id;
                  pedidoModel!.id_Usuario = idUsuario;
                  APIPedidoM.savePedidoM(
                    pedidoModel!,
                    isEditMode,
                    isImageSelected,
                  ).then(
                        (response) {
                      setState(() {
                        isApiCallProcess = false;
                      });

                      if (response) {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Pedido Realizado Exitosamente",
                          "OK",
                              () {
                                Navigator.of(context, rootNavigator: true).pop();
                          },
                        );
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Error occur",
                          "OK",
                              () {
                                Navigator.of(context, rootNavigator: true).pop();
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