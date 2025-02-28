// ignore_for_file: file_names


abstract class ScanState{}
class ScanningState extends ScanState{

}
class NotFoundState extends ScanState{

}

class BarcodeFoundState extends ScanState{
  final String barcode;
  final String name;
  final String imageUrl;
  final double price;
  BarcodeFoundState({required this.barcode, required this.name, required this.imageUrl, required this.price});
}