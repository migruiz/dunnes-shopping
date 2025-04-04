import 'package:flutter/material.dart';

import '../DunnesProductData.dart';

class ProductFoundWidget extends StatelessWidget {
  final DunnesProductData dunnesProduct;
  final void Function(DunnesProductData) onConfirm;
  final void Function() onReLink;


  const ProductFoundWidget({super.key, required this.dunnesProduct, required this.onConfirm, required this.onReLink});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(dunnesProduct.imageUrl),
        Text(dunnesProduct.name, style: const TextStyle(fontSize: 20)),
        Text(
          '€${dunnesProduct.price}',
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
                onReLink();
              },
              child: Text('RE-LINK', style: const TextStyle(fontSize: 30)),
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
                onConfirm(dunnesProduct);
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
