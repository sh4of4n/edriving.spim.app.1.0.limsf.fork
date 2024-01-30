import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/common_library/utils/custom_dialog.dart';
import 'package:edriving_spim_app/common_library/utils/loading_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

@RoutePage()
class ScanVeh extends StatefulWidget {
  const ScanVeh({super.key});

  @override
  State<ScanVeh> createState() => _ScanVehState();
}

class _ScanVehState extends State<ScanVeh> {
  final customDialog = CustomDialog();
  final bool _isLoading = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR'),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(child: _buildQrView(context)),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      context.router.pop(scanData.code);
    });
    Navigator.of(context).pop();
  }

  invalidQr({String? type}) {
    if (type == 'MISMATCH') {
      return customDialog.show(
        barrierDismissable: false,
        context: context,
        content: AppLocalizations.of(context)!.translate('mismatch_di'),
        title: Icon(Icons.warning, size: 120, color: Colors.yellow[700]),
        customActions: [
          TextButton(
            onPressed: () {
              context.router.pop();

              controller!.resumeCamera();
            },
            child: const Text('Ok'),
          ),
        ],
        type: DialogType.general,
      );
    }
    return customDialog.show(
      barrierDismissable: false,
      context: context,
      content: AppLocalizations.of(context)!.translate('invalid_qr'),
      title: Icon(Icons.warning, size: 120, color: Colors.red[700]),
      customActions: [
        TextButton(
          onPressed: () {
            context.router.pop();

            controller!.resumeCamera();
          },
          child: const Text('Ok'),
        ),
      ],
      type: DialogType.general,
    );
  }
}