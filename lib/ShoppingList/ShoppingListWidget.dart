import 'package:dunnes_shopping/ShoppingList/ProductFoundWidget.dart';
import 'package:dunnes_shopping/ShoppingList/ProductNotFoundWidget.dart';
import 'package:dunnes_shopping/ShoppingList/ShoppingListState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../FilteredMobileScanner/FilteredMobileScannerWidget.dart';
import 'ShoppingListCubit.dart';

class ShoppingListWidget extends StatelessWidget {
  const ShoppingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShoppingListCubit()..init(),
      child: BlocBuilder<ShoppingListCubit, ShoppingListState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<ShoppingListCubit>(context);
          if (state is ScanningState) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 150,
                  child: FilteredMobileScannerWidget(
                    onDetect: (barcode) {
                      bloc.barcodeFound(barcode: barcode);
                    },
                  ),
                ),
              ],
            );
          } else if (state is ProductFoundState) {
            return ProductFoundWidget(
              productFoundState: state,
              onConfirm: () {
                bloc.confirmProduct(state.barcode);
              },
            );
          } else if (state is NotFoundState) {
            return ProductNotFoundWidget(
              barcodeNotFound: state.barcode,
              onLinkBarcode: (barcode) {
                bloc.linkBarcode(barcode);
              },
              onContinue: (){
                bloc.scanNewProduct();
              },
            );
          } else if (state is QueryingProductState) {
            return Column(
              children: [
                Text("Querying...", style: TextStyle(fontSize: 30)),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}













/*
class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      HapticFeedback.vibrate();
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: 200,
            child: MobileScanner(onDetect: _handleBarcode)
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/