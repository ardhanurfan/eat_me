import 'package:equatable/equatable.dart';
import 'bahan_model.dart';

class InformationModel extends Equatable {
  final String productName;
  final String expiredDate;
  final List<BahanModel> daftarBahan;
  const InformationModel({
    required this.productName,
    required this.expiredDate,
    required this.daftarBahan,
  });

  factory InformationModel.fromJson(Map<String, dynamic> json) =>
      InformationModel(
        productName: json['productName'],
        expiredDate: json['expiredDate'],
        daftarBahan: List<BahanModel>.from(
          json['daftarBahan'].map((x) => BahanModel.fromJson(x['id'], x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'expiredDate': expiredDate,
        'daftarBahan': List<Map<String, dynamic>>.from(
          daftarBahan.map((x) => x.toJson()),
        ),
      };

  @override
  List<Object?> get props => [
        productName,
        expiredDate,
        daftarBahan,
      ];
}
