// ignore_for_file: file_names

import 'package:dunnes_shopping/DunnesProductData.dart';

abstract class ShoppingListState {}

class ScanningState extends ShoppingListState {}

abstract class ScannedState extends ShoppingListState {
  final String barcode;
  ScannedState({required this.barcode});
}

class ProductNotFoundState extends ScannedState {
  ProductNotFoundState({required super.barcode});
}

class LinkProductState extends ScannedState {
  LinkProductState({required super.barcode});
}

class QueryingProductState extends ScannedState {
  QueryingProductState({required super.barcode});
}

class ProductFoundState extends ScannedState {
  final DunnesProductData dunnesProduct;
  ProductFoundState({
    required this.dunnesProduct,
    required super.barcode,
  });
}
