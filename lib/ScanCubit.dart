// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'ScanState.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanningState());

  void init() async {
    emit(ScanningState());
  }

  void barcodeFound({required String barcode}) async {
    final previousBarcode =
        (state is ScannedState) ? (state as ScannedState).barcode : null;

    if (previousBarcode != null && previousBarcode == barcode) return;
    emit(QueryingProductState(barcode: barcode));

    final db = FirebaseFirestore.instance;
    final productResult = await db.collection("barcodes").doc(barcode).get();
    if (!productResult.exists) {
      emit(NotFoundState(barcode: barcode));
      return;
    }
    final productId = productResult.data()!["productId"];

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

    HapticFeedback.vibrate();
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
