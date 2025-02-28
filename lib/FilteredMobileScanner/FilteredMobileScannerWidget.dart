import 'package:dunnes_shopping/FilteredMobileScanner/ScannerState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'ScannerCubit.dart';

class FilteredMobileScannerWidget extends StatelessWidget {
  final void Function(String barcode) onDetect;

  const FilteredMobileScannerWidget({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScannerCubit()..init(),
      child: BlocBuilder<ScannerCubit, ScannerState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<ScannerCubit>(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state is ScannedState){
              onDetect(state.barcode);
            }
          });
          return MobileScanner(
            onDetect: (e) => {bloc.newScan(e.barcodes.first.displayValue!)},
          );
        },
      ),
    );
  }
}
