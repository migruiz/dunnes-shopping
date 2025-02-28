// ignore_for_file: file_names


abstract class ScanState{}
class ScanningState extends ScanState{

}

class BarcodeFounsState extends ScanState{
  final String barcode;
  BarcodeFounsState({required this.barcode});
}