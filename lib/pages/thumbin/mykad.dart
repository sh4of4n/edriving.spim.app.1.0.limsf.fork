import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class MyKad extends StatefulWidget {
  const MyKad({super.key});

  @override
  State<MyKad> createState() => _MyKadState();
}

class _MyKadState extends State<MyKad> {
  final primaryColor = ColorConstant.primaryColor;
  static const platform = MethodChannel('samples.flutter.dev/mykad');
  String status = '';
  String readMyKad = '';
  String fingerPrintVerify = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, 
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.amber.shade300, primaryColor],
            stops: const [0.5, 1],
            radius: 0.9,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title:
                Text(AppLocalizations.of(context)!.translate('add_class_lbl')),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(600)),
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                    try {
                          final result =
                              await platform.invokeMethod<String>('onCreate');
                          setState(() {
                            status = result.toString();
                          });
                        } on PlatformException catch (e) {
                          setState(() {
                            status = "'${e.message}'.";
                          });
                        }
                    },
                    child: const Text('Check Status'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                          final result =
                              await platform.invokeMethod<String>('onReadMyKad');
                          setState(() {
                            readMyKad = result.toString();
                          });
                        } on PlatformException catch (e) {
                          setState(() {
                            readMyKad = "'${e.message}'";
                          });
                        }
                    },
                    child: const Text('onReadMyKad'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final result =
                            await platform.invokeMethod<String>('onFingerprintVerify');
                        setState(() {
                          fingerPrintVerify = result.toString();
                        });
                        if (result ==
                            'Please place your thumb on the fingerprint reader...') {
                          final result = await platform
                              .invokeMethod<String>('onFingerprintVerify2');
                          setState(() {
                            fingerPrintVerify = result.toString();
                          });
                        }
                      } on PlatformException catch (e) {
                        setState(() {
                          fingerPrintVerify = "'${e.message}'";
                        });
                      }
                    },
                    child: const Text('onFingerprintVerify'),
                  ),
                ],
              )
            ),
          ),
        )
      )
    );
  }
}