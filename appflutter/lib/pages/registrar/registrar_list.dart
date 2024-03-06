import 'package:NivelesClub/services/api_registrar.dart';
import 'package:flutter/material.dart';
import 'package:NivelesClub/models/usuarios_model.dart';
import 'package:NivelesClub/pages/registrar/registrar_item.dart';
import 'package:NivelesClub/services/api_usuarios.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class UsuarioList extends StatefulWidget {
  const UsuarioList({Key? key}) : super(key: key);

  @override
  _UsuarioListState createState() => _UsuarioListState();
}

class _UsuarioListState extends State<UsuarioList> {
  bool isApiCallProcess = false;
  List<Usuario2Model>? filteredUsuarios;
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
          child: loadUsuario(),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    setState(() {
      isApiCallProcess = true;
    });

    try {
      List<Usuario2Model>? updatedUsuario = await APIUsuario2.getUsuario2();
      if (updatedUsuario != null) {
        setState(() {
          isApiCallProcess = false;
        });
      }
    } catch (error) {
      setState(() {
        isApiCallProcess = false;
      });

    }
  }

  Widget loadUsuario() {
    return FutureBuilder(
      future: APIUsuario2.getUsuario2(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<Usuario2Model>?> model,
          ) {
        if (model.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (model.hasError) {
          return const Center(
            child: Text('Error al cargar usuarios'),
          );
        } else if (!model.hasData || model.data!.isEmpty) {
          return const Center(
            child: Text('No hay usuarios disponibles'),
          );
        } else {
          // Filtrar la lista de usuarios excluyendo los 'Clientes'
          List<Usuario2Model>? filteredUsuarios = model.data
              ?.where((usuario) => usuario.cargo != 'Cliente')
              .toList();

          return usuarioList(filteredUsuarios);
        }
      },
    );
  }

  Widget usuarioList(registrar) {
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
                          '/add-regist',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: const Text(
                        'Adicionar Usuario',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),


              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: registrar.length,
                itemBuilder: (context, index) {
                  return UsuarioItem(
                    model: registrar[index],
                    onDelete: (Usuario2Model model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIRegistrar.deleteRegistrar(model.id).then(
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