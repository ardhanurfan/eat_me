import 'package:equatable/equatable.dart';

class BahanModel extends Equatable {
  final int id;
  final String nama;
  final String metode;
  final int expiredTime;
  const BahanModel({
    required this.id,
    required this.nama,
    required this.expiredTime,
    required this.metode,
  });

  factory BahanModel.fromJson(int id, Map<String, dynamic> json) => BahanModel(
      id: id,
      nama: json['nama'],
      expiredTime: json['expiredTime'],
      metode: json['metode']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'expiredTime': expiredTime,
        'metode': metode,
      };

  @override
  List<Object?> get props => [
        id,
        nama,
        expiredTime,
        metode,
      ];
}
