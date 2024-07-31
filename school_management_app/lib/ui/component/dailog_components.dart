import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:school_management_app/ui/component/alert_component.dart';

typedef AlertWidgetButtonActionCallback = void Function(int index);

class DialogComponent {
  static showAlert(
    BuildContext context, {
    String? title,
    String? message,
    List<String>? arrButton,
    bool barrierDismissible = false,
    AlertWidgetButtonActionCallback? callback,
  }) {
    Widget alertDialog = AlertWidget(
      title: title ?? "",
      message: message,
      buttonOption: arrButton,
      onCompletion: callback,
    );

    if (!barrierDismissible) {
      alertDialog = WillPopScope(
        child: alertDialog,
        onWillPop: () async {
          return false;
        },
      );
    }

    // flutter defined function
    // showDialog(
    //   barrierDismissible: barrierDismissible,
    //   context: context,
    //   builder: (BuildContext context1) {
    //     return alertDialog;
    //   },
    // );

    showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: "",
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: alertDialog,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static showCupertinoModelPopupDatePicker(
      {required BuildContext context,
      DateTime? initialDate,
      DateTime? maximumDate,
      DateTime? minimumDate,
      required ValueChanged<DateTime> onDateTimeChangedFunction,
      VoidCallback? onDoneButtonPress}) {
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 360,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                onPressed: onDoneButtonPress ?? () => Get.back(),
                child: Text(
                  "Done",
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate ?? DateTime.now(),
                minimumDate: minimumDate ?? DateTime(1950),
                maximumDate: maximumDate ?? DateTime.now(),
                onDateTimeChanged: (val) {
                  onDateTimeChangedFunction(val);
                },
              ),
            ),

            // Close the modal
          ],
        ),
      ),
    );
  }
}
