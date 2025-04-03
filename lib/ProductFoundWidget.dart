import 'package:flutter/material.dart';

import 'ScanState.dart';

class ProductFoundWidget extends StatelessWidget {
  final ProductFoundState productFoundState;
  final void Function() onConfirm;


  const ProductFoundWidget({super.key, required this.productFoundState, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(productFoundState.imageUrl),
        Text(productFoundState.name, style: const TextStyle(fontSize: 20)),
        Text(
          '€${productFoundState.price}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
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
              onPressed: () {},
              child: Text('CANCEL', style: const TextStyle(fontSize: 30)),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // background color
                foregroundColor: Colors.white, // text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                onConfirm();
              },
              child: Text(
                'CONFIRM',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
