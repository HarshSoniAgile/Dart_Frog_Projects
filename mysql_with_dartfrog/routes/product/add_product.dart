import 'package:dart_frog/dart_frog.dart';
import 'package:mysql_with_dartfrog/cloud/cloud_upload.dart';
import 'package:mysql_with_dartfrog/database/mysql_client.dart';
import 'package:mysql_with_dartfrog/model/product_model.dart';
import 'package:mysql_with_dartfrog/validation/validation.dart';
import 'package:tuple/tuple.dart';

Future<Response> onRequest(RequestContext context) async {
  var request = context.request;

  final headers = request.headers;

  // Access the request body form data.
  final formData = await request.formData();

  // Retrieve an uploaded file.
  final photo = formData.files['photo'];

  final dataRepository = context.read<DataSource>();
  ProductModel p = ProductModel.fromJson(formData.fields);

  Tuple2<bool, String> validate = isValidFormAddProduct(p);

  if (validate.item1 == false) {
    return Response.json(body: {"status": 400, "message": validate.item2});
  }

  CloudUpload cloudUpload = CloudUpload();

  final res = await cloudUpload.cloudinary.upload(fileBytes: await photo?.readAsBytes());

  p.photos = res.secureUrl;

  print(p.toJson());

  var rr = dataRepository.addProduct(p);
  print(rr);

  return Response.json(body: {'request_body': formData});
}

Tuple2<bool, String> isValidFormAddProduct(ProductModel productModel) {
  List<Tuple2<ValidationType, String>> arrList = [];
  arrList.add(Tuple2(ValidationType.productName, productModel.name ?? ""));

  final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

  print(validationResult.item2);

  return Tuple2(validationResult.item1, validationResult.item2);
}
