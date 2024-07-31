// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../main.dart' as entrypoint;
import '../routes/index.dart' as index;
import '../routes/get_user_by_password.dart' as get_user_by_password;
import '../routes/add_user.dart' as add_user;
import '../routes/product/get_product_list.dart' as product_get_product_list;
import '../routes/product/get_product.dart' as product_get_product;
import '../routes/product/edit_product.dart' as product_edit_product;
import '../routes/product/delete_product.dart' as product_delete_product;
import '../routes/product/add_product.dart' as product_add_product;
import '../routes/auth/login.dart' as auth_login;

import '../routes/_middleware.dart' as middleware;
import '../routes/auth/_middleware.dart' as auth_middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return entrypoint.run(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/auth', (context) => buildAuthHandler()(context))
    ..mount('/product', (context) => buildProductHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildAuthHandler() {
  final pipeline = const Pipeline().addMiddleware(auth_middleware.middleware);
  final router = Router()
    ..all('/login', (context) => auth_login.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildProductHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/get_product_list', (context) => product_get_product_list.onRequest(context,))..all('/get_product', (context) => product_get_product.onRequest(context,))..all('/edit_product', (context) => product_edit_product.onRequest(context,))..all('/delete_product', (context) => product_delete_product.onRequest(context,))..all('/add_product', (context) => product_add_product.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,))..all('/get_user_by_password', (context) => get_user_by_password.onRequest(context,))..all('/add_user', (context) => add_user.onRequest(context,));
  return pipeline.addHandler(router);
}

