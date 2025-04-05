// ignore_for_file: file_names

import 'package:dunnes_shopping/DunnesProductData.dart';

abstract class ShoppingListState {}

class ShoppingState extends ShoppingListState {
  final List<DunnesProductData> products;
  ShoppingState({required this.products});
}

abstract class ScannedState extends ShoppingListState {
  final String barcode;
  final List<DunnesProductData> products;
  ScannedState({required this.barcode, required this.products});
}

class ProductNotFoundState extends ScannedState {
  ProductNotFoundState({required super.barcode, required super.products});
}

class LinkProductState extends ScannedState {
  LinkProductState({required super.barcode, required super.products});
}

class QueryingProductState extends ScannedState {
  QueryingProductState({required super.barcode, required super.products});
}

class ProductFoundState extends ScannedState {
  final DunnesProductData dunnesProduct;
  ProductFoundState({
    required this.dunnesProduct,
    required super.barcode,
    required super.products
  });
}
