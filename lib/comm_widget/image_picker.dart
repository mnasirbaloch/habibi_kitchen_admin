import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  const ImagePickerButton({super.key});

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  File? _pickedImage; // Use File? instead of late File?

  Future<void> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _pickedImage != null
            ? Image.file(_pickedImage!)
            : const Placeholder(
                fallbackWidth: 200,
                fallbackHeight: 200,
              ),
        ElevatedButton(
          onPressed: _pickImageFromGallery,
          child: const Text("Pick Image from Gallery"),
        ),
      ],
    );
  }
}
