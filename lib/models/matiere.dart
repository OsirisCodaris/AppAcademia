import 'package:flutter/foundation.dart';

@immutable
class Matieres {
  final int idsubjects;
  final String name;
  final int countAnswer;
  final int countDocument;
  final int countResponse;
  final int countProblem;

  const Matieres({
    this.idsubjects,
    this.name,
    this.countAnswer,
    this.countDocument,
    this.countResponse,
    this.countProblem,
  });

  factory Matieres.fromJson(Map<String, dynamic> json) {
    return Matieres(
      idsubjects: json['idsubjects'] as int,
      name: json['name'] as String,
      countAnswer: json['countAnswer'] as int,
      countDocument: json['countDocument'] as int,
      countResponse: json['countResponse'] as int,
      countProblem: json['countProblem'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idsubjects': idsubjects,
      'name': name,
      'countAnswer': countAnswer,
      'countDocument': countDocument,
      'countResponse': countResponse,
      'countProblem': countProblem
    };
  }
}
