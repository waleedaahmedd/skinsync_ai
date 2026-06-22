class AppVersionRequest {
  final String type;
  final String version;
  final String buildNumber;

  AppVersionRequest({
    required this.type,
    required this.version,
    required this.buildNumber,
  });

  Map<String, dynamic> toJson() {
    return {'type': type, 'version': version, 'build_number': buildNumber};
  }
}
