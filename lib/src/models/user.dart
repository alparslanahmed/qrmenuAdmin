class User {
  final int id;
  final String email;
  final bool isEmailVerified;
  final String? name;
  final String? businessName;
  final String? taxOffice;
  final String? taxNumber;
  final String? address;
  final String? phone;
  final String? logoURL;

  User({
    required this.id,
    required this.email,
    this.isEmailVerified = false,
    this.name,
    this.businessName,
    this.taxOffice,
    this.taxNumber,
    this.address,
    this.phone,
    this.logoURL,
  });
}