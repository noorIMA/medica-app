class UserModel {
  String firstName;
  String lastName;
  String email;
  String profilePic;
  String gender;
  String dateOfBirth;
  String createdAt;
  String phoneNumber;
  String uid;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.profilePic,
      required this.gender,
      required this.dateOfBirth,
      required this.createdAt,
      required this.phoneNumber,
      required this.uid});
  //get date from
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        firstName: map['firstName'] ?? '',
        lastName: map['lastName'] ?? '',
        email: map['email'] ?? '',
        profilePic: map['profilePic'] ?? '',
        gender: map['gender'] ?? '',
        dateOfBirth: map['dateOfBirth'] ?? '',
        createdAt: map['createdAt'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        uid: map['uid'] ?? '');
  }

  //sending data to the server
  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "profilePic": profilePic,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "createdAt": createdAt,
      "phoneNumber": phoneNumber,
      "uid": uid,
    };
  }
}
