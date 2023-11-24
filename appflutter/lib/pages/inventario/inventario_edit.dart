
import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_model.dart';
import 'package:appflutter/models/inventario_model.dart';
import 'package:appflutter/services/api_inventario.dart';
import 'package:appflutter/services/api_producto.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../config.dart';

class InventarioEdit extends StatefulWidget {
  const InventarioEdit({Key? key}) : super(key: key);

  @override
  _InventarioEditState createState() => _InventarioEditState();
}

class _InventarioEditState extends State<InventarioEdit> {
  List<ProductoModel> listaDeProductos = [];
  final _cantidadController = TextEditingController();
  InventarioModel? inventarioModel;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  List<Object> images = [];
  bool isEditMode = false;
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(
        title: const Text('Form Inventario'),
        elevation: 0,
      ),
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
    APIProducto.getProductos().then((productos) {
      setState(() {
        listaDeProductos = productos ?? [];
      });
    });
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        inventarioModel = arguments['model'];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Widget inventarioForm() {
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
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "\nProducto",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
                DropdownButton<int>(
                  value: inventarioModel!.id_Articulos_Inventario,
                  items: listaDeProductos.map((ProductoModel producto) {
                    return DropdownMenuItem<int>(
                      value: producto.id_Articulos ?? 0,
                      child: Text(capitalizeWords(producto.nombre_Producto ?? "")),
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
          Text(
            "\nCantidad Inicial",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              //const Icon(Icons.person),
              "Cantidad inicial",
              "Cantidad inicial",
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
                  inventarioModel!.cantidad_Inicial = int.parse(onSavedVal),
                } else {
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
          Text(
            "\nCantidad Final",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              //const Icon(Icons.person),
              "Cantidad Final",
              "Cantidad Final",
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
                  inventarioModel!.cantidad_Final = int.parse(onSavedVal),
                } else {
                  // Manejar el caso en el que la entrada no es un número válido.
                }
              },
              initialValue: inventarioModel!.cantidad_Final == null
                  ? ""
                  : inventarioModel!.cantidad_Final.toString(),
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Text(
            "\nPedido Bodega",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              //const Icon(Icons.person),
              "Pedido bodega",
              "Pedido bodega",
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
                  inventarioModel!.pedidos_Bodega = int.parse(onSavedVal),
                } else {
                  // Manejar el caso en el que la entrada no es un número válido.
                }
              },
              initialValue: inventarioModel!.pedidos_Bodega == null
                  ? ""
                  : inventarioModel!.pedidos_Bodega.toString(),
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
              "Hacer Inventario",
                  () async {
                if (await validateAndSave()) {
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

  Future<bool> validateAndSave() async {
    final form = globalFormKey.currentState;

    if (form?.validate() == true && inventarioModel?.cantidad_Inicial != _cantidadController.text) {
      form?.save();
      inventarioModel?.cantidad_TotalVenta = (inventarioModel?.cantidad_Inicial ?? 0) + (inventarioModel?.pedidos_Bodega ?? 0) - (inventarioModel?.cantidad_Final ?? 0);

      List<ProductoModel>? productos = await APIProducto.getProductos();
      ProductoModel? producto = productos?.firstWhere((producto) => producto.id_Articulos == inventarioModel?.id_Articulos_Inventario);

      if (producto != null) {
        // La variable `producto` no es `null`, por lo que podemos realizar la operación
        inventarioModel?.total_Venta = (inventarioModel?.cantidad_TotalVenta ?? 0) * (producto?.precio_Producto ?? 0);
        return true;
      }
    }
    return false;
  }


  }

  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
