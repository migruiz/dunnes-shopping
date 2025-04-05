import 'package:dunnes_shopping/LinkProduct/LinkProductWidget.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Dunnes')),
      body: BlocProvider(
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
                        bloc.barcodeFound(
                          barcode: barcode,
                          products: state.products,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = state.products[index];
                        return ListTile(
                          title: Text("${product.name}"),
                          leading: ClipOval(
                            child: Image.network(product.imageUrl),
                          ),
                          trailing: Text(
                            "€${product.price}",
                            style: const TextStyle(fontSize: 32),
                          ),
                          onTap: () async {},
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey, height: 1);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is ProductFoundState) {
              return ProductFoundWidget(
                dunnesProduct: state.dunnesProduct,
                onConfirm: (product) {
                  bloc.confirmProduct(
                    barcode: state.barcode,
                    product: product,
                    products: state.products,
                  );
                },
                onReLink: () {
                  bloc.reLinkProduct(
                    barcode: state.barcode,
                    products: state.products,
                  );
                },
              );
            } else if (state is ProductNotFoundState) {
              return ProductNotFoundWidget(
                barcodeNotFound: state.barcode,
                onLinkBarcode: (barcode) {
                  bloc.linkBarcode(barcode: barcode, products: state.products);
                },
                onContinue: () {
                  bloc.continueShopping(products: state.products);
                },
              );
            } else if (state is QueryingProductState) {
              return Column(
                children: [Text("Querying...", style: TextStyle(fontSize: 30))],
              );
            } else if (state is LinkProductState) {
              return LinkProductWidget(
                barcode: state.barcode,
                onCancel: () {
                  bloc.continueShopping(products: state.products);
                },
                onLinked: ({
                  required String barcode,
                  required String productId,
                }) {
                  bloc.barcodeFound(barcode: barcode, products: state.products);
                },
              );
            }
            return Container();
          },
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).padding.bottom,
        ),
        child: ListTile(
          title: Text("Total € 24.99", style: const TextStyle(fontSize: 32)),
          leading: Icon(
            Icons.calculate_rounded,
            color: Colors.black,
            size: 48.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          onTap: () async {},
        ),
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