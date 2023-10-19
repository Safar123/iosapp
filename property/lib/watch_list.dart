import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'circular_loading_widget.dart';
import 'models/property.dart';

class WatchWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  const WatchWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  State<WatchWidget> createState() => _WatchWidgetState();
}

class _WatchWidgetState extends State<WatchWidget> {
  List<Property>? properties = [];

  @override
  void initState() {
    getWatchProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.5,
          centerTitle: true,
          title: const Text('Watch List'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Clear List',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                clearWatchProperties();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            properties!.isEmpty
                ? CircularLoadingWidget(height: 500)
                : ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(height: 5),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: properties!.length,
                    itemBuilder: (context, index) {
                      return Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.black87),
                        child: ListTile(
                          trailing: Icon(Icons.add),
                          title: Text('${properties?.elementAt(index).name}'),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Price: ${properties?.elementAt(index).price} Address: ${properties?.elementAt(index).address}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.redAccent),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                            ),
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
          ],
        )));
  }

  Future<void> getWatchProperties() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('watch_property_list')) {
      final property_list =
          jsonDecode(prefs.get('watch_property_list') as String);
      properties?.clear();
      setState(() {
        properties!.addAll(property_list
            .map((json) => Property.fromJSON(json))
            .cast<Property>());
      });
    }
  }

  Future<void> clearWatchProperties() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('watch_property_list');
    setState(() {
      properties?.clear();
    });
    Fluttertoast.showToast(
        msg: 'Clear Success', backgroundColor: const Color(0xFF344968));
  }
}
