import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler;
  // return handler.use(
  //   bearerAuthentication<UserModel>(
  //     authenticator: (context, token) async {
  //       print("**** $token");
  //       return verifyToken(token);
  //     },
  //   ),
  // );
}
