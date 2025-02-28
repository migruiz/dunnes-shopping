// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'ScanState.dart';

class ChildrenCubit extends Cubit<ScanState> {
  ChildrenCubit() : super(ScanningState());

  void init() async {
    emit(ScanningState());
    
  }
}
