// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) => Package(
      (json['id'] as num?)?.toInt(),
      json['naziv'] as String?,
      json['opis'] as String?,
      json['intervalObavjesti'] as String?,
      (json['minimalnaCijena'] as num?)?.toDouble(),
      (json['maksimalnaCijena'] as num?)?.toDouble(),
      json['slika'] as String?,
    );

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'intervalObavjesti': instance.intervalObavjesti,
      'minimalnaCijena': instance.minimalnaCijena,
      'maksimalnaCijena': instance.maksimalnaCijena,
      'slika': instance.slika,
    };
