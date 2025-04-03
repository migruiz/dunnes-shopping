// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'ScannerState.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(InitState());

  init() {}

  newScan(String barcode) {
    print('nard scanned: ' + barcode);
    if (state is InitState) {
      emit(
        ScannedState(firstEmission: DateTime.now(), count: 0, barcode: barcode),
      );
      return;
    }
    if (state is ScannedState) {
      final prevScannedState = state as ScannedState;
      if (barcode != prevScannedState.barcode) {
        emit(
          ScannedState(
            firstEmission: DateTime.now(),
            count: 0,
            barcode: barcode,
          ),
        );
      } else {
        if (prevScannedState.count > 2) {
          print('nard ResultState: ' + barcode);
          emit(ResultState(barcode: barcode));
        } else {
          emit(
            ScannedState(
              firstEmission: prevScannedState.firstEmission,
              count: prevScannedState.count + 1,
              barcode: barcode,
            ),
          );
        }
      }
    }
  }
}
