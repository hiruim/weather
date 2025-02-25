import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NoInternetDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85), // Dims the background
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.orange, size: 40),
            SizedBox(height: 10),
            Text(
              "No Internet Connection",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          "You are currently offline.\nPlease check your internet connection and try again.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              var connectivityResult = await Connectivity().checkConnectivity();
              if (connectivityResult != ConnectivityResult.none) {
                Navigator.pop(context);
              }
            },
            child: Text("Retry", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
