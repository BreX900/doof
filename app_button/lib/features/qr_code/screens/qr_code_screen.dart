import 'dart:async';

import 'package:app_button/apis/firebase/button_migrations.dart';
import 'package:app_button/apis/material/corner_painter.dart';
import 'package:app_button/features/qr_code/data/qr_code_data.dart';
import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  void _onQrCode(BuildContext context, BarcodeCapture barcodes) {
    final barcode = barcodes.barcodes.single;
    final source = barcode.rawValue!;
    final url = Uri.parse(source);
    final data = QrCodeData.fromUrl(url);

    switch (data) {
      case QrCodeOrganizationData(:final organizationId):
        ServicesRoute(organizationId).go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final qrCodeScanner = MobileScanner(
      onDetect: (barcodes) => _onQrCode(context, barcodes),
    );

    const viewfinderBorderSide = BorderSide(width: 6.0);
    const viewfinderRadius = 16.0;

    final viewfinder = CustomPaint(
      painter: CornerPainter(
        color: viewfinderBorderSide.color,
        radius: viewfinderRadius,
        length: 32.0,
        width: viewfinderBorderSide.width,
      ),
      child: const Padding(
        padding: EdgeInsets.all(48.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(viewfinderBorderSide),
            borderRadius: BorderRadius.all(Radius.circular(viewfinderRadius)),
          ),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: qrCodeScanner),
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(R.svgsAppLogo),
                      const SizedBox(height: 24.0),
                      SvgPicture.asset(R.svgsAppTitle),
                    ],
                  ),
                ),
                SizedBox(
                  width: 256.0,
                  height: 256.0,
                  child: viewfinder,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(96.0),
                    child: Text(
                      'per iniziare inquadra il QR code',
                      style: textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 32.0,
            right: 0.0,
            child: Row(
              children: [
                if (kDebugMode)
                  IconButton(
                    onPressed: () => unawaited(ButtonMigrations.instance.clean()),
                    icon: const Icon(Icons.delete),
                  ),
                if (kDebugMode)
                  IconButton(
                    onPressed: () => unawaited(ButtonMigrations.instance.migrate()),
                    icon: const Icon(Icons.update),
                  ),
                IconButton(
                  onPressed: () => const ServicesRoute('dev').go(context),
                  icon: const Icon(Icons.attractions),
                ),
                IconButton(
                  onPressed: () => const ProductsRoute('dev').go(context),
                  icon: const Icon(Icons.fastfood_outlined),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
