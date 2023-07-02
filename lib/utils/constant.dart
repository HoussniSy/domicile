import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextStyle style = TextStyle(color: Colors.black, fontSize: 25);

mydialog(BuildContext context,
    {required String title, required String content, required VoidCallback ok}) async {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: ok,
              child: Text("Oui"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text("Non"),
            ),
          ],
        );
      });
}

messages(String msg) {
  return Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
