import 'package:flutter/material.dart';
import 'package:NivelesClub/models/producto_model.dart';
import 'package:NivelesClub/pages/producto/producto_item.dart';
import 'package:NivelesClub/services/api_producto.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class ProductosList extends StatefulWidget {
  const ProductosList({Key? key}) : super(key: key);

  @override
  _ProductosListState createState() => _ProductosListState();
}

class _ProductosListState extends State<ProductosList> {

  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
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
          child: loadProductos(),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    setState(() {
      isApiCallProcess = true;
    });

    try {
      List<ProductoModel>? updatedProductos = await APIProducto.getProductos();
      if (updatedProductos != null) {
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

  Widget loadProductos() {
    return FutureBuilder(
      future: APIProducto.getProductos(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<ProductoModel>?> model,
          ) {
        if (model.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (model.hasError) {
          return const Center(
            child: Text('Error al cargar productos'),
          );
        } else {
          return productoList(model.data);
        }
      },
    );
  }

  Widget productoList(List<ProductoModel>? productos) {
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
                // ignore: sort_child_properties_last
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/add-producto',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: const Text(
                        'Adicionar Producto',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/home',
                        );

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: const Text(
                        'Menú',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              if (productos != null && productos.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    return ProductoItem(
                      model: productos[index],
                      onDelete: (ProductoModel model) {
                        setState(() {
                          isApiCallProcess = true;
                        });

                        APIProducto.deleteProducto(model.id_Articulos).then(
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
}
