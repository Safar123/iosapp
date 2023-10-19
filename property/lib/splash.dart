import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:property/models/route_argument.dart';

// ignore: use_key_in_widget_constructors
class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(const Duration(seconds: 2), () => onDoneLoading());
  }

  onDoneLoading() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .pushReplacementNamed('/Pages', arguments: RouteArgument(page: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
