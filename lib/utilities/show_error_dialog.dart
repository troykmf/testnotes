/*the below function is used to display the error which is going to be handled 
to the user on the screen*/
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text, // the supposed error text which is going to be displayed
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An Error occured'),
        content: Text(text), // the supposed error text
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
