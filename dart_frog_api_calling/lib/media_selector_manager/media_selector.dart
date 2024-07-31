// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io' show File, Platform;

import 'package:dart_frog_api_calling/app_logger.dart';
import 'package:dart_frog_api_calling/platform_channel/platform_channel.dart';
import 'package:dart_frog_api_calling/ui/component/dailog_components.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

//Type:0 Image 1 Video
typedef ImageSelectionCallBack = void Function(List<File>? file, int type);

enum MediaFor { profile }

class MediaSelector {
  factory MediaSelector() {
    return _singleton;
  }

  static final MediaSelector _singleton = MediaSelector._internal();

  MediaSelector._internal() {
    Logger().v("Instance created MediaSelector");
  }

  String _getMessageForTitle(MediaFor purpose) {
    if (purpose == MediaFor.profile) {
      return "GoatGrub needs to take photo from camera or your library ";
    }
    return "";
  }

  String _getMessageForPermission(MediaFor purpose, ImageSource source) {
    if (source == ImageSource.camera) {
      if (purpose == MediaFor.profile) {
        return "GoatGrub needs photo permission to take photo from your library, go to settings and allow access";
      } else {
        return "msgCameraPermission";
      }
    } else {
      if (purpose == MediaFor.profile) {
        return "GoatGrub needs photo permission to take photo from your library, go to settings and allow access";
      } else {
        return "msgPhotoPermission";
      }
    }
  }

  //endregion

  //region Open setting
  Future<void> _openSetting({required String message}) async {
    DialogComponent.showAlert(
      Get.context!,
      title: "",
      message: message,
      arrButton: ["Cancel", "Ok"],
      callback: (index) async {
        if (index == 1) {
          Future.delayed(
            const Duration(seconds: 1),
            () async {
              await PlatformChannel().openSettings();
            },
          );
        }
      },
    );
  }

  //endregion

  //region Ask user for option
  void chooseImageWithOption(
      {required MediaFor purpose, required ImageSelectionCallBack callBack, bool isImageResize = true, bool isCropImage = false}) {
    var arrButton = ["Camera", "Gallery"];

    if (Platform.isAndroid) {
      arrButton.insert(0, "Cancel");
    }

    final message = _getMessageForTitle(purpose);
    if (Platform.isAndroid) {
      DialogComponent.showAlert(Get.context!, message: message, barrierDismissible: true, arrButton: arrButton, callback: (int index) {
        if (index == 0) {
          return;
        }
        ImageSource sourceType = (index == 1) ? ImageSource.camera : ImageSource.gallery;
        onPickImageAction(isCropImage: isCropImage, purpose: purpose, source: sourceType, callBack: callBack, isImageResize: isImageResize);
      });
    } else if (Platform.isIOS) {
      DialogComponent.showAlert(Get.context!, message: message, barrierDismissible: true, arrButton: arrButton, callback: (int index) {
        // if (index == 0) {
        //   return;
        // }
        ImageSource sourceType = (index == 0) ? ImageSource.camera : ImageSource.gallery;
        onPickImageAction(isCropImage: isCropImage, purpose: purpose, source: sourceType, callBack: callBack, isImageResize: isImageResize);
      });
    }
  }

  //endregion

  //region PickImage with option
  Future onPickImageAction({
    required MediaFor purpose,
    required ImageSource source,
    int maxImages = 1,
    required ImageSelectionCallBack callBack,
    bool isImageResize = true,
    bool isCropImage = false,
  }) async {
    String messageDecline = _getMessageForPermission(purpose, source);
    late var androidInfo;
    androidInfo = Platform.isIOS ? await DeviceInfoPlugin().iosInfo : await DeviceInfoPlugin().androidInfo;

    if (source == ImageSource.camera) {
      bool permissionAllowed = await PlatformChannel().checkForPermission(Permission.camera);
      if (permissionAllowed && Platform.isAndroid) {
        permissionAllowed = await PlatformChannel().checkForPermission((androidInfo.version.sdkInt < 33) ? Permission.storage : Permission.photos);
      }
      if (!permissionAllowed) {
        Logger().w("Permission Declined for Camera");
        _openSetting(message: messageDecline);
        callBack(null, 0);
        return;
      }
    } else {
      Permission permission = Platform.isIOS
          ? Permission.photos
          : (androidInfo.version.sdkInt < 33)
              ? Permission.storage
              : Permission.photos;
      bool permissionAllowed = await PlatformChannel().checkForPermission(permission);
      if (!permissionAllowed) {
        Logger().w("Permission Declined for Photo");
        _openSetting(message: messageDecline);
        callBack(null, 0);
        return;
      }
    }

    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile;
      if (isImageResize) {
        pickedFile = await picker.pickImage(
            source: source,
            maxHeight: 1080.0,
            maxWidth: 720.0,
            preferredCameraDevice: purpose == MediaFor.profile ? CameraDevice.front : CameraDevice.rear);
      } else {
        pickedFile = await picker.pickImage(
            source: source,
            maxHeight: 1080.0,
            maxWidth: 720.0,
            preferredCameraDevice: purpose == MediaFor.profile ? CameraDevice.front : CameraDevice.rear);
        //pickedFile = await _picker.pickImage(source: source);
      }

      File? selectedFile = (pickedFile != null) ? File(pickedFile.path) : null;
      if ((pickedFile != null) && isCropImage) {
        /// Need To Crop Picker implement

        CroppedFile? croppedImage;
        try {
          croppedImage = await ImageCropper().cropImage(
            sourcePath: pickedFile.path,
            aspectRatioPresets: setAspectRatios(),
            uiSettings: buildUiSettings(),
          );
          selectedFile = File(croppedImage!.path);
        } catch (e) {
          // showErrorToast(context, "$e");
        }
      } else if (pickedFile != null) {
        selectedFile = File(pickedFile.path);
      } else {
        selectedFile = null;
      }
      Logger().v("Path Galley :: ${selectedFile?.path ?? ''}");
      if (selectedFile != null) {
        File fixedRotationFile = await FlutterExifRotation.rotateAndSaveImage(path: selectedFile.path);
        Logger().v("Path Fixed Rotation Galley :: ${fixedRotationFile.path}");
        selectedFile = fixedRotationFile;
      }
      Logger().v("Path Fixed Rotation Galley :: $selectedFile");
      callBack((selectedFile != null) ? [selectedFile] : null, 0);
    } catch (error) {
      Logger().v("Error :: ${error.toString()}");
    }
  }

//endregion
}

/// set aspect ratios to crop while selecting an image across an app
List<CropAspectRatioPreset> setAspectRatios() {
  return [
    CropAspectRatioPreset.square,
    CropAspectRatioPreset.ratio3x2,
    CropAspectRatioPreset.ratio4x3,
    CropAspectRatioPreset.ratio16x9,
    CropAspectRatioPreset.original,
  ];
}

/// Android / iOS UI for cropping page screen
List<PlatformUiSettings>? buildUiSettings() {
  return [
    AndroidUiSettings(
      toolbarTitle: 'Crop Image',
      initAspectRatio: CropAspectRatioPreset.square,
      lockAspectRatio: false,
      toolbarColor: Colors.white,
    ),
    IOSUiSettings(
      title: 'Crop Image',
    ),
  ];
}
