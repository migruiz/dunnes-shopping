// ignore_for_file: file_names

import 'dart:convert';

import 'package:dunnes_shopping/DunnesProductData.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'LinkProductState.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinkProductCubit extends Cubit<LinkProductState> {
  LinkProductCubit() : super(StartState());

  void init({required String barcode}) async {
    emit(InitState(barcode: barcode));
  }

  void searchFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    final splitted = clipboardText?.split("-id-");
    final productId = splitted?[1];
    if (productId == null) {
      emit(NotFoundState());
      return;
    }
    print(productId);

    final response = await http.get(
      Uri.parse(
        'https://storefrontgateway.dunnesstoresgrocery.com/api/stores/258/preview?q=$productId',
      ),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final name = json['products'][0]['name'];
    final imageUrl = json['products'][0]['image']['default'];
    final price = json['products'][0]['priceNumeric'];

    emit(ProductFoundState(dunnesProduct: DunnesProductData(name: name, imageUrl: imageUrl, price: price)));
  }
}
