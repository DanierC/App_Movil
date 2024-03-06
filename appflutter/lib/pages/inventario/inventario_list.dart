import 'package:flutter/material.dart';
import 'package:NivelesClub/models/inventario_model.dart';
import 'package:NivelesClub/pages/inventario/inventario_item.dart';
import 'package:NivelesClub/services/api_inventario.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:NivelesClub/services/api_producto.dart';
import 'package:NivelesClub/models/producto_model.dart';

class InventarioList extends StatefulWidget {
  const InventarioList({Key? key}) : super(key: key);

  @override

  _InventarioListState createState() => _InventarioListState();
}

class _InventarioListState extends State<InventarioList> {
  Stream<List<InventarioModel>>? _inventarioStream;
  bool isApiCallProcess = false;
  DateTime utcToLocal(DateTime utcDateTime) {

    return utcDateTime.toLocal();
  }
  @override
  void initState() {
    super.initState();
    _inventarioStream = APIInventario.inventarioStream;
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
            await _refreshList();
          },
          child: loadInventario(),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    setState(() {
      isApiCallProcess = true;
    });

    try {
      List<InventarioModel>? updatedInventario = await APIInventario.getInventario();
      if (updatedInventario != null) {
        setState(() {
          isApiCallProcess = false;
        });
      }
    } catch (error) {
      setState(() {
        isApiCallProcess = false;
      });
      // Manejar errores si es necesario
    }
  }

  Widget loadInventario() {
    return FutureBuilder(
      future: APIInventario.getInventario(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<InventarioModel>?> model,
          ) {
        if (model.hasData) {
          return inventarioList(model.data);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void generateTXT(List<InventarioModel> inventario) async {
    try {
      // Obtener la fecha actual
      final now = DateTime.now();

      // Obtener la ruta deseada
      final desiredPath = '/storage/emulated/0/Download';

      // Crear o abrir el archivo de texto en la ruta deseada
      final fileName = 'Inventario-${now.day}-${now.month}-${now.year}.txt';
      File file = File('${desiredPath}/$fileName');

      // Obtener la lista de productos para mapear los IDs a los nombres
      List<ProductoModel>? productos = await APIProducto.getProductos();

      // Abrir el archivo en modo de escritura
      RandomAccessFile raf = await file.open(mode: FileMode.write);

      // Escribir los datos en el archivo
      for (var item in inventario) {
        // Buscar el producto correspondiente en la lista de productos
        ProductoModel? producto = productos?.firstWhere((prod) => prod.id_Articulos == item.id_Articulos_Inventario);

        if (producto != null) {
          // Escribir los datos en el archivo con el nombre del producto
          raf.writeStringSync(

            "Fecha: ${DateFormat("dd/MM/yyyy").format(utcToLocal(item!.fecha ?? DateTime.now()))}\nProducto: ${producto.nombre_Producto} \nCantidad inicial: ${item.cantidad_Inicial}\n  Cantidad Final: ${item.cantidad_Final} \nPedido bodega: ${item.pedidos_Bodega} \nCantidad vendida: ${item.cantidad_TotalVenta} \nTotal venta: ${item.total_Venta} \n\n",
          );
        } else {
          // Si no se encuentra el producto, escribir un mensaje de error en el archivo
          raf.writeStringSync(
            "{'producto': 'Error: Producto no encontrado', \nCantidad inicial: ${item.cantidad_Inicial}\n  Cantidad Final: ${item.cantidad_Final} \nPedido bodega: ${item.pedidos_Bodega} \nCantidad vendida: ${item.cantidad_TotalVenta} \nTotal venta: ${item.total_Venta} }\n",
          );
        }
      }

      // Calcular la sumatoria de total_Venta después de escribir todos los datos
      double sumatoriaTotalVenta = inventario.fold(0.0, (prev, item) => prev + (item.total_Venta ?? 0.0));

      // Formatear la sumatoria con puntos para separar miles y millones
      String formattedSumatoria = NumberFormat.decimalPattern('es').format(sumatoriaTotalVenta);

      // Escribir la sumatoria al final del archivo
      raf.writeStringSync('\nSumatoria Total Venta: $formattedSumatoria\n');

      // Cerrar el archivo
      await raf.close();

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Archivo de texto generado con éxito. Se ha descargado en la ruta deseada con el nombre: $fileName.',
          ),
        ),
      );
    } catch (e) {
      print('Error al generar el archivo de texto: $e');
      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al generar el archivo de texto'),
        ),
      );
    }
  }

  Widget inventarioList(inventario) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/add-invent',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text(
                        'Adicionar Inventario',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                // ignore: sort_child_properties_last
                children: [
                  Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      generateTXT(inventario);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    child: const Text(
                      'Generar Inventario TXT',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Muestra el diálogo de confirmación antes de resetear la cantidad inicial
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmación'),
                              content: const Text('¿Estás seguro de resetear la cantidad inicial?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Cierra el diálogo sin hacer nada si el usuario cancela
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Cierra el diálogo y realiza la acción de resetear la cantidad inicial
                                    Navigator.of(context).pop();
                                    resetCantidadInicial(inventario);
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Resetear Cantidad Inicial',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),


              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: inventario.length,
                itemBuilder: (context, index) {
                  return InventarioItem(
                    model: inventario[index],
                    onDelete: (InventarioModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIInventario.deleteInventario(model.id_Inventario).then(
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
  void resetCantidadInicial(List<InventarioModel> inventario) async {
    setState(() {
      isApiCallProcess = true;
    });

    try {
      await Future.forEach(inventario, (InventarioModel item) async {
        item.cantidad_Inicial = item.cantidad_Final;
        item.cantidad_Final = 0;
        item.pedidos_Bodega = 0;
        item.cantidad_TotalVenta = 0;
        item.total_Venta = 0;

        await APIInventario.saveInventario(item, true, false);
      });

      setState(() {
        isApiCallProcess = false;
      });


    } catch (e) {
      setState(() {
        isApiCallProcess = false;
      });
      print('Error al resetear la cantidad inicial: $e');

    }
  }

}