import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


import 'MyRouter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat with Bot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MyRoute.login,
      getPages: MyRoute.getPages,
    );
  }
}

