import 'package:flutter/material.dart';

import '../DunnesProductData.dart';

class ProductFoundWidget extends StatelessWidget {
  final DunnesProductData product;
  final void Function(DunnesProductData) onConfirm;
  final void Function() onCancel;


  const ProductFoundWidget({super.key, required this.product, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(product.imageUrl),
        Text(product.name, style: const TextStyle(fontSize: 20)),
        Text(
          '€${product.price}',
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
              onPressed: () {
                onCancel();
              },
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
                onConfirm(product);
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
