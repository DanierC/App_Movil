import 'dart:convert';

List<PedidoBModel> pedidoBFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<PedidoBModel>((json) => PedidoBModel.fromJson(json))
      .toList();
}

class PedidoBModel {
  late int? id_Orden_Bodega;
  late int? id_Usuario;
  late int? cantidad;
  late int? cantidad_Total;
  late String? tipo_Cantidad;
  late int? articulos_Bodega_id;
  late String? estado_Pedido;
  late DateTime? fecha;

  Map<String, List<String>> getChoices() {
    return {
      'tipo_Cantidad': ['Unidad', 'Decena', 'Docena', 'PacaX20', 'PacaX24'],
      'estado_Pedido': ['Pendiente','Confirmado', 'Denegado'],
    };
  }
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
        return 1; // Valor predeterminado para casos no contemplados
    }
  }

  PedidoBModel({
    this.id_Orden_Bodega,
    this.id_Usuario,
    this.cantidad,
    this.cantidad_Total,
    this.tipo_Cantidad,
    this.articulos_Bodega_id,
    this.estado_Pedido,
    this.fecha,
  });

  factory PedidoBModel.fromJson(Map<String, dynamic> json) {
    return PedidoBModel(
      id_Orden_Bodega: json['id_Orden_Bodega'] as int?,
      id_Usuario: json['id_Usuario'] as int?,
      cantidad: json['cantidad'] as int?,
      cantidad_Total: json['cantidad_Total'] as int?,
      tipo_Cantidad: json['tipo_Cantidad'] as String?,
      estado_Pedido: json['estado_Pedido'] as String?,
      articulos_Bodega_id: json['articulos_Bodega_id'] as int?,
      fecha: DateTime.parse(json['fecha'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_Orden_Bodega'] = id_Orden_Bodega;
    data['id_Usuario'] = id_Usuario;
    data['cantidad'] = cantidad;
    data['cantidad_Total'] = cantidad_Total;
    data['tipo_Cantidad'] = tipo_Cantidad;
    data['estado_Pedido'] = estado_Pedido;
    data['articulos_Bodega_id'] = articulos_Bodega_id;
    data['fecha'] = fecha?.toIso8601String();
    return data;
  }
}
