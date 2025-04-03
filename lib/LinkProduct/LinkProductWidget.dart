import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkProductWidget extends StatelessWidget {
  final String barcode;
  final void Function() onCancel;
  final void Function(String) onLinked;

  const LinkProductWidget({
    super.key,
    required this.barcode,
    required this.onCancel,
    required this.onLinked
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Not Found " + this.barcode, style: TextStyle(fontSize: 30)),
        ElevatedButton(
          onPressed: () async {
            await launchUrl(Uri.parse('https://www.dunnesstoresgrocery.com/'));
          },
          child: Text('Search Dunnes Database'),
        ),
        ElevatedButton(
          onPressed: () async {
            final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
            String? clipboardText = clipboardData?.text;
            print(clipboardText);
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
                onLinked(barcode);
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
