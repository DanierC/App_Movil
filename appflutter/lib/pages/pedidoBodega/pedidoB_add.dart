import 'dart:io';

import 'package:flutter/material.dart';
import 'package:NivelesClub/models/producto_model.dart';
import 'package:NivelesClub/models/pedBodega_model.dart';
import 'package:NivelesClub/services/api_pedidoB.dart';
import 'package:NivelesClub/services/api_producto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../AuthProvider.dart';
import '../../config.dart';

class PedidoBAdd extends StatefulWidget {
  const PedidoBAdd({Key? key}) : super(key: key);

  @override
  _PedidoBAddState createState() => _PedidoBAddState();
}

class _PedidoBAddState extends State<PedidoBAdd> {
  List<ProductoModel> listaDeProductos = [];
  int getFactorCantidad(String tipoCantidad) {
    switch (tipoCantidad) {
      case "Unidad":
        return 1;
      case "Decena":
        return 10;
      case "Docena":
        return 12;
      case "PacaX20":
        return 20;
      case "PacaX24":
        return 24;
      default:
        return 1;
    }
  }
  PedidoBModel? pedidoModel;
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
            child: pedidoBForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pedidoModel = PedidoBModel();
    pedidoModel?.estado_Pedido = 'Pendiente';

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
  Map<String, List<String>> opciones = PedidoBModel().getChoices();
  Widget pedidoBForm() {
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
                  return 'Insertar un numero valido';
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
            child: Column(
              children: [
              Text(
              "\nProducto",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            DropdownButton<int>(
              value: pedidoModel!.articulos_Bodega_id,
              items: listaDeProductos.map((ProductoModel producto) {
                return DropdownMenuItem<int>(
                  value: producto.id_Articulos ?? 0,
                  child: Text(capitalizeWords(producto.nombre_Producto ?? "")),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  pedidoModel!.articulos_Bodega_id = value;
                });
              },
            ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child:
            Column(
              children: [
              Text(
              "\nTipo de Cantidad",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),DropdownButton<String>(
              value: pedidoModel!.tipo_Cantidad,
              items: opciones['tipo_Cantidad']?.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              )).toList(),
              onChanged: (String? value) {
                setState(() {
                  pedidoModel!.tipo_Cantidad = value;
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
                  //print(productoModel!.toJson());

                  setState(() {
                    isApiCallProcess = true;
                  });
                  AuthProvider authProvider = AuthProvider();
                  int? idUsuario = authProvider.id;
                  pedidoModel!.id_Usuario = idUsuario;
                  APIPedidoB.savePedidoB(
                    pedidoModel!,
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
      pedidoModel?.cantidad_Total = (pedidoModel?.cantidad ?? 0) * getFactorCantidad(pedidoModel?.tipo_Cantidad ?? "");
      return true;
    }
    return false;
  }


  }

  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
