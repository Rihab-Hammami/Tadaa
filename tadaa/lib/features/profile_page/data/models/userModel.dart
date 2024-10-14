class UserModel {
  final String uid;
  final String username;
  final String name;
  final String email;
  final String nationality;
  final DateTime? birthday;
  final String? aboutMe;
  final String role;
  final String? profilePicture;
  final int points;  // New attribute
  
  UserModel({
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    required this.nationality,
    this.birthday,
    this.aboutMe,
    required this.role,
    this.profilePicture,
    this.points = 0, // Default points to 0
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      nationality: data['nationality'] ?? '',
      birthday: (data['birthday'] != null)
          ? DateTime.parse(data['birthday'])
          : null,
      aboutMe: data['aboutMe'],
      role: data['role'] ?? '',
      profilePicture: data['profilePicture'],
      points: data['points'] ?? 0,  // Parse points, default to 0 if not provided
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'email': email,
      'nationality': nationality,
      'birthday': birthday?.toIso8601String(),
      'aboutMe': aboutMe,
      'role': role,
      'profilePicture': profilePicture,
      'points': points,  
    };
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? name,
    String? email,
    String? nationality,
    DateTime? birthday,
    String? aboutMe,
    String? role,
    String? profilePicture,
    int? points,  // Add points to copyWith method
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      nationality: nationality ?? this.nationality,
      birthday: birthday ?? this.birthday,
      aboutMe: aboutMe ?? this.aboutMe,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      points: points ?? this.points,  // Allow copying of points
    );
  }
}
