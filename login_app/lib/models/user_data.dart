class UserData {
  const UserData({
    this.id,
    required this.name,
    required this.email,
    this.password,
    required this.provider,
  });

  final String? id;
  final String name;
  final String email;
  final String? password;
  final String provider;

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      provider: json['provider'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'email': email,
      'provider': provider,
    };

    if (password != null) {
      json['password'] = password;
    }

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}
