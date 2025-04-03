// ignore_for_file: file_names

import '../DunnesProductData.dart';

abstract class LinkProductState {}

class StartState extends LinkProductState {
}

class InitState extends LinkProductState {
  final String barcode;
  InitState({required this.barcode});
}


class ProductFoundState extends LinkProductState {
  final DunnesProductData dunnesProduct;
  ProductFoundState({
    required this.dunnesProduct
  });
}

class NotFoundState extends LinkProductState {
}