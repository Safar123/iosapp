class Property {
  String? name;
  String? price;
  String? address;
  String? category;
  String? watch;

  Property();

  Property.fromJSON(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'] ?? '';
    price = jsonMap['price'] ?? '';
    address = jsonMap['address'] ?? '';
    category = jsonMap['category'] ?? '';
    watch = jsonMap['watch'] ?? '';
  }

  Map toMap() {
    var map = <String?, dynamic>{};
    map["name"] = name;
    map["price"] = price;
    map["address"] = address;
    map["category"] = category;
    map["watch"] = watch;
    return map;
  }
}
