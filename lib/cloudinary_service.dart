import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // To use kIsWeb

class CloudinaryService {
  // IMPORTANT: For a real app, do not hardcode these values.
  // Use environment variables instead.
  // NOTE: This is for unsigned, client-side uploads.
  // The API key and secret you provided are for secure, signed uploads,
  // which would require a backend server to implement.
  static const String _cloudName = 'dwkkfueo0';
  static const String _uploadPreset = 'zedtutors_uploads';

  static Future<String?> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = jsonDecode(utf8.decode(responseData));

      if (response.statusCode == 200) {
        return result['secure_url'];
      } else {
        print('Cloudinary upload failed: ${result['error']['message']}');
        return null;
      }
    } catch (e) {
      print('An error occurred during Cloudinary upload: $e');
      return null;
    }
  }
}
