import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class imageProvider extends ChangeNotifier {
  ImagePicker imagePicker = ImagePicker();
  XFile? xFile;
  String? pickImagePath;

  Future<void> pickImage() async {
    xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      pickImagePath = xFile!.path;
      notifyListeners();
    }
  }

  Future<void> pickPhoto() async {
    xFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      pickImagePath = xFile!.path;
      notifyListeners();
    }
  }
}
