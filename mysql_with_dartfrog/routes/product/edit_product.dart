import 'package:dart_frog/dart_frog.dart';
import 'package:mysql_with_dartfrog/cloud/cloud_upload.dart';
import 'package:mysql_with_dartfrog/database/mysql_client.dart';
import 'package:mysql_with_dartfrog/model/product_model.dart';

Future<Response> onRequest(RequestContext context) async {
  var request = context.request;

  final formData = await request.formData();

  // Retrieve an uploaded file.
  final photo = formData.files['photo'];

  print(photo);

  final dataRepository = context.read<DataSource>();
  ProductModel p = ProductModel.fromJson(formData.fields);

  if (photo != null) {
    CloudUpload cloudUpload = CloudUpload();

    final res = await cloudUpload.cloudinary.upload(fileBytes: await photo.readAsBytes());

    p.photos = res.secureUrl;
  }

  print(p.toJson());

  dataRepository.editProduct(p);

  return Response.json(body: {'request_body': ""});
}
