// ignore_for_file: file_names


abstract class ScanState{}
class ScanningState extends ScanState{

}

class BarcodeFoundState extends ScanState{
  final String barcode;
  final String name;
  final String imageUrl;
  BarcodeFoundState({required this.barcode, required this.name, required this.imageUrl});
}