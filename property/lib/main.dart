import 'package:flutter/material.dart';
import 'package:property/route.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Property',
        initialRoute: '/Splash',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          dividerTheme: const DividerThemeData(
            color: Colors.black12,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[300],
            contentPadding: const EdgeInsets.all(15),
            border: const OutlineInputBorder(
                borderSide: BorderSide.none),
          ),
          primaryColor: Colors.white,
          brightness: Brightness.light,
        ));
  }
}
