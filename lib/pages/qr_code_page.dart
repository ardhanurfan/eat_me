import 'dart:convert';

import 'package:eat_me/models/information_model.dart';
import 'package:eat_me/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets/qr_overlay.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    MobileScannerController cameraController = MobileScannerController();

    Widget popUp(InformationModel info) {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(secondaryColor),
            ),
            onPressed: () {
              cameraController.start();
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: whiteText,
            ),
          ),
        ],
        title: Text(
          "Product Information",
          style: primaryColorText.copyWith(fontSize: 20, fontWeight: bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              info.productName,
              style: secondaryColorText.copyWith(
                fontSize: 16,
                fontWeight: bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Expired Date",
              style: darkText.copyWith(
                fontSize: 16,
                fontWeight: bold,
              ),
            ),
            Text(
              info.expiredDate,
              style: darkText.copyWith(
                fontSize: 16,
                fontWeight: bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Komposisi",
              style: darkText.copyWith(
                fontSize: 12,
              ),
            ),
            Column(
              children: info.daftarBahan
                  .map((e) => Text(
                        "${e.nama} : ${e.metode}",
                        style: greyText,
                      ))
                  .toList(),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              Barcode barcode = barcodes.first;
              if (barcode.rawValue != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return popUp(
                      InformationModel.fromJson(
                        jsonDecode(barcode.rawValue!),
                      ),
                    );
                  },
                );
                cameraController.stop();
              }
              // onDetect(barcode.rawValue, cameraController);
            },
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Product Scanner",
                  style: whiteText.copyWith(fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: ValueListenableBuilder(
                        valueListenable: cameraController.torchState,
                        builder: (context, state, child) {
                          switch (state) {
                            case TorchState.off:
                              return const Icon(Icons.flash_off,
                                  color: Colors.grey);
                            case TorchState.on:
                              return const Icon(Icons.flash_on,
                                  color: Colors.yellow);
                          }
                        },
                      ),
                      onPressed: () => cameraController.toggleTorch(),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: ValueListenableBuilder(
                        valueListenable: cameraController.cameraFacingState,
                        builder: (context, state, child) {
                          switch (state) {
                            case CameraFacing.front:
                              return const Icon(Icons.camera_front);
                            case CameraFacing.back:
                              return const Icon(Icons.camera_rear);
                          }
                        },
                      ),
                      onPressed: () => cameraController.switchCamera(),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
