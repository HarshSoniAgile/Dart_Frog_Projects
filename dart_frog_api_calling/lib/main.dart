import 'package:dart_frog_api_calling/ui/product/product_binding.dart';
import 'package:dart_frog_api_calling/ui/product/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'network_manager/api_constant.dart';

var env = Environment.local;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   home: AddUserScreen(),
    // );

    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      initialBinding: ProductBinding(),
      home: ProductListScreen(),
    );
  }
}
