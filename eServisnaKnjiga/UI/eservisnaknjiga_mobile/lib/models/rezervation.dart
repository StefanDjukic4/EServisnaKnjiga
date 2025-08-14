import 'package:json_annotation/json_annotation.dart';

part 'rezervation.g.dart';

@JsonSerializable()
class Rezervation {
  int? automobilId;
  DateTime? datum;
  String? opis;
  List<int>? packageIdList;

  Rezervation(this.automobilId, this.datum, this.opis, this.packageIdList);

  factory Rezervation.fromJson(Map<String, dynamic> json) =>
      _$RezervationFromJson(json);

  Map<String, dynamic> toJson() => _$RezervationToJson(this);
}
