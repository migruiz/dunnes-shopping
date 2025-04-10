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
  ShoppingListCubit()
    : super(ShoppingState(products: List.empty(), shoppingDocumentId: ""));

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

    emit(ShoppingState(products: List.empty(), shoppingDocumentId: documentId));
  }

  void continueShopping() async {
    emit(
      ShoppingState(
        products: state.products,
        shoppingDocumentId: state.shoppingDocumentId,
      ),
    );
  }

  void barcodeFound({required String barcode}) async {
    emit(
      QueryingProductState(
        barcode: barcode,
        products: state.products,
        shoppingDocumentId: state.shoppingDocumentId,
      ),
    );

    final db = FirebaseFirestore.instance;
    final productResult = await db.collection("barcodes").doc(barcode).get();
    if (!productResult.exists) {
      emit(
        ProductNotFoundState(
          barcode: barcode,
          products: state.products,
          shoppingDocumentId: state.shoppingDocumentId,
        ),
      );
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
        products: state.products,
        shoppingDocumentId: state.shoppingDocumentId,
      ),
    );
  }

  void confirmProduct({required barcode, required DunnesProductData product}) {
    final newList = List<DunnesProductData>.from(state.products);
    newList.add(product);
    emit(
      ShoppingState(
        products: newList,
        shoppingDocumentId: state.shoppingDocumentId,
      ),
    );
  }

  void linkBarcode({required barcode}) {
    emit(
      LinkProductState(
        barcode: barcode,
        products: state.products,
        shoppingDocumentId: state.shoppingDocumentId,
      ),
    );
  }

  void reLinkProduct({required barcode}) {
    emit(
      LinkProductState(
        barcode: barcode,
        products: state.products,
        shoppingDocumentId: state.shoppingDocumentId,
      ),
    );
  }
}
