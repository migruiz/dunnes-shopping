// ignore_for_file: file_names

import '../DunnesProductData.dart';

abstract class LinkProductState {}

class StartState extends LinkProductState {}

class InitState extends LinkProductState {
  final String barcode;
  InitState({required this.barcode});
}

class ProductFoundState extends LinkProductState {
  final DunnesProductData product;
  ProductFoundState({required this.product});
}

class LinkedState extends LinkProductState {
  final String barcode;
  final String productId;
  LinkedState({required this.barcode, required this.productId});
}

class NotFoundState extends LinkProductState {}
