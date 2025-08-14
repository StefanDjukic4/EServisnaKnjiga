// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      (json['id'] as num?)?.toInt(),
      json['marka'] as String?,
      json['model'] as String?,
      (json['godinaProizvodnje'] as num?)?.toInt(),
      json['registracija'] as String?,
      json['brojSasije'] as String?,
      json['klijent'] == null
          ? null
          : Client.fromJson(json['klijent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'id': instance.id,
      'marka': instance.marka,
      'model': instance.model,
      'godinaProizvodnje': instance.godinaProizvodnje,
      'registracija': instance.registracija,
      'brojSasije': instance.brojSasije,
      'klijent': instance.klijent,
    };
