import 'package:flutter/foundation.dart';

@immutable
class Problems {
  final int idproblems;
  final String content;
  final String file;
  final bool status;
  final int idteachers;
  final String createdAt;
  final String updatedAt;
  final int countResponse;
  final int idstudents;

  final String fullname;

  const Problems({
    this.idproblems,
    this.content,
    this.file,
    this.status,
    this.idteachers,
    this.createdAt,
    this.updatedAt,
    this.countResponse,
    this.idstudents,
    this.fullname,
  });

  factory Problems.fromJson(Map<String, dynamic> json) {
    return Problems(
      idproblems: json['idproblems'] as int,
      content: json['content'] as String,
      file: json['file'] as String,
      status: (json['status'] == 0) || (json['status'] == null)
          ? false
          : true as bool,
      idteachers: json['idteachers'] as int,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      countResponse: json['countResponse'] as int,
      idstudents: json['idstudents'] as int,
      fullname: json['fullname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idproblems': idproblems,
      'content': content,
      'file': file,
      'status': status,
      'idteachers': idteachers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'countResponse': countResponse,
      'idstudents': idstudents,
      'fullname': fullname,
    };
  }
}
