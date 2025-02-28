// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'ScannerState.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(InitState());

  init() {}

  newScan(String barcode) {
    if (state is InitState || state is ResultState) {
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
        return;
      }
      if (DateTime.now().difference(prevScannedState.firstEmission).inSeconds >
          2) {
        emit(
          ScannedState(
            firstEmission: DateTime.now(),
            count: 0,
            barcode: barcode,
          ),
        );
        return;
      }
      if (DateTime.now().difference(prevScannedState.firstEmission).inSeconds <
          2) {
        if (prevScannedState.count > 3) {
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
        return;
      }
    }
  }
}
