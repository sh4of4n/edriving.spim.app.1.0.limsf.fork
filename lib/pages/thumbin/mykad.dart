import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/router.gr.dart';
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
  final myImage = ImagesConstant();
  final primaryColor = ColorConstant.primaryColor;
  static const platform = MethodChannel('samples.flutter.dev/mykad');
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
                Text(AppLocalizations.of(context)!.translate('myKad_lbl')),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(600)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                      child: Card(
                        child: SizedBox(
                          width: 1000.w,
                          height: 1500.h,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  myImage.mykadimg,
                                  height: 150,
                                ),
                                SizedBox(
                                  height: 50.h,
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
                                  child: const Text('Read My Kad Details'),
                                ),
                                Text(readMyKad),
                                SizedBox(
                                  height: 120.h,
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
                                Text(fingerPrintVerify),
                                SizedBox(
                                  height: 120.h,
                                ),
                                ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      if(fingerPrintVerify == "Fingerprint matches fingerprint in MyKad"){
                                        context.router.push(AddClass(
                                          myKadDetails: readMyKad
                                        ));
                                      } else {
                                        
                                      }
                                    });
                                  }, 
                                  child: const Text('Thumb In')
                                ),
                                SizedBox(
                                  height: 120.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ),
            ),
          ),
        )
      )
    );
  }
}