import 'dart:async';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularLoadingWidget extends StatefulWidget {
  double? height;

  CircularLoadingWidget({Key? key, this.height}) : super(key: key);

  @override
  _CircularLoadingWidgetState createState() => _CircularLoadingWidgetState();
}

class _CircularLoadingWidgetState extends State<CircularLoadingWidget>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut);
    animation = Tween<double>(begin: widget.height, end: 0).animate(curve)
      ..addListener(() {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      });
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        animationController?.forward();
      }
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Opacity(
            opacity: animation!.value / 100 > 1.0 ? 1.0 : animation!.value / 100,
            child: SizedBox(
              height: animation?.value,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "No Record Found",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              ]);
  }
}
