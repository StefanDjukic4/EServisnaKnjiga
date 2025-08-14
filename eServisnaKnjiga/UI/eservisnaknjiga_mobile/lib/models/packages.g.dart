// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Packages _$PackagesFromJson(Map<String, dynamic> json) => Packages(
      (json['id'] as num?)?.toInt(),
      json['naziv'] as String?,
      json['opis'] as String?,
      (json['minimalnaCijena'] as num?)?.toDouble(),
      (json['maksimalnaCijena'] as num?)?.toDouble(),
      json['intervalObavjesti'] as String?,
      json['slika'] as String?,
    );

Map<String, dynamic> _$PackagesToJson(Packages instance) => <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'minimalnaCijena': instance.minimalnaCijena,
      'maksimalnaCijena': instance.maksimalnaCijena,
      'intervalObavjesti': instance.intervalObavjesti,
      'slika': instance.slika,
    };
