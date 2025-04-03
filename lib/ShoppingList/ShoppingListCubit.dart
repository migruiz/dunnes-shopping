// ignore_for_file: file_names

import 'dart:convert';

import 'package:dunnes_shopping/DunnesProductData.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'ShoppingListState.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit() : super(ScanningState());

  void init() async {
    scanNewProduct();
  }

  void scanNewProduct() async {
    emit(ScanningState());
  }

  void barcodeFound({required String barcode}) async {
    emit(QueryingProductState(barcode: barcode));

    final db = FirebaseFirestore.instance;
    final productResult = await db.collection("barcodes").doc(barcode).get();
    if (!productResult.exists) {
      emit(ProductNotFoundState(barcode: barcode));
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
        dunnesProduct: DunnesProductData(name: name, imageUrl: imageUrl, price: price, productId: productId),
        barcode: barcode,
      ),
    );
  }

  void confirmProduct(String barcode, DunnesProductData product) {
    emit(ScanningState());
  }

  void linkBarcode(String barcode) {
    emit(LinkProductState(barcode:barcode ));
  }
}
