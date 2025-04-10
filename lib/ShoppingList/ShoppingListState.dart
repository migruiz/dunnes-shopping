// ignore_for_file: file_names

import 'package:dunnes_shopping/DunnesProductData.dart';

abstract class ShoppingListState {
  final List<DunnesProductData> products;
  final String shoppingDocumentId;
  ShoppingListState({required this.shoppingDocumentId, required this.products});
}

class ShoppingState extends ShoppingListState {
  ShoppingState({required super.products, required super.shoppingDocumentId});
}

abstract class ScannedState extends ShoppingListState {
  final String barcode;
  ScannedState({required this.barcode, required super.products, required super.shoppingDocumentId});
}

class ProductNotFoundState extends ScannedState {
  ProductNotFoundState({required super.barcode, required super.products, required super.shoppingDocumentId});
}

class LinkProductState extends ScannedState {
  LinkProductState({required super.barcode, required super.products, required super.shoppingDocumentId});
}

class QueryingProductState extends ScannedState {
  QueryingProductState({required super.barcode, required super.products, required super.shoppingDocumentId});
}

class ProductFoundState extends ScannedState {
  final DunnesProductData dunnesProduct;
  ProductFoundState({
    required this.dunnesProduct,
    required super.barcode,
    required super.products
  , required super.shoppingDocumentId});
}
