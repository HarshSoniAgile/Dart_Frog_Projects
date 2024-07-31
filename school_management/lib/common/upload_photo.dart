import 'package:cloudinary/cloudinary.dart';
import 'package:dart_frog/dart_frog.dart';

class UploadPhoto {
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: "348824474747564",
    apiSecret: "Ruv63bCecs4H7HRDb0XBH-KOM2Y",
    cloudName: "dqwzkdgq4",
  );

  static Future<String?> uploadPhoto({UploadedFile? photo}) async {
    final res = await cloudinary.upload(fileBytes: await photo?.readAsBytes());

    return res.secureUrl;
  }
}
