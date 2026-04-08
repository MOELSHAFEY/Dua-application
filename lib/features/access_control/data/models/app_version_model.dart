import '../../domain/entities/app_version.dart';

class AppVersionModel extends AppVersion {
  const AppVersionModel({required super.version, required super.url});

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      version: json['v'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'v': version,
      'url': url,
    };
  }
}
