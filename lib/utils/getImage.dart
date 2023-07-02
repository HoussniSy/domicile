import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImage extends StatelessWidget {
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.black,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Photo de profil",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(height: 10),
          Row(
            children: [
              CircleAvatar(
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    final result = await picker.getImage(source: ImageSource.camera);
                    if (result != null && result.path != null) {
                      Navigator.of(context).pop(File(result.path!));
                    } else {
                      // Handle the case where result or result.path is null
                      // For example, show an error message or handle the absence of an image.
                    }
                  },
                ),
              )
              ,
              Container(width: 10),
              CircleAvatar(
                child: IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () async {
                    final result = await picker.getImage(source: ImageSource.gallery);
                    if (result != null && result.path != null) {
                      Navigator.of(context).pop(File(result.path!));
                    } else {
                      // Handle the case where result or result.path is null
                      // For example, show an error message or handle the absence of an image.
                    }
                  },
                ),
              )
              ,
            ],
          )
        ],
      ),
    );
  }
}
