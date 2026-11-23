import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

/// Portfolio skill synchronized with the Django REST Framework API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Skill {
  const Skill({
    required this.name,
    required this.category,
    required this.proficiency,
    this.impact = '',
    this.context = '',
    this.id,
    this.categoryDisplay = '',
    this.proficiencyDisplay = '',
    this.endorseCount = 0,
    this.endorsedByNames = '',
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  // Fields below are set by the server, so they are never sent in a request.
  @JsonKey(includeToJson: false)
  final String? id;

  final String name;
  final String category; // leadership | event | communication | technical
  final int proficiency; // 1 = Beginner ... 4 = Expert

  @JsonKey(defaultValue: '')
  final String impact;

  @JsonKey(defaultValue: '')
  final String context;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String categoryDisplay;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String proficiencyDisplay;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int endorseCount;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String endorsedByNames;

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}