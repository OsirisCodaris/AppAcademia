import 'package:flutter/foundation.dart';

@immutable
class Typedocs {
	final int idtypedocs;
	final String name;

	const Typedocs({this.idtypedocs, this.name});

	factory Typedocs.fromJson(Map<String, dynamic> json) {
		return Typedocs(
			idtypedocs: json['idtypedocs'] as int,
			name: json['name'] as String,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'idtypedocs': idtypedocs,
			'name': name,
		};
	}
}
