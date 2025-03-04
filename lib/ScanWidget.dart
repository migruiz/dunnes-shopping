import 'package:dunnes_shopping/ProductFoundWidget.dart';
import 'package:dunnes_shopping/ProductNotFoundWidget.dart';
import 'package:dunnes_shopping/ScanState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'FilteredMobileScanner/FilteredMobileScannerWidget.dart';
import 'ScanCubit.dart';

class ScanWidget extends StatelessWidget {
  const ScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScanCubit()..init(),
      child: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<ScanCubit>(context);
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
              notFoundState: state,
              onConfirm: () {
                bloc.linkBarcode(state.barcode);
              },
            );
          } else if (state is QueryingProductState) {
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