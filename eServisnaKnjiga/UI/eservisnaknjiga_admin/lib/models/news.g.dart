// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      (json['id'] as num?)?.toInt(),
      json['naslov'] as String?,
      json['tekst'] as String?,
      json['datumObjave'] == null
          ? null
          : DateTime.parse(json['datumObjave'] as String),
      json['slika'] as String?,
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'naslov': instance.naslov,
      'tekst': instance.tekst,
      'datumObjave': instance.datumObjave?.toIso8601String(),
      'slika': instance.slika,
    };
