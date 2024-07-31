import 'package:cloudinary/cloudinary.dart';

class CloudUpload {
  /// The .unsignedConfig(...) factory constructor is recommended for client side apps, where [apiKey] and
  /// [apiSecret] must not be used, so .basic(...) constructor allows to do later unsigned requests.
  final cloudinary = Cloudinary.signedConfig(
    apiKey: "348824474747564",
    apiSecret: "Ruv63bCecs4H7HRDb0XBH-KOM2Y",
    cloudName: "dqwzkdgq4",
  );
}
