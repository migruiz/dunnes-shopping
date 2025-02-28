// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'ScanState.dart';
import 'package:audioplayers/audioplayers.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanningState());

  void init() async {
    emit(ScanningState());
  }

  void barcodeFound({required String barcode}) async {
    final previousBarcode =
        (state is ScannedState) ? (state as ScannedState).barcode : null;

    if (previousBarcode != null && previousBarcode == barcode) return;
    HapticFeedback.vibrate();
    final barcodes = {
      '5099874079736': '100806893',
      '22966680304': '100806893',
      '5056175945542': '100279329',
      '5099874343677': '100279329',
    };
    final productId = barcodes[barcode];
    if (productId == null) {
      emit(NotFoundState(barcode: barcode));
      return;
    }
    emit(QueryingProductState(barcode: barcode));

    final player = AudioPlayer();
    final results = await Future.wait([
      http.get(
        Uri.parse(
          'https://storefrontgateway.dunnesstoresgrocery.com/api/stores/258/preview?q=$productId',
        ),
      ),
      player.play(UrlSource('https://www.soundjay.com/buttons/beep-01a.wav')),
    ]);

    final response = results[0] as http.Response;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final name = json['products'][0]['name'];
    final imageUrl = json['products'][0]['image']['default'];
    final price = json['products'][0]['priceNumeric'];

    emit(
      ProductFoundState(
        name: name,
        barcode: barcode,
        imageUrl: imageUrl,
        price: price,
      ),
    );
  }

  void confirmProduct(String barcode) {
     emit(ScanningState());
  }
}
