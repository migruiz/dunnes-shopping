// ignore_for_file: file_names

import 'dart:convert';

import 'package:dunnes_shopping/DunnesProductData.dart';
import 'package:dunnes_shopping/ShoppingList/ShoppingListProductData.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'ShoppingListState.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit() : super(ShoppingListState.initial());

  void init() async {
    final db = FirebaseFirestore.instance;
    final lists = db.collection("shoppinglists");

    final querySnapshot =
        await lists.where('archived', isEqualTo: false).limit(1).get();

    final String documentId;
    if (querySnapshot.docs.isNotEmpty) {
      documentId = querySnapshot.docs.first.id;
    } else {
      final newDoc = await lists.add({
        "archived": false,
        "date": DateTime.now(),
      });
      documentId = newDoc.id;
    }

    emit(
      state.copyWith(
        type: ShoppingListStateType.scanning,
        shoppingDocumentId: documentId,
        products: List.empty(),
      ),
    );
  }

  void continueShopping() async {
    emit(state.copyWith(type: ShoppingListStateType.scanning));
  }

  void barcodeFound({required String barcode}) async {
    emit(
      state.copyWith(
        type: ShoppingListStateType.queryingBarcode,
        scannedBarcode: barcode,
      ),
    );

    final db = FirebaseFirestore.instance;
    final productResult = await db.collection("barcodes").doc(barcode).get();
    if (!productResult.exists) {
      emit(state.copyWith(type: ShoppingListStateType.dunnesProductNotFound));
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
      state.copyWith(
        type: ShoppingListStateType.dunnesProductFound,
        dunnesFoundProduct: DunnesProductData(
          name: name,
          imageUrl: imageUrl,
          price: price,
          productId: productId,
        ),
      ),
    );
  }

  void confirmProduct({required DunnesProductData product}) {
    final newList = List<ShoppingListProductData>.from(state.products!);
    newList.add(ShoppingListProductData(name: product.name, imageUrl: product.imageUrl, price: product.price));
     emit(state.copyWith(type: ShoppingListStateType.scanning, products: newList));
  }

  void linkBarcode({required barcode}) {
    emit(
      state.copyWith(type: ShoppingListStateType.linkProduct, scannedBarcode: barcode)
    );
  }

  void reLinkProduct() {
    emit(
      state.copyWith(type: ShoppingListStateType.linkProduct)
    );
  }
}
