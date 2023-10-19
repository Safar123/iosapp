import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:property/models/property.dart';
import 'package:property/models/route_argument.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPropertyWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  AddPropertyWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _AddPropertyWidget createState() => _AddPropertyWidget();
}

class _AddPropertyWidget extends State<AddPropertyWidget> {
  String? catValue;
  Property property = Property();
  List<Property>? properties = <Property>[];

  GlobalKey<FormState>? propertyFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    getProperties();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushReplacementNamed('/Pages', arguments: RouteArgument(page: 0));
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          shadowColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pushReplacementNamed(
                '/Pages',
                arguments: RouteArgument(page: 0)),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            "Add Properties",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Form(
            key: propertyFormKey!,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                const Text(
                  "Fill Property Details",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Property Name",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onSaved: (input) => property.name = input,
                  validator: (input) => input!.isEmpty
                      ? "Property Name field is required."
                      : null,
                  decoration: const InputDecoration(
                    hintText: "",
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Property Price",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onSaved: (input) => property.price = input,
                  validator: (input) => input!.isEmpty
                      ? "Property Price field is required."
                      : null,
                  decoration: const InputDecoration(
                    hintText: "",
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Property Address",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onSaved: (input) => property.address = input,
                  validator: (input) => input!.isEmpty
                      ? "Property Address field is required."
                      : null,
                  decoration: const InputDecoration(
                    hintText: "",
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Property Categories",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: catValue,
                  onSaved: (input) => property.category = input,
                  onChanged: (_catValue) =>
                      setState(() => catValue = _catValue!),
                  validator: (value) => value == '' ? 'field required' : null,
                  decoration: const InputDecoration(
                    hintText: 'Select Categories',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'House',
                      child: Text("House"),
                    ),
                    DropdownMenuItem(
                      value: 'Unit',
                      child: Text("Unit"),
                    ),
                    DropdownMenuItem(
                      value: 'Land',
                      child: Text("Land"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 14),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onPressed: () {
                    save(property);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Future<void> save(Property property) async {
    FocusScope.of(context).unfocus();
    if (propertyFormKey!.currentState!.validate()) {
      propertyFormKey?.currentState?.save();
      properties!.add(property);
      String propertiesJson = jsonEncode(properties?.map((property) => property.toMap()).toList());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('property_list', propertiesJson);
      propertyFormKey!.currentState!.reset();
      Fluttertoast.showToast(
          msg: 'Property successfully added', backgroundColor: const Color(0xFF344968));
    }
  }

  Future<void> getProperties() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('property_list')) {
      final property_list = jsonDecode(prefs.get('property_list') as String);
      properties?.clear();
      setState(() {
          properties!.addAll(property_list
              .map((json) => Property.fromJSON(json))
              .cast<Property>());
      });
    }
  }
}
