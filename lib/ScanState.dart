// ignore_for_file: file_names


abstract class ScanState{}
class ScanningState extends ScanState{

}

class BarcodeFoundState extends ScanState{
  final String barcode;
  BarcodeFoundState({required this.barcode});
}