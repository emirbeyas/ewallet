class OutType {
  late int id;
  late String description;

  OutType(this.description);
  OutType.withId(this.id, this.description);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["description"] = description;
    return map;
  }

  OutType.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    description = map["description"];
  }
}
