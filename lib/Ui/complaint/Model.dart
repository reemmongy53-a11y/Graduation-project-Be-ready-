class ComplaintRequest {
  final String jobTitle;
  final String reportTitle;
  final String reportDetails;

  ComplaintRequest({
    required this.jobTitle,
    required this.reportTitle,
    required this.reportDetails,
  });

  Map<String, dynamic> toJson() => {
    'jobTitle': jobTitle,
    'reportTitle': reportTitle,
    'reportDetails': reportDetails,
  };
}