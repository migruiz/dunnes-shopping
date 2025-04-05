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
  ShoppingListCubit() : super(ShoppingState(products: List.empty()));

  void init() async {
    emit(ShoppingState(products: List.empty()));
  }

  void continueShopping({required List<DunnesProductData> products}) async {
    emit(ShoppingState(products: products));
  }

  void barcodeFound({
    required String barcode,
    required List<DunnesProductData> products,
  }) async {
    emit(QueryingProductState(barcode: barcode, products: products));

    final db = FirebaseFirestore.instance;
    final productResult = await db.collection("barcodes").doc(barcode).get();
    if (!productResult.exists) {
      emit(ProductNotFoundState(barcode: barcode, products: products));
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
        dunnesProduct: DunnesProductData(
          name: name,
          imageUrl: imageUrl,
          price: price,
          productId: productId,
        ),
        barcode: barcode,
        products: products,
      ),
    );
  }

  void confirmProduct({
    required barcode,
    required List<DunnesProductData> products,
    required DunnesProductData product,
  }) {
    final newList = List<DunnesProductData>.from(products);
    newList.add(product);
    emit(ShoppingState(products: newList));
  }

  void linkBarcode({required  barcode, required List<DunnesProductData> products}) {
    emit(LinkProductState(barcode: barcode, products: products));
  }

  void reLinkProduct({required  barcode, required List<DunnesProductData> products}) {
    emit(LinkProductState(barcode: barcode, products: products));
  }
}
