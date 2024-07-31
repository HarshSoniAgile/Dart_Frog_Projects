import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SendMail {
  static String userName = 'harshsoni.agileinfoways@gmail.com';
  static String password = 'mysb vbix xqxs mzgf';

  static Future<bool> sendMail({String? mail, String? generatedPassword}) async {
    final smtpServer = gmail(userName, password);

    // Create our message.
    final message = Message()
      ..from = Address(userName, 'Harsh Soni')
      ..recipients.add(mail)
      ..ccRecipients.addAll([])
      ..subject = 'School Management'
      ..text = 'your password is : '
      ..html = '<p>your password is : </p><h1>$generatedPassword</h1>';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
      return true;
    } on MailerException catch (e) {
      print('Message not sent. $e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}
