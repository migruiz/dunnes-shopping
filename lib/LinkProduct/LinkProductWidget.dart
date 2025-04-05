import 'package:dunnes_shopping/LinkProduct/LinkProductCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LinkProductState.dart';
import 'ProductFoundWidget.dart';

class LinkProductWidget extends StatelessWidget {
  final String barcode;
  final void Function() onCancel;
  final void Function({required String barcode,required String productId}) onLinked;

  const LinkProductWidget({
    super.key,
    required this.barcode,
    required this.onCancel,
    required this.onLinked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LinkProductCubit()..init(barcode: barcode),
      child: BlocConsumer<LinkProductCubit, LinkProductState>(
        listener: (context, state) {
          if (state is LinkedState){
            onLinked(barcode: state.barcode, productId: state.productId);
          }
        },
        builder: (context, state) {
          final bloc = BlocProvider.of<LinkProductCubit>(context);
          if (state is InitState) {
            return Column(
              children: [
                Text(
                  "Not Found ${state.barcode}",
                  style: TextStyle(fontSize: 30),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse('https://www.dunnesstoresgrocery.com/'),
                    );
                  },
                  child: Text('Search Dunnes Database'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bloc.searchFromClipboard();
                    
                  },
                  child: Text('Search from Clipboard'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // background color
                        foregroundColor: Colors.red, // text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        onCancel();
                      },
                      child: Text(
                        'CANCEL',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          else if (state is ProductFoundState) {
            return ProductFoundWidget(
              product: state.product,
              onConfirm: (product) {
                bloc.linkProduct(barcode: barcode, dunnesProduct: product);
              },
              onCancel: () {
               bloc.init(barcode: barcode);
              },
            );
          }
          else if (state is NotFoundState) {
            return Text("Not Found");
          }
          return Container();
        },
      ),
    );
  }
}
