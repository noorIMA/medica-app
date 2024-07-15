class DoctorModel {
  String name_en;
  String name_ar;
  int phoneNumber;
  double Latitude;
  double Longitude;
  int rating;
  int experience;
  String gender;
  String description;
  String email;
  String photoUrl;
  String specialization;
  String hospital;
  String did;

  DoctorModel({
    required this.name_en,
    required this.name_ar,
    required this.phoneNumber,
    required this.Latitude,
    required this.Longitude,
    required this.rating,
    required this.experience,
    required this.gender,
    required this.description,
    required this.email,
    required this.photoUrl,
    required this.specialization,
    required this.hospital,
    required this.did,
  });
  Map<String, dynamic> toMap() {
    return {
      "name_en": name_en,
      "name_ar": name_ar,
      "phoneNumber": phoneNumber,
      "Latitude": Latitude,
      "Longitude": Longitude,
      "rating": rating,
      "experience": experience,
      "gender": gender,
      "description": description,
      "email": email,
      "photoUrl": photoUrl,
      "specialization": specialization,
      "hospital": hospital,
      "did": did,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
        name_en: map['name_en'] ?? '',
        name_ar: map['name_ar'] ?? '',
        phoneNumber: map['phoneNumber'] is String
            ? int.parse(map['phoneNumber'])
            : map['phoneNumber'] ?? 0,
        Latitude: map['Latitude'] is String
            ? double.parse(map['Latitude'])
            : map['Latitude'] ?? 0.0,
        Longitude: map['Longitude'] is String
            ? double.parse(map['Longitude'])
            : map['Longitude'] ?? 0.0,
        rating: map['rating'] is String
            ? int.parse(map['rating'])
            : map['rating'] ?? 0,
        experience: map['experience'] is String
            ? int.parse(map['experience'])
            : map['experience'] ?? 0,
        gender: map['gender'] ?? '',
        description: map['description'] ?? '',
        email: map['email'] ?? '',
        photoUrl: map['photoUrl'] ?? '',
        specialization: map['specialization'] ?? '',
        hospital: map['hospital'] ?? '',
        did: map['did'] ?? '');
  }
}
