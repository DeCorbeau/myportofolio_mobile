import 'package:json_annotation/json_annotation.dart';
import 'package:myportofolio_mobile/config.dart';

part 'experience.g.dart';

/// Portfolio experience synchronized with the Django REST Framework API.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Experience {
  const Experience({
    required this.title,
    required this.description,
    required this.category,
    required this.startedAt,
    this.organization = '',
    this.thumbnail,
    this.endedAt,
    this.id,
    this.categoryDisplay = '',
    this.thumbnailImage,
    this.thumbnailUrl = '',
    this.isOngoing = false,
    this.dateRangeDisplay = '',
    this.descriptionPoints = const [],
    this.likeCount = 0,
    this.isLiked = false,
    this.likedByNames = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  // Fields below are set by the server, so they are never sent in a request.
  @JsonKey(includeToJson: false)
  final String? id;

  final String title;

  @JsonKey(defaultValue: '')
  final String organization;

  final String description; // one bullet point per line

  final String category; // internship | research | volunteer | part-time | ...

  final String? thumbnail; // optional external image URL

  final String startedAt; // yyyy-MM-dd

  final String? endedAt; // null = ongoing

  @JsonKey(includeToJson: false, defaultValue: '')
  final String categoryDisplay;

  @JsonKey(includeToJson: false)
  final String? thumbnailImage;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String thumbnailUrl;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isOngoing;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String dateRangeDisplay;

  @JsonKey(includeToJson: false, defaultValue: <String>[])
  final List<String> descriptionPoints;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int likeCount;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isLiked;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String likedByNames;

  /// The server may return a relative `/media/...` path for uploaded images.
  String get thumbnailAbsoluteUrl {
    if (thumbnailUrl.isEmpty) return '';
    if (thumbnailUrl.startsWith('http')) return thumbnailUrl;
    return '$apiBaseUrl$thumbnailUrl';
  }

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}