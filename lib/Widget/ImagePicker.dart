import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserImageInput extends StatefulWidget {
  final void Function(File imageFile) imageGetter;

  UserImageInput({required this.imageGetter});

  @override
  _UserImageInputState createState() => _UserImageInputState();
}

class _UserImageInputState extends State<UserImageInput> {
  File? imageFile;
  bool state = false;

  Future<void> _pickImageGallery() async {
    final pickedImage = await ImagePicker.platform.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 300,
        maxHeight: 300);
    setState(() {
      imageFile = File(pickedImage!.path);
      if (imageFile != null) {
        state = true;
        widget.imageGetter(imageFile!);
      }
    });
  }

  Future<void> _pickImageCamera() async {
    final pickedImage = await ImagePicker.platform.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 300,
        maxHeight: 300);
    setState(() {
      imageFile = File(pickedImage!.path);
      if (imageFile != null) {
        state = true;
        widget.imageGetter(imageFile!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          child: !state
              ? const Icon(
                  Icons.portrait,
                  size: 45,
                  color: Colors.white,
                )
              : null,
          backgroundImage: state ? FileImage(imageFile!) : null,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "Profile Picture",
            style: GoogleFonts.poppins(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: _pickImageGallery,
              icon: const Icon(Icons.image),
              label: const Text("Gallery"),
            ),
            TextButton.icon(
              onPressed: _pickImageCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Camera"),
            )
          ],
        )
      ],
    );
  }
}
