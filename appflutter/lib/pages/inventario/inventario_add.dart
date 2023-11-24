

import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_model.dart';
import 'package:appflutter/models/inventario_model.dart';
import 'package:appflutter/services/api_inventario.dart';
import 'package:appflutter/services/api_producto.dart';

import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../config.dart';

class InventarioAdd extends StatefulWidget {
  const InventarioAdd({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InventarioAddState createState() => _InventarioAddState();
}

class _InventarioAddState extends State<InventarioAdd> {
  List<ProductoModel> listaDeProductos = [];

  InventarioModel? inventarioModel;
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
            child: inventarioForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    inventarioModel = InventarioModel();
    inventarioModel?.cantidad_Final = 0;
    inventarioModel?.pedidos_Bodega = 0;
    inventarioModel?.cantidad_TotalVenta = 0;
    inventarioModel?.cantidad_TotalVenta = 0;
    inventarioModel?.total_Venta = 0;

    APIProducto.getProductos().then((productos) {
      setState(() {
        listaDeProductos = productos ?? [];
      });
    });
    Future.delayed(Duration.zero, () {
      if (ModalRoute
          .of(context)
          ?.settings
          .arguments != null) {
        final Map arguments = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        inventarioModel = arguments['model'];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Widget inventarioForm() {
    String capitalizeWords(String text) {
      List<String> words = text.split(' ');
      words = words.map((word) => word[0].toUpperCase() + word.substring(1))
          .toList();
      return words.join(' ');
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "\nProducto",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                DropdownButton<int>(
                  value: inventarioModel!.id_Articulos_Inventario,
                  items: listaDeProductos.map((ProductoModel producto) {
                    return DropdownMenuItem<int>(
                      value: producto.id_Articulos ?? 0,
                      child: Text(capitalizeWords(
                          producto.nombre_Producto ?? "")),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      inventarioModel!.id_Articulos_Inventario = value;
                    });
                  },
                ),
              ],
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
              "Cantidad Inicial",
              "Cantidad Inicial",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'La cantidad no puede ser vacio o null ';
                }
                if (double.tryParse(onValidateVal) == null) {
                  return 'Insertar un numero valido con dos decimales ';
                }

                return null;
              },
                  (onSavedVal) =>
              {
                if (double.tryParse(onSavedVal) != null) {
                  inventarioModel!.cantidad_Inicial = int.parse(onSavedVal),
                } else
                  {
                    // Manejar el caso en el que la entrada no es un número válido.
                  }
              },
              initialValue: inventarioModel!.cantidad_Inicial == null
                  ? ""
                  : inventarioModel!.cantidad_Inicial.toString(),
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,

            ),
          ),

          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Añadir Inventario",
                  () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });

                  APIInventario.saveInventario(
                    inventarioModel!,
                    isEditMode,
                    isImageSelected,
                  ).then(
                        (response) {
                      setState(() {
                        isApiCallProcess = false;
                      });

                      if (response) {
                        Navigator.of(context).pop(true);
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
