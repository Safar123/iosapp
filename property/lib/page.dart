import 'package:flutter/material.dart';
import 'package:property/home.dart';
import 'package:property/models/route_argument.dart';
import 'package:property/watch_list.dart';

class PageWidget extends StatefulWidget {
  RouteArgument? routeArgument;
  int? currentTab;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  PageWidget({Key? key, this.routeArgument}) {
    currentTab = routeArgument?.page ?? 0;
  }

  @override
  _PageWidgetState createState() {
    return _PageWidgetState();
  }
}

class _PageWidgetState extends State<PageWidget> {
  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage =
              HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage =
              WatchWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(PageWidget oldWidget) {
    _selectTab(oldWidget.currentTab!);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        iconSize: 28,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.8,
        unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
        currentIndex: widget.currentTab!,
        onTap: (int i) {
          _selectTab(i);
        },
        // this will be set when a tab is tapped
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // order
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined), // delivered Order
            label: "Watches",
          ),
        ],
      ),
    );
  }
}
