import 'package:flutter/material.dart';

class AlertDialogNotify extends StatelessWidget {
  const AlertDialogNotify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error !!'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'You can\'t order from different reataurants\nPlease make your order with the same restaurant only.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Got It'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
