import 'package:flutter/foundation.dart';

@immutable
class AppVersion {
  final int idappversions;
  final String title;
  final String about;
  final String version;
  final String createdAt;
  final String minAppVersion;

  const AppVersion({
    this.idappversions,
    this.title,
    this.about,
    this.version,
    this.createdAt,
    this.minAppVersion,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      idappversions: json['idappversions'] as int,
      title: json['title'] as String,
      about: json['about'] as String,
      version: json['version'] as String,
      minAppVersion: json['minAppVersion'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idappversions': idappversions,
      'title': title,
      'about': about,
      'versions': version,
      'minAppVersion': minAppVersion,
      'createdAt': createdAt,
    };
  }
}
