// ignore_for_file: file_names

abstract class ScanState {}

class ScanningState extends ScanState {}

abstract class ScannedState extends ScanState {
  final String barcode;
  ScannedState({required this.barcode});
}

class NotFoundState extends ScannedState {
  NotFoundState({required super.barcode});
}

class QueryingProductState extends ScannedState {
  QueryingProductState({required super.barcode});
}

class ProductFoundState extends ScannedState {
  final String name;
  final String imageUrl;
  final double price;
  ProductFoundState({
    required this.name,
    required this.imageUrl,
    required this.price,
    required super.barcode,
  });
}
