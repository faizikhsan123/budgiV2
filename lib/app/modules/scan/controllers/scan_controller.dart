import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanController extends GetxController {
  final ImagePicker picker = ImagePicker();

  Rx<File?> imageFile = Rx<File?>(null);
  RxString resultText = "".obs;
  RxBool isLoading = false.obs;

  Future scanFromCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (image == null) return;

    imageFile.value = File(image.path);

    await processImage(File(image.path));
    Get.toNamed(Routes.SCAN);
  }

  Future processImage(File file) async {
    isLoading.value = true;

    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer();

    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    resultText.value = recognizedText.text;

    textRecognizer.close();
    isLoading.value = false;
    
  }
}
