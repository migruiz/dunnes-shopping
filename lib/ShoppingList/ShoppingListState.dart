// ignore_for_file: file_names

import './ShoppingListProductData.dart';

import '../DunnesProductData.dart';

enum ShoppingListStateType {
  initial,
  scanning,
  queryingBarcode,
  dunnesProductNotFound,
  linkProduct,
  dunnesProductFound,
}

class ShoppingListState {
  final ShoppingListStateType type;
  final List<ShoppingListProductData>? products;
  final String? shoppingDocumentId;

  final String? scannedBarcode;
  final DunnesProductData? foundDunnesProduct;

  ShoppingListState({
    required this.type,
    required this.shoppingDocumentId,
    required this.products,
    required this.scannedBarcode,
    required this.foundDunnesProduct,
  });

  static ShoppingListState initial() => ShoppingListState(
        type: ShoppingListStateType.initial,
        shoppingDocumentId: null,
        products: null,
        scannedBarcode: null,
        foundDunnesProduct: null
      );

  ShoppingListState copyWith({
    required ShoppingListStateType type,
    String? shoppingDocumentId,
    List<ShoppingListProductData>? products,
    String? scannedBarcode,
    DunnesProductData? dunnesFoundProduct,
  }) => ShoppingListState(
    type: type,
    shoppingDocumentId: shoppingDocumentId ?? this.shoppingDocumentId,
    products: products ?? this.products,
    scannedBarcode: scannedBarcode ?? this.scannedBarcode,
    foundDunnesProduct: dunnesFoundProduct ?? this.foundDunnesProduct,
  );
}
