// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'LinkProductState.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinkProductCubit extends Cubit<LinkProductState> {
  LinkProductCubit() : super(StartState());

  void init({required String barcode}) async {
    emit(InitState( barcode: barcode));
  }


}
