import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'circular_loading_widget.dart';
import 'models/property.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  HomeWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<String> categories = ['House', 'Land', 'Unit'];
  List<Property>? properties = [];
  List<Property>? watchProperties = [];

  @override
  void initState() {
    getProperties();
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
        title: Text(
          "Properties",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Clear List',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              clearProperties();
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/Add');
            },
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      getProperties(cat: categories[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(categories[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ));
              },
            ),
            const Divider(height: 10),
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
                        child: GestureDetector(
                            onDoubleTap: () {
                              addWatchList(properties!.elementAt(index));
                            },
                            child: ListTile(
                              trailing: Icon(Icons.add),
                              title:
                                  Text('${properties?.elementAt(index).name}'),
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
                            )),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> getProperties({String? cat}) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('property_list')) {
      final property_list = jsonDecode(prefs.get('property_list') as String);
      properties?.clear();
      setState(() {
        if (cat != null) {
          properties!.addAll(property_list
              .where((json) {
                final property = Property.fromJSON(json);
                return property.category == cat;
              })
              .map((json) => Property.fromJSON(json))
              .cast<Property>());
        } else {
          properties!.addAll(property_list
              .map((json) => Property.fromJSON(json))
              .cast<Property>());
        }
      });
    }
  }

  Future<void> addWatchList(Property property) async {
    watchProperties?.add(property);
    String propertiesJson = jsonEncode(
        watchProperties?.map((property) => property.toMap()).toList());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('watch_property_list', propertiesJson);
    Fluttertoast.showToast(
        msg: 'Added to watch list', backgroundColor: const Color(0xFF344968));
  }

  Future<void> getWatchProperties() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('watch_property_list')) {
      final property_list =
          jsonDecode(prefs.get('watch_property_list') as String);
      watchProperties?.clear();
      setState(() {
        watchProperties!.addAll(property_list
            .map((json) => Property.fromJSON(json))
            .cast<Property>());
      });
    }
  }

  Future<void> clearProperties() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('property_list');
    setState(() {
      properties?.clear();
      watchProperties?.clear();
    });
    Fluttertoast.showToast(
        msg: 'Clear Success', backgroundColor: const Color(0xFF344968));
  }
}
