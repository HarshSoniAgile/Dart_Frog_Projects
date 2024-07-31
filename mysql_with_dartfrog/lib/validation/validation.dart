import 'package:mysql_with_dartfrog/util/app_logger.dart';
import 'package:tuple/tuple.dart';

enum ValidationType { productName, none }

class Validation {
  factory Validation() {
    return _singleton;
  }

  static final Validation _singleton = Validation._internal();

  Validation._internal() {
    Logger().v("Instance created Validation");
  }

  Tuple2<bool, String> validateProductName(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = "Please enter product name.";
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple3<bool, String, ValidationType> checkValidationForTextFieldWithType({List<Tuple2<ValidationType, String>>? list}) {
    Tuple3<bool, String, ValidationType> isValid = const Tuple3(true, '', ValidationType.none);

    for (Tuple2<ValidationType, String> textOption in list ?? []) {
      if (textOption.item1 == ValidationType.productName) {
        final res = validateProductName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.productName);
      }

      if (!isValid.item1) {
        break;
      }
    }
    return isValid;
  }
}
