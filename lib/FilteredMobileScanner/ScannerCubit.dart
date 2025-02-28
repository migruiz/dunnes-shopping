// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'ScannerState.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(InitState());

  init() {

  }

  newScan(String barcode) {
    emit(ScannedState(firstEmission: DateTime.now(), count: 0, barcode: barcode));
  }
}
