import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/image_picker_service.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  XFile? imageFile;
  void onClick()async{
    imageFile=await ImagePickerService().pickCropImage(
        cropAspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 16),
        imageSource: ImageSource.gallery);
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: imageFile != null?
        Image(image: FileImage(File(imageFile!.path)))
            :const Text("No image")
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: onClick,
        child: const Icon(Icons.image),
      ),
    );
  }
}
