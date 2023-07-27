import 'dart:io';
import 'dart:convert';

class ImageUtil {
  static String encodeImageToBase64(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    return base64Encode(imageBytes);
  }
}
