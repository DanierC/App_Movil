import 'dart:convert';

List<ProductoModel> productosFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ProductoModel>((json) => ProductoModel.fromJson(json))
      .toList();
}

class ProductoModel {
  late int? id_Articulos;
  late String? nombre_Producto;
  late int? precio_Producto;
  late int? costo_Producto;
  late String? imagen_Producto;

  ProductoModel({
    this.id_Articulos,
    this.nombre_Producto,
    this.precio_Producto,
    this.costo_Producto,
    this.imagen_Producto,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json, {
    Encoding? encoding,
  }) {
    return ProductoModel(
      id_Articulos: json['id_Articulos'] as int?,
      nombre_Producto: json['nombre_Producto'] as String?,
      precio_Producto: json['precio_Producto'] as int?,
      costo_Producto: json['costo_Producto'] as int?,
      imagen_Producto: json['imagen_Producto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_Articulos'] = id_Articulos;
    data['nombre_Producto'] = nombre_Producto;
    data['precio_Producto'] = precio_Producto;
    data['costo_Producto'] = costo_Producto;
    data['imagen_Producto'] = imagen_Producto;
    return data;
  }

}
