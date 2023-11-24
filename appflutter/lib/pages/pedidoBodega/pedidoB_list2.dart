import 'package:flutter/material.dart';
import 'package:appflutter/models/pedBodega_model.dart';
import 'package:appflutter/pages/pedidoBodega/pedidoB_item2.dart';
import 'package:appflutter/services/api_pedidoB.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:appflutter/models/producto_model.dart';
import 'package:intl/intl.dart';
import 'package:appflutter/services/api_producto.dart';

class PedidoBList2 extends StatefulWidget {
  const PedidoBList2({Key? key}) : super(key: key);

  @override
  _PedidoBListState createState() => _PedidoBListState();
}

class _PedidoBListState extends State<PedidoBList2> {
  bool isApiCallProcess = false;
  late Directory appDocDir;
  DateTime utcToLocal(DateTime utcDateTime) {

    return utcDateTime.toLocal();
  }

  @override
  void initState() {
    super.initState();
    getAppDirectory();
  }

  Future<void> getAppDirectory() async {
    appDocDir = await getApplicationDocumentsDirectory();
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
          child: loadPedidoB(),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    setState(() {
      isApiCallProcess = true;
    });

    try {
      List<PedidoBModel>? updatedPedidoB = await APIPedidoB.getPedidoB();
      if (updatedPedidoB != null) {
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

  Widget loadPedidoB() {
    return FutureBuilder(
      future: APIPedidoB.getPedidoB(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<PedidoBModel>?> model,
          ) {
        if (model.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (model.hasError) {
          return const Center(
            child: Text('Error al cargar pedidos'),
          );
        } else {
          // Renderizar los botones aquí
          return pedidoBList(model.data!);
        }
      },
    );
  }

  void generateTXT(List<PedidoBModel> pedidoB) async {
    try {
      // Obtener la fecha actual
      final now = DateTime.now();

      // Obtener la ruta deseada
      final desiredPath = '/storage/emulated/0/Download';

      // Crear o abrir el archivo de texto en la ruta deseada
      final fileName = 'pedido-${now.day}-${now.month}-${now.year}.txt';
      File file = File('${desiredPath}/$fileName');

      // Abrir el archivo en modo de escritura
      RandomAccessFile raf = await file.open(mode: FileMode.write);

      // Obtener la lista de productos para mapear los IDs a los nombres
      List<ProductoModel>? productos = await APIProducto.getProductos();

      // Escribir los datos en el archivo
      for (var item in pedidoB) {
        // Buscar el producto correspondiente en la lista de productos
        ProductoModel? producto = productos?.firstWhere((prod) => prod.id_Articulos == item.articulos_Bodega_id);

        if (producto != null) {
          // Escribir los datos en el archivo con el nombre del producto
          raf.writeStringSync(

            "Fecha: ${DateFormat("dd/MM/yyyy HH:mm").format(utcToLocal(item!.fecha ?? DateTime.now()))}\nProducto: ${producto.nombre_Producto} \nCantidad: ${item.cantidad}\n  Tipo Cantidad: ${item.tipo_Cantidad} \nCantidadTotal: ${item.cantidad_Total} \n\n",
          );
        } else {
          // Si no se encuentra el producto, escribir un mensaje de error en el archivo
          raf.writeStringSync(
            "{'producto': 'Error: Producto no encontrado', 'cantidad': ${item.cantidad}, 'cantidadTotal': ${item.cantidad_Total}, 'tipoCantidad': '${item.tipo_Cantidad}' }\n",
          );
        }
      }

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



  Widget pedidoBList(List<PedidoBModel> pedidoB) {
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
                          '/add-pedB',
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
                        'Adicionar Pedido',
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
                        generateTXT(pedidoB);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text(
                        'Generar Pedido TXT',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        deleteAllPedidos(pedidoB);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text(
                        'Borrar Todos los Pedidos',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: pedidoB.length,
                itemBuilder: (context, index) {
                  return PedidoBItem2(
                    model: pedidoB[index],
                    onDelete: (PedidoBModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIPedidoB.deletePedidoB(model.id_Orden_Bodega).then(
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
          ),
        ],
      ),
    );
  }
  Future<void> deleteAllPedidos(List<PedidoBModel> pedidoB) async {
    try {
      // Crear una lista de futuros para las operaciones de borrado
      final List<Future<void>> deleteFutures = [];

      for (var pedido in pedidoB) {
        // Agregar cada operación de borrado a la lista de futuros
        deleteFutures.add(APIPedidoB.deletePedidoB(pedido.id_Orden_Bodega));
      }

      // Esperar a que todas las operaciones de borrado se completen
      await Future.wait(deleteFutures);

      // Después de borrar, cargar la lista nuevamente
      await loadPedidoB();
    } catch (error) {
      setState(() {
        isApiCallProcess = false;
      });
      // Manejar errores si es necesario
    }
  }
}
