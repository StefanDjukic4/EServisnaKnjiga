import 'package:json_annotation/json_annotation.dart';

part 'package.g.dart';

@JsonSerializable()
class Package {
  int? id;
  String? naziv;
  String? opis;
  String? intervalObavjesti;
  double? minimalnaCijena;
  double? maksimalnaCijena;
  String? slika;

  Package(this.id, this.naziv, this.opis, this.intervalObavjesti,
      this.minimalnaCijena, this.maksimalnaCijena, this.slika);

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);

  Map<String, dynamic> toJson() => _$PackageToJson(this);
}
