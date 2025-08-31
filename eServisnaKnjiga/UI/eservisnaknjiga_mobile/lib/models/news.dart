import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  int? id;
  String? naslov;
  String? tekst;
  DateTime? datumObjave;
  String? slika;

  News(this.id, this.naslov, this.tekst, this.datumObjave, this.slika);

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
