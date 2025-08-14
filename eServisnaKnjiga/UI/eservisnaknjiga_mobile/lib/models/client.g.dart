// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      (json['id'] as num?)?.toInt(),
      json['ime'] as String?,
      json['prezime'] as String?,
      json['telefon'] as String?,
      json['email'] as String?,
      json['adresa'] as String?,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'telefon': instance.telefon,
      'email': instance.email,
      'adresa': instance.adresa,
    };
