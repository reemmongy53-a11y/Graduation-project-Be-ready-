class VehicleModel {
  final String id;
  final String employeeId;
  final String plateNumber;
  final String createdAt;
  final String? employeeNamber;


  VehicleModel({
    required this.id,
    required this.employeeId,
    required this.plateNumber,
    required this.createdAt,
    this.employeeNamber,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      createdAt: json['created_at'] ?? '',
      employeeNamber: json['employeeNamber'] ?? '',

    );
  }
}