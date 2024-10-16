class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? education;
  final String? occupation;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.education,
    this.occupation,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      education: map['education'],
      occupation: map['occupation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'education': education,
      'occupation': occupation,
    };
  }
}