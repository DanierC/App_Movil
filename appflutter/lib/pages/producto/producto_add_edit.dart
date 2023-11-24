import 'dart:io';

import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_model.dart';
import 'package:appflutter/services/api_producto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../config.dart';

class ProductoAddEdit extends StatefulWidget {
  const ProductoAddEdit({Key? key}) : super(key: key);

  @override
  _ProductoAddEditState createState() => _ProductoAddEditState();
}

class _ProductoAddEditState extends State<ProductoAddEdit> {
  ProductoModel? productoModel;
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
          title: const Text('Formulario Producto'),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: productoForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    productoModel = ProductoModel();

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        productoModel = arguments['model'];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Widget productoForm() {
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
              "Nombre Producto",
              "Nombre Producto",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'El nombre del producto no puede ser vacio o nulo';
                }

                return null;
              },
                  (onSavedVal) => {
                productoModel!.nombre_Producto = onSavedVal,
              },
              initialValue: productoModel!.nombre_Producto ?? "",
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
              "Precio Producto",
              "Precio Producto",
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
                      productoModel!.precio_Producto = int.parse(onSavedVal),
                    } else {
                      // Manejar el caso en el que la entrada no es un número válido.
                    }
              },
              initialValue: productoModel!.precio_Producto == null
                  ? ""
                  : productoModel!.precio_Producto.toString(),
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
              "Costo Producto",
              "Costo Producto",
                  (onValidateVal) {
                if (onValidateVal == null || onValidateVal.isEmpty) {
                  return 'El costo no puede ser vacio o null ';
                }
                if (double.tryParse(onValidateVal) == null) {
                  return 'Insertar un numero valido con dos decimales ';
                }

                return null;
              },
                  (onSavedVal) => {
                    if (double.tryParse(onSavedVal) != null) {
                      productoModel!.costo_Producto = int.parse(onSavedVal),
                    } else {
                      // Manejar el caso en el que la entrada no es un número válido.
                    }
              },
              initialValue: productoModel!.costo_Producto == null
                  ? ""
                  : productoModel!.costo_Producto.toString(),
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
          picPicker(
            isImageSelected,
            productoModel!.imagen_Producto ?? "",
                (file) => {
              setState(
                    () {
                  productoModel!.imagen_Producto = file.path;
                  isImageSelected = true;
                },
              )
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Guardar Producto",
                  () {
                if (validateAndSave()) {

                  setState(() {
                    isApiCallProcess = true;
                  });

                  APIProducto.saveProducto(
                    productoModel!,
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

  static Widget picPicker(
      bool isImageSelected,
      String fileName,
      Function onFilePicked,
      ) {
    Future<XFile?> imageFile;
    ImagePicker picker = ImagePicker();

    return Column(
      children: [
        fileName.isNotEmpty
            ? isImageSelected
            ? Image.file(
          File(fileName),
          width: 300,
          height: 300,
        )
            : SizedBox(
          child: Image.network(
            fileName,
            width: 200,
            height: 200,
            fit: BoxFit.scaleDown,
          ),
        )
            : SizedBox(
          child: Image.network(
            "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png",
            width: 200,
            height: 200,
            fit: BoxFit.scaleDown,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.image, size: 35.0),
                onPressed: () {
                  imageFile = picker.pickImage(source: ImageSource.gallery);
                  imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: IconButton(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                icon: const Icon(Icons.camera, size: 35.0),
                onPressed: () {
                  imageFile = picker.pickImage(source: ImageSource.camera);
                  imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}