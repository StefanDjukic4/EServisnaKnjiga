import 'package:json_annotation/json_annotation.dart';

part 'packages.g.dart';

@JsonSerializable()
class Packages {
  int? id;
  String? naziv;
  String? opis;
  double? minimalnaCijena;
  double? maksimalnaCijena;
  String? intervalObavjesti;
  String? slika;

  Packages(this.id, this.naziv, this.opis, this.minimalnaCijena,
      this.maksimalnaCijena, this.intervalObavjesti, this.slika);

  factory Packages.fromJson(Map<String, dynamic> json) =>
      _$PackagesFromJson(json);

  Map<String, dynamic> toJson() => _$PackagesToJson(this);
}
