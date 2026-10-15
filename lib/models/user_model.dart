class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profileImage;
  final String address;
  final bool isPartner;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.profileImage,
    this.address = '',
    this.isPartner = false,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profileImage,
    String? address,
    bool? isPartner,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      isPartner: isPartner ?? this.isPartner,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
