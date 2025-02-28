// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'ScanState.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanningState());

  void init() async {
    emit(ScanningState());
    
  }
  void barcodeFound({required String barcode}) async{
    final previousBarcode = (state as BarcodeFoundState?)?.barcode;
    
    if (previousBarcode!=null && previousBarcode == barcode) return;
    HapticFeedback.vibrate();
    final barcodes = {
      '5056175945542':'100806893',
      '35354344961':'100279329',
    };
    final productId = barcodes[barcode];
    if (productId == null) {
      emit(BarcodeFoundState(name: 'NOT FOUND', barcode: barcode));
      return;
    }

    final response = await http.get(Uri.parse('https://storefrontgateway.dunnesstoresgrocery.com/api/stores/258/preview?q=$productId'));
    final json = jsonDecode(response.body)  as Map<String, dynamic>;
    final name = json['products'][0]['name'];
    emit(BarcodeFoundState(name: name, barcode: barcode));
  }
}
