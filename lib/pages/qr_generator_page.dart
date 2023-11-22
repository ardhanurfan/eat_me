import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:eat_me/data/bahan.dart';
import 'package:eat_me/models/bahan_model.dart';
import 'package:eat_me/shared/theme.dart';
import 'package:eat_me/widgets/custom_button.dart';
import 'package:eat_me/widgets/custom_dropdown_form_field.dart';
import 'package:eat_me/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({super.key});

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController =
      TextEditingController(text: '');
  String? selectedBahan;
  Map<String, dynamic>? data;
  List<BahanModel> listBahan = [];
  String expired = "";

  List<BahanModel> dataBahan = foodData.map((e) {
    return BahanModel.fromJson(foodData.indexOf(e) + 1, e);
  }).toList();

  final GlobalKey _qrkey = GlobalKey();
  bool dirExists = false;

  Future<void> _captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary =
          _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      //Drawing White Background because Qr Code is Black
      final whitePaint = Paint()..color = Colors.white;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save image to gallery
      await ImageGallerySaver.saveImage(pngBytes);

      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text(
          'QR code saved to gallery',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text(
          'Something went wrong!!!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  DateTime calculateMinExpirationDate(List<BahanModel> bahanList) {
    // Ambil daftar expiredTime dari semua bahan
    List<int> expiredTimes =
        bahanList.map((bahan) => bahan.expiredTime).toList();

    // Temukan nilai minimum dari daftar expiredTime
    int minExpiredTime = expiredTimes.reduce(min);

    // Tambahkan expiredTime minimum ke DateTime.now() untuk mendapatkan tanggal kedaluwarsa minimum
    DateTime minExpirationDate =
        DateTime.now().add(Duration(days: minExpiredTime));

    return minExpirationDate;
  }

  @override
  Widget build(BuildContext context) {
    final message = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expired QR Generator',
          style: darkText.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    radiusBorder: 12,
                    controller: _productNameController,
                    hintText: "Masukkan Product Name",
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: listBahan.map(
                      (e) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${e.nama} : ${e.metode}",
                              style: secondaryColorText,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  listBahan
                                      .removeWhere((element) => element == e);
                                });
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ),
                            )
                          ],
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomDropdownFormField(
                          hintText: "Pilih bahan",
                          items: dataBahan
                              .map((e) => "${e.nama} : ${e.metode}")
                              .toList(),
                          radiusBorder: 12,
                          onChanged: (value) {
                            if (value != null) {
                              selectedBahan = value;
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (selectedBahan != null) {
                            BahanModel bahan = dataBahan.firstWhere((element) =>
                                element.nama ==
                                    selectedBahan!.split(" : ")[0] &&
                                element.metode ==
                                    selectedBahan!.split(" : ")[1]);
                            bool found = listBahan
                                .where((element) => element == bahan)
                                .isNotEmpty;
                            setState(() {
                              if (!found) {
                                listBahan.add(bahan);
                              } else {
                                message.removeCurrentSnackBar();
                                message.showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Bahan sudah dipilih",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: dark,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    radiusButton: 12,
                    buttonColor: primaryColor,
                    buttonText: "Generate",
                    widthButton: 200,
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        if (listBahan.isNotEmpty) {
                          setState(() {
                            expired = DateFormat('dd-MMMM-yyyy')
                                .format(calculateMinExpirationDate(listBahan));

                            data = {
                              "expiredDate": DateFormat('dd-MMMM-yyyy').format(
                                  calculateMinExpirationDate(listBahan)),
                              "productName": _productNameController.text,
                              "daftarBahan":
                                  listBahan.map((e) => e.toJson()).toList(),
                            };
                          });
                        } else {
                          message.removeCurrentSnackBar();
                          message.showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "Bahan tidak boleh kosong",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    heightButton: 50,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: data != null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              margin: EdgeInsets.only(
                top: 12,
                left: defaultMargin,
                right: defaultMargin,
                bottom: 160,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.1),
                      offset: const Offset(
                        0,
                        2,
                      ),
                      blurRadius: 1,
                      spreadRadius: 0.5,
                    ),
                  ]),
              child: Column(
                children: [
                  RepaintBoundary(
                    key: _qrkey,
                    child: QrImageView(
                      embeddedImage: const AssetImage('assets/logo.png'),
                      data: jsonEncode(data),
                      version: QrVersions.auto,
                      size: 250.0,
                      gapless: true,
                      errorStateBuilder: (ctx, err) {
                        return const Center(
                          child: Text(
                            'Something went wrong!!!',
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Expired Time\n$expired",
                    style: darkText.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    radiusButton: 32,
                    buttonColor: secondaryColor,
                    buttonText: "Export",
                    widthButton: 120,
                    onPressed: () async => _captureAndSavePng(),
                    heightButton: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
