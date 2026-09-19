class Address {
  final String street;
  final String city;

  const Address({required this.street, required this.city});

  factory Address.fromJson(Map<String, dynamic> j) =>
      Address(street: j['street'] as String, city: j['city'] as String);
}

class Company {
  final String name;

  const Company({required this.name});

  factory Company.fromJson(Map<String, dynamic> j) =>
      Company(name: j['name'] as String);
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final Address address;
  final Company company;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: j['id'] as int,
        name: j['name'] as String,
        email: j['email'] as String,
        phone: j['phone'] as String,
        address: Address.fromJson(j['address'] as Map<String, dynamic>),
        company: Company.fromJson(j['company'] as Map<String, dynamic>),
      );

  /// Initials for the avatar. Skips titles such as "Mrs." or "Mr.".
  String get initials {
    final parts = name
        .split(' ')
        .where((p) => p.isNotEmpty && !p.endsWith('.'))
        .toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }
}
