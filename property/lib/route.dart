import 'package:flutter/material.dart';
import 'package:property/add_properties.dart';
import 'package:property/home.dart';
import 'package:property/page.dart';
import 'package:property/models/route_argument.dart';
import 'package:property/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => Splash());
        case '/Add':
        return MaterialPageRoute(builder: (_) => AddPropertyWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PageWidget(routeArgument: args as RouteArgument));
      case '/Home':
        return MaterialPageRoute(builder: (_) => HomeWidget());
        default:
        return _errorRoute();
    }

  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('404'),
        ),
      );
    });
  }

}
