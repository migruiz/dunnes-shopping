import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FilteredMobileScannerWidget extends StatelessWidget {
  final void Function(BarcodeCapture barcodes)? onDetect;

  const FilteredMobileScannerWidget({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(onDetect: onDetect);
  }
}
