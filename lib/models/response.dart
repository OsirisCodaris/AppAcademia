import 'package:flutter/foundation.dart';

@immutable
class Responses {
  final int idresponses;
  final String content;
  final String file;
  bool status;
  final int idproblems;
  final int idusers;
  final String createdAt;
  final String fullname;
  final String role;

  Responses({
    this.idresponses,
    this.content,
    this.file,
    this.status,
    this.idproblems,
    this.idusers,
    this.createdAt,
    this.fullname,
    this.role,
  });

  factory Responses.fromJson(Map<String, dynamic> json) {
    return Responses(
      idresponses: json['idresponses'] as int,
      content: json['content'] as String,
      file: json['file'].toString(),
      status: (json['status'] == 0) || (json['status'] == null)
          ? false
          : true as bool,
      idproblems: json['idproblems'] as int,
      idusers: json['idusers'] as int,
      createdAt: json['createdAt'] is String
          ? json['createdAt']
          : DateTime.fromMillisecondsSinceEpoch(
                  json['createdAt'].millisecondsSinceEpoch)
              .toIso8601String(),
      fullname: json['fullname'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idresponses': idresponses,
      'content': content,
      'file': file,
      'status': status,
      'idproblems': idproblems,
      'idusers': idusers,
      'createdAt': createdAt,
      'fullname': fullname,
      'role': role,
    };
  }
}
