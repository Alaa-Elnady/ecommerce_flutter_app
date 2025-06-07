class UserModel {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String password;
  final String? profileImagePath;
  final String token;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    this.profileImagePath,
    required this.token,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'password': password,
    'profileImagePath': profileImagePath,
    'token': token,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    password: json['password'],
    profileImagePath: json['profileImagePath'],
    token: json['token'] ?? '',
  );
}
