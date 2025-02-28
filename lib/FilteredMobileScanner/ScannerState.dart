

abstract class ScannerState{

}
class InitState implements ScannerState{

}

class ScannedState implements ScannerState{
  final String barcode;
  final DateTime firstEmission;
  final int count;
  ScannedState({required this.firstEmission, required this.count, required this.barcode});
}
class ResultState implements ScannerState{
   final String barcode;
  ResultState({required this.barcode});
}