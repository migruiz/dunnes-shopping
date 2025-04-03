// ignore_for_file: file_names

abstract class LinkProductState {}

class StartState extends LinkProductState {
}

class InitState extends LinkProductState {
  final String barcode;
  InitState({required this.barcode});
}