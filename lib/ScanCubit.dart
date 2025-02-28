// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'ScanState.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanningState());

  void init() async {
    emit(ScanningState());
    
  }
  void barcodeFound(String barcode) {
    emit(BarcodeFoundState(barcode: barcode));
  }
}
