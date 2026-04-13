class ParkingModel {
  final Map<String, dynamic> details;
  ParkingModel({required this.details});

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    return ParkingModel(

      details: Map<String, dynamic>.from(json['details'] ?? {}),
    );

  }
}