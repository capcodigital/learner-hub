class CloudCertification {
  final String name;
  final String platform;
  final String certificationType;
  final String certificationDate;

  CloudCertification({
    required this.name,
    required this.platform,
    required this.certificationType,
    required this.certificationDate,
  });

  List<Object> get props =>
      [name, platform, certificationType, certificationDate];
}
