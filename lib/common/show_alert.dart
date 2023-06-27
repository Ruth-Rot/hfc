import 'package:flutter/material.dart';

Widget showAlert(bool errorS, String error) {
    if (errorS) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: Text(
              error,
            ))
          ],
        ),
      );
    }
    return const SizedBox(height: 0.0);
  }