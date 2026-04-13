class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String employeeNumber;
  final String qrCode;
  final String plateNumber;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.employeeNumber,
    required this.qrCode,
    required this.plateNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // ✅ لو الـ response جوا "data" نجيبه، لو لأ نستخدم الـ json نفسه
    final Map<String, dynamic> data = json['data'] ?? json;

    return ProfileModel(
      id: data['_id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      employeeNumber: data['employeeNumber'] ?? '',
      qrCode: data['qr_code']?.toString() ?? '',
      plateNumber: data['plateNumber'] ?? '',
    );
  }
}