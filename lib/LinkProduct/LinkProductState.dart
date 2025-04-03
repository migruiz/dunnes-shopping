// ignore_for_file: file_names

abstract class LinkProductState {}

class StartState extends LinkProductState {
}

class InitState extends LinkProductState {
  final String barcode;
  InitState({required this.barcode});
}


class ProductFoundState extends LinkProductState {
  final String name;
  final String imageUrl;
  final double price;
  ProductFoundState({
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}

class NotFoundState extends LinkProductState {
}