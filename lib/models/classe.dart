import 'package:flutter/foundation.dart';

@immutable
class Classes {
  final int idclasses;
  final String name;
  final int countAnswer;
  final int countDocument;
  final int countResponse;
  final int countProblem;

  const Classes({
    this.idclasses,
    this.name,
    this.countAnswer,
    this.countDocument,
    this.countResponse,
    this.countProblem,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      idclasses: json['idclasses'] as int,
      name: json['name'] as String,
      countAnswer: json['countAnswer'] as int,
      countDocument: json['countDocument'] as int,
      countResponse: json['countResponse'] as int,
      countProblem: json['countProblem'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idclasses': idclasses,
      'name': name,
      'countAnswer': countAnswer,
      'countDocument': countDocument,
      'countResponse': countResponse,
      'countProblem': countProblem
    };
  }
}
