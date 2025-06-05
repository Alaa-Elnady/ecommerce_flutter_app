class UserModel {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String password;
  final String? profileImagePath;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    this.profileImagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
      'profileImagePath': profileImagePath,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      password: json['password'],
      profileImagePath: json['profileImagePath'],
    );
  }
}
