import 'package:flutter/foundation.dart';

@immutable
class Documents {
  final int iddocuments;
  final String name;
  final int year;
  final bool status;
  final String pathfile;
  final int idtypedocs;
  final String pathAnswer;
  final bool statusAnswer;
  final String notions;

  const Documents({
    this.iddocuments,
    this.name,
    this.year,
    this.status,
    this.pathfile,
    this.idtypedocs,
    this.pathAnswer,
    this.statusAnswer,
    this.notions,
  });

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      iddocuments: json['iddocuments'] as int,
      name: json['name'] as String,
      year: json['year'] as int,
      status: json['status'] as bool,
      pathfile: json['pathfile'] as String,
      idtypedocs: json['idtypedocs'] as int,
      pathAnswer: json['pathAnswer'] as String,
      statusAnswer: json['statusAnswer'] == 0 ? false : true as bool,
      notions: json['notions'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iddocuments': iddocuments,
      'name': name,
      'year': year,
      'status': status,
      'pathfile': pathfile,
      'idtypedocs': idtypedocs,
      'pathAnswer': pathAnswer,
      'statusAnswer': statusAnswer,
      'notions': notions,
    };
  }
}
