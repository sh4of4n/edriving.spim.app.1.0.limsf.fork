import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/router.gr.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

@RoutePage()
class MyKad extends StatefulWidget {
  final groupId;
  final courseCode;
  const MyKad({super.key, required this.courseCode, required this.groupId});

  @override
  State<MyKad> createState() => _MyKadState();
}

class _MyKadState extends State<MyKad> {
  final myImage = ImagesConstant();
  final primaryColor = ColorConstant.primaryColor;
  static const platform = MethodChannel('samples.flutter.dev/mykad');
  final credentials = Hive.box('credentials');
  String readMyKad = '';
  List<String> cardDetails = [];
  String fingerPrintVerify = '';
  String name = '';
  String icNo = '';
  String birthDate = '';
  String address = '';
  bool tick = false;
  bool fingerPrn = false;

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
                    Text(AppLocalizations.of(context)!.translate('myKad_lbl')),
              ),
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(200)),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Card(
                          child: SizedBox(
                            width: 1000.w,
                            height: 2000.h,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    myImage.mykadimg,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        final result =
                                            await platform.invokeMethod<String>(
                                                'onReadMyKad');
                                        setState(() {
                                          readMyKad = result.toString();
                                          tick = true;
                                        });
                                      } on PlatformException catch (e) {
                                        setState(() {
                                          readMyKad = "${e.message}";
                                          // cardDetails = readMyKad.split(',');
                                          // name = cardDetails[0].trim();
                                          // icNo = cardDetails[1].trim();
                                          // birthDate = cardDetails[2].trim();
                                          // address = cardDetails[3].trim();
                                        });
                                      }
                                    },
                                    child: const Text('Read My Kad Details'),
                                  ),
                                  tick
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : Container(),
                                  Text(readMyKad),
                                  SizedBox(
                                    height: 100.h,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        final result =
                                            await platform.invokeMethod<String>(
                                                'onFingerprintVerify');
                                        setState(() {
                                          fingerPrintVerify = result.toString();
                                        });
                                        if (result ==
                                            'Please place your thumb on the fingerprint reader...') {
                                          final result = await platform
                                              .invokeMethod<String>(
                                                  'onFingerprintVerify2');
                                          setState(() {
                                            fingerPrn = true;
                                            fingerPrintVerify =
                                                result.toString();
                                          });
                                        }
                                      } on PlatformException catch (e) {
                                        setState(() {
                                          fingerPrintVerify = "${e.message}";
                                        });
                                      }
                                    },
                                    child: const Text('Fingerprint Verify'),
                                  ),
                                  fingerPrn
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : Container(),
                                  Text(fingerPrintVerify),
                                  SizedBox(
                                    height: 100.h,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (fingerPrintVerify ==
                                              "Fingerprint matches fingerprint in MyKad") {
                                            credentials.put(
                                                'fingerPrnStatus', 'Y');
                                            credentials.put(
                                                'myKadDetails', readMyKad);
                                            Navigator.of(context)
                                                .pop('refresh');
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Fail to Thumb'),
                                                  content: const Text(
                                                      'Please Verify Your Thumbprint.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        });
                                      },
                                      child: const Text('Thumb')),
                                  SizedBox(
                                    height: 60.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            )));
  }
}
