class AdminModel {
  String name;
  int phoneNumber;
  String aid;

  AdminModel({
    required this.name,
    required this.phoneNumber,
    required this.aid,
  });
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "aid": aid,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
        name: map['name'] ?? '',
        phoneNumber: map['phoneNumber'] is String
            ? int.parse(map['phoneNumber'])
            : map['phoneNumber'] ?? 0,
        aid: map['aid'] ?? '');
  }
}
