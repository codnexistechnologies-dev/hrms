import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CaptureImageWithDetails extends StatefulWidget {
  const CaptureImageWithDetails({super.key});

  @override
  _CaptureImageWithDetailsState createState() =>
      _CaptureImageWithDetailsState();
}

class _CaptureImageWithDetailsState extends State<CaptureImageWithDetails> {
  File? _imageWithDetails;
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageWithDetails = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Image with Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _captureImage,
              icon: Icon(Icons.camera),
              label: Text('Capture Picture'),
            ),
            SizedBox(height: 20),
            if (_imageWithDetails != null)
              Column(
                children: [
                  Image.file(
                    _imageWithDetails!,
                    height: 300,
                  ),
                  SizedBox(height: 10),
                  Text("Image with details is shown above."),
                ],
              )
            else
              Text('No image captured', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
