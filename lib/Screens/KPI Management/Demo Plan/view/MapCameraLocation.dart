import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapCameraLocation extends StatefulWidget {
  final Function(ImageAndLocationData data) onImageCaptured;

  const MapCameraLocation({required this.onImageCaptured, super.key});

  @override
  _MapCameraLocationState createState() => _MapCameraLocationState();
}

class _MapCameraLocationState extends State<MapCameraLocation> {
  File? _image;
  double? _latitude;
  double? _longitude;
  String? _address;
  String? _subLocation;
  DateTime? _capturedDateTime;

  final ImagePicker _picker = ImagePicker();

  // Capture Image and Fetch Location
  Future<void> _captureImageAndLocation() async {
    try {
      // Capture image from camera
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        _image = File(pickedFile.path);

        // Get current location
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        _latitude = position.latitude;
        _longitude = position.longitude;

        // Get address from coordinates
        List<Placemark> placemarks =
            await placemarkFromCoordinates(_latitude!, _longitude!);

        if (placemarks.isNotEmpty) {
          _address = placemarks.first.street;
          _subLocation = placemarks.first.subLocality;
        }

        // Get current date-time
        _capturedDateTime = DateTime.now();

        // Callback with image and location data
        widget.onImageCaptured(ImageAndLocationData(
          imagePath: _image!.path,
          latitude: _latitude!,
          longitude: _longitude!,
          locationName: _address ?? "Unknown",
          subLocation: _subLocation ?? "Unknown",
          capturedDateTime: _capturedDateTime!,
        ));

        setState(() {}); // Update UI
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Image capture canceled.")));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to capture image and location.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map Camera Location")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _captureImageAndLocation,
              icon: Icon(Icons.camera),
              label: Text("Capture Image with Location"),
            ),
            SizedBox(height: 20),
            if (_image != null)
              Column(
                children: [
                  Image.file(_image!, height: 300),
                  SizedBox(height: 10),
                  Text("Latitude: $_latitude"),
                  Text("Longitude: $_longitude"),
                  Text("Address: $_address"),
                  Text("Sub-location: $_subLocation"),
                  Text("Captured Date-Time: $_capturedDateTime"),
                ],
              ),
            if (_image == null) Text("No image captured yet.")
          ],
        ),
      ),
    );
  }
}

class ImageAndLocationData {
  final String imagePath;
  final double latitude;
  final double longitude;
  final String locationName;
  final String subLocation;
  final DateTime capturedDateTime;

  ImageAndLocationData({
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.subLocation,
    required this.capturedDateTime,
  });
}

// void main() {
//   runApp(MaterialApp(
//     home: MapCameraLocation(
//       onImageCaptured: (ImageAndLocationData data) {
//         print('Captured image path: ${data.imagePath}');
//         print('Latitude: ${data.latitude}');
//         print('Longitude: ${data.longitude}');
//         print('Location name: ${data.locationName}');
//         print('Sublocation: ${data.subLocation}');
//         print('Captured Date-Time: ${data.capturedDateTime}');
//       },
//     ),
//   ));
// }
