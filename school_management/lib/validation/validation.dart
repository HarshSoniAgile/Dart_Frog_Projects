// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_single_quotes, omit_local_variable_types, prefer_final_in_for_each, lines_longer_than_80_chars

import 'package:school_management/common/app_logger.dart';
import 'package:school_management/common/string_const.dart';
import 'package:tuple/tuple.dart';

enum ValidationType {
  name,
  parentNumber,
  email,
  address,
  password,
  photo,
  zipcode,
  std,
  city,
  state,
  contry,
  dob,
  none,
}

class Validation {
  factory Validation() {
    return _singleton;
  }

  static final Validation _singleton = Validation._internal();

  Validation._internal() {
    Logger().v("Instance created Validation");
  }

  Tuple2<bool, String> validateName(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateName;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateParentNumber(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateParentNumber;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateEmail(String value) {
    var errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateEmail;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateAddress(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateAddress;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateDob(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateDob;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validatePhoto(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validatePhoto;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateZipcode(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateZipcode;
    } else if (value.length > 6) {
      errorMessage = StringConst.validateValidZipcode;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateStd(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateStd;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateCity(String value) {
    var errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateCity;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateState(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateState;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateContry(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validateContry;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validatePassword(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = StringConst.validatePassword;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple3<bool, String, ValidationType> checkValidationForTextFieldWithType({List<Tuple2<ValidationType, String>>? list}) {
    Tuple3<bool, String, ValidationType> isValid = const Tuple3(true, '', ValidationType.none);

    for (Tuple2<ValidationType, String> textOption in list ?? []) {
      if (textOption.item1 == ValidationType.name) {
        final res = validateName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.name);
      } else if (textOption.item1 == ValidationType.email) {
        final res = validateEmail(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.email);
      } else if (textOption.item1 == ValidationType.address) {
        final res = validateAddress(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.address);
      } else if (textOption.item1 == ValidationType.photo) {
        final res = validatePhoto(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.photo);
      } else if (textOption.item1 == ValidationType.zipcode) {
        final res = validateZipcode(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.zipcode);
      } else if (textOption.item1 == ValidationType.city) {
        final res = validateCity(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.city);
      } else if (textOption.item1 == ValidationType.state) {
        final res = validateState(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.state);
      } else if (textOption.item1 == ValidationType.contry) {
        final res = validateContry(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.contry);
      } else if (textOption.item1 == ValidationType.std) {
        final res = validateStd(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.std);
      } else if (textOption.item1 == ValidationType.dob) {
        final res = validateDob(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.dob);
      } else if (textOption.item1 == ValidationType.parentNumber) {
        final res = validateParentNumber(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.parentNumber);
      } else if (textOption.item1 == ValidationType.password) {
        final res = validatePassword(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.password);
      }

      if (!isValid.item1) {
        break;
      }
    }
    return isValid;
  }
}
