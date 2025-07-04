import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:equatable/equatable.dart';

import '../../core/core.dart';

enum PdfAction {
  print,
  share;

  bool get isShare => this == share;
}

enum SortType {
  latestFirst,
  earliestFirst;

  bool get isLatestFirst => this == latestFirst;

  SortType get other => isLatestFirst ? earliestFirst : latestFirst;
}

class ScanGroup extends Equatable {
  final int id;
  final String? title;
  final String thumbnailPath;
  final DateTime creationTime;
  final List<String> imagesPath;

  const ScanGroup({
    required this.id,
    required this.title,
    required this.creationTime,
    required this.imagesPath,
    required this.thumbnailPath,
  });

  static Map<String, dynamic> newGroup({
    required String thumbnailPath,
    required DateTime creationTime,
    required List<String> imagesPath,
  }) {
    return {
      'id': null,
      'title': null,
      'thumbnailPath': thumbnailPath,
      'imagesPath': jsonEncode(imagesPath),
      'creationTime': creationTime.toIso8601String(),
    };
  }

  ScanGroup copyWith({
    String? title,
    String? thumbnailPath,
    List<String>? imagesPath,
  }) {
    return ScanGroup(
      id: id,
      title: title ?? this.title,
      creationTime: creationTime,
      imagesPath: imagesPath ?? this.imagesPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  Map<String, dynamic> get toJson => {
    'id': id,
    'title': title,
    'thumbnailPath': thumbnailPath,
    'imagesPath': jsonEncode(imagesPath),
    'creationTime': creationTime.toIso8601String(),
  };

  factory ScanGroup.fromJson(Map<String, dynamic> json) => ScanGroup(
    id: json['id'],
    title: json['title'],
    thumbnailPath: json['thumbnailPath'],
    creationTime: DateTime.parse(json['creationTime']),
    imagesPath: List<String>.from(jsonDecode(json['imagesPath'])),
  );

  @override
  List<Object?> get props => [
    id,
    title,
    imagesPath,
    thumbnailPath,
    creationTime,
  ];

  String get titleUI => title ?? '${LocaleKeys.document.tr()} $id';

  @override
  String toString() {
    return 'ScanGroup(id: $id, title: $title, creationTime: $creationTime, thumbnailPath: $thumbnailPath, imagesPath: $imagesPath)';
  }
}
