import 'dart:convert';

List<PedidoModel> pedidoMFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<PedidoModel>((json) => PedidoModel.fromJson(json))
      .toList();
}

class PedidoModel {
  late int? id_Orden;
  late int? cantidad;
  late int? articulo_Id;

  PedidoModel({
    this.id_Orden,
    this.cantidad,
    this.articulo_Id,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      id_Orden: json['id_Orden'] as int?,
      cantidad: json['cantidad'] as int?,
      articulo_Id: json['articulo_Id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_Orden'] = id_Orden;
    data['cantidad'] = cantidad;
    data['articulo_Id'] = articulo_Id;
    return data;
  }
}