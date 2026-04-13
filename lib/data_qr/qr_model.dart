class QrModel {
  final String qrCode;
  final String qrImage;
  final DateTime expiresAt;

  QrModel({
    required this.qrCode,
    required this.qrImage,
    required this.expiresAt,
  });

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
      qrCode: json['qr_code'] ?? '',
      qrImage: json['qrImage'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }


  String get pureBase64 {
    if (qrImage.contains(',')) {
      return qrImage.split(',').last;
    }
    return qrImage;
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
