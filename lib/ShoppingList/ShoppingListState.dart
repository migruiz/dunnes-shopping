// ignore_for_file: file_names

import 'package:dunnes_shopping/DunnesProductData.dart';

enum ShoppingListStateType {
  initial,
  scanning,
  queryingBarcode,
  productNotFound,
  linkProduct,
  productFound,
}

class ShoppingListState {
  final ShoppingListStateType type;
  final List<DunnesProductData>? products;
  final String? shoppingDocumentId;

  final String? scannedBarcode;
  final DunnesProductData? foundProduct;

  ShoppingListState({
    required this.type,
    required this.shoppingDocumentId,
    required this.products,
    required this.scannedBarcode,
    required this.foundProduct,
  });

  static ShoppingListState initial() => ShoppingListState(
        type: ShoppingListStateType.initial,
        shoppingDocumentId: null,
        products: null,
        scannedBarcode: null,
        foundProduct: null
      );

  ShoppingListState copyWith({
    required ShoppingListStateType type,
    String? shoppingDocumentId,
    List<DunnesProductData>? products,
    String? scannedBarcode,
    DunnesProductData? foundProduct,
  }) => ShoppingListState(
    type: type,
    shoppingDocumentId: shoppingDocumentId ?? this.shoppingDocumentId,
    products: products ?? this.products,
    scannedBarcode: scannedBarcode ?? this.scannedBarcode,
    foundProduct: foundProduct ?? this.foundProduct,
  );
}
