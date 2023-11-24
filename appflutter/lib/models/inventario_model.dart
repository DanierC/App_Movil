import 'dart:convert';

List<InventarioModel> inventarioFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<InventarioModel>((json) => InventarioModel.fromJson(json))
      .toList();
}

class InventarioModel {
  late int? id_Inventario;
  late int? id_Articulos_Inventario;
  late int? cantidad_Inicial;
  late int? cantidad_Final;
  late int? pedidos_Bodega;
  late int? cantidad_TotalVenta;
  late int? total_Venta;
  late DateTime? fecha;

  InventarioModel({
    this.id_Inventario,
    this.id_Articulos_Inventario,
    this.cantidad_Inicial,
    this.cantidad_Final,
    this.pedidos_Bodega,
    this.cantidad_TotalVenta,
    this.total_Venta,
    this.fecha,
  });

  factory InventarioModel.fromJson(Map<String, dynamic> json) {
    return InventarioModel(
      id_Inventario: json['id_Inventario'] as int?,
      id_Articulos_Inventario: json['id_Articulos_Inventario'] as int?,
      cantidad_Inicial: json['cantidad_Inicial'] as int?,
      cantidad_Final: json['cantidad_Final'] as int?,
      pedidos_Bodega: json['pedidos_Bodega'] as int?,
      cantidad_TotalVenta: json['cantidad_TotalVenta'] as int?,
      total_Venta: json['total_Venta'] as int?,
      fecha: DateTime.parse(json['fecha'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_Inventario'] = id_Inventario;
    data['id_Articulos_Inventario'] = id_Articulos_Inventario;
    data['cantidad_Inicial'] = cantidad_Inicial;
    data['cantidad_Final'] = cantidad_Final;
    data['pedidos_Bodega'] = pedidos_Bodega;
    data['cantidad_TotalVenta'] = cantidad_TotalVenta;
    data['total_Venta'] = total_Venta;
    data['fecha'] = fecha?.toIso8601String();
    return data;
  }
}
