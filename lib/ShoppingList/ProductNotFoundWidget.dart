import 'package:flutter/material.dart';

class ProductNotFoundWidget extends StatelessWidget {
  final String barcodeNotFound;
  final void Function() onContinue;
  final void Function(String) onLinkBarcode;

  const ProductNotFoundWidget({
    super.key,
    required this.barcodeNotFound,
    required this.onContinue,
    required this.onLinkBarcode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Not Found", style: TextStyle(fontSize: 30)),
        
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // background color
                foregroundColor: Colors.green, // text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                onContinue();
              },
              child: Text('CONTINUE', style: const TextStyle(fontSize: 30)),
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
                onLinkBarcode(barcodeNotFound);
              },
              child: Text(
                'SEARCH & LINK',
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
