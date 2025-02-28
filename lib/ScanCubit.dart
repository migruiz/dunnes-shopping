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
   // final previousBarcode = (state is BarcodeFoundState) ? (state as BarcodeFoundState).barcode : null;
    
    //if (previousBarcode!=null && previousBarcode == barcode) return;
    HapticFeedback.vibrate();
    final barcodes = {
      '5099874079736':'100806893',
      '5099874343677':'100279329',
    };
    final productId = barcodes[barcode];
    if (productId == null) {
      emit(BarcodeFoundState(name: 'NOT FOUND', barcode: barcode, imageUrl: ''));
      return;
    }

    final response = await http.get(Uri.parse('https://storefrontgateway.dunnesstoresgrocery.com/api/stores/258/preview?q=$productId'));
    final json = jsonDecode(response.body)  as Map<String, dynamic>;
    final name = json['products'][0]['name'];
    final imageUrl = json['products'][0]['image']['default'];
    emit(BarcodeFoundState(name: name, barcode: barcode, imageUrl: imageUrl));
  }
}
