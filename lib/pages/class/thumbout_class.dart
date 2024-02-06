import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/services/model/epandu_model.dart';
import 'package:edriving_spim_app/common_library/services/repository/class_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/epandu_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/instructor_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/student_repository.dart';
import 'package:edriving_spim_app/common_library/services/response.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/common_library/utils/custom_dialog.dart';
import 'package:edriving_spim_app/router.gr.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

@RoutePage()
class Thumbout extends StatefulWidget {
  final groupId;
  final courseCode;
  final startTime;
  final vehNo;
  const Thumbout({super.key, required this.groupId, required this.courseCode, required this.startTime, required this.vehNo});

  @override
  State<Thumbout> createState() => _ThumboutState();
}

class _ThumboutState extends State<Thumbout> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  final primaryColor = ColorConstant.primaryColor;
  DateTime today = DateTime.now();
  final formKey = GlobalKey<FormState>();
  final customDialog = CustomDialog();
  final groupIdController = TextEditingController();
  final vehicleController = TextEditingController();
  final courseCodeController = TextEditingController();
  static const platform = MethodChannel('samples.flutter.dev/mykad');
  final groupIdFocus = FocusNode();
  final vehicleFocus = FocusNode();
  final courseCodeFocus = FocusNode();
  final studRepo = StudRepo();
  final trnRepo = InstructorRepo();
  final epanduRepo = EpanduRepo();
  final classRepo = ClassRepo();
  bool _lazyload = false;
  int year = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;
  String textByte = '';
  String mifareIc = '';
  String status = '';
  String readMyKad = '';
  String checkResult = '';
  String studcheckResult = '';
  String dsCode = '';
  String studentIc = '';
  String trainerIc = '';
  String thumboutTime = '';
  String trainerThumboutTime = '';
  String fingerPrnStatus = 'N';
  final credentials = Hive.box('credentials');

  String convertTimeFormat(String inputTime) {
    try {
      // Parse the input time string to a DateTime object
      DateTime dateTime = DateFormat('hh:mm a').parse(inputTime);

      // Format the DateTime object to the desired time format
      String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

      return formattedTime;
    } catch (e) {
      // Handle any parsing errors
      print('Error parsing time: $e');
      return 'Invalid Time';
    }
  }

  getIcByMifareCard() async {
    setState(() {
      _lazyload = true;
    });
    var result = await classRepo.getCustomerByMifareCard(
      context: context,
      cardNo: textByte
    );

    if (result.isSuccess){
      setState(() {
        for (var i = 0; i < result.data.length; i++) {
          mifareIc = result.data[i].icNo;
          credentials.put('myKadDetails', mifareIc);
        }
      });
      refreshData();
      return result.data;
    } else {
      setState(() {
        _lazyload = false;
      });
      if (!context.mounted) return;
      customDialog.show(
        context: context,
        title: const Center(
          child: Icon(
            Icons.check_circle_outline,
            color: Colors.red,
            size: 120,
          ),
        ),
        content:
            'This MiFare card is not registered as student or trainer',
        barrierDismissable: false,
        type: DialogType.error,
        onPressed: () async {
          context.router.pop();
        },
      );
      return result.message;
    }
  }

  thumboutStuPrac() async {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    String stud = credentials.get('studentIc') ?? '';
    String trn = credentials.get('trainerIc') ?? '';
    String outTime = credentials.get('thumboutTime') ?? '';
    if (stud != '' && trn != ''){
      var result = await classRepo.saveStuPrac(
          icNo: stud,
          groupId: widget.groupId,
          startTime: widget.startTime,
          endTime: convertTimeFormat(outTime),
          courseCode: widget.courseCode,
          trandateString: '$year-$month-$day',
          trnCode: credentials.get('trncode') ?? '',
          byFingerPrn: fingerPrnStatus,
          dsCode: dsCode,
          vehNo: widget.vehNo);

      if(result.isSuccess){
        EasyLoading.dismiss();
        credentials.delete('myKadDetails');
        credentials.delete('fingerPrnStatus');
        if (!context.mounted) return;
        customDialog.show(
            context: context,
            title: const Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 120,
              ),
            ),
            content: 'Successfully Thumbed Out',
            barrierDismissable: false,
            type: DialogType.success,
            onPressed: () async {
              await context.router.pop();
              if (!context.mounted) return;
              Navigator.of(context).pop('refresh');
            });
      } else {
        if (!context.mounted) return;
        EasyLoading.dismiss();
        customDialog.show(
          context: context,
          content: 'Fail To Thumb Out',
          onPressed: () => Navigator.pop(context),
          type: DialogType.error,
        );
      }
    } else {
      if (!context.mounted) return;
      EasyLoading.dismiss();
      customDialog.show(
        context: context,
        content: 'Student or Trainer Not Thumbed Yet',
        onPressed: () => Navigator.pop(context),
        type: DialogType.error,
      );
    }
  }

  checkStuTrn() async {
    var result = await studRepo.getStudent(
        context: context,
        searchBy: 'search_by_code',
        searchValue: credentials.get('myKadDetails') ?? '');
    if (!context.mounted) return;
    var response = await trnRepo.getTrainerList(
        context: context,
        startIndex: 0,
        noOfRecords: 1,
        groupId: '',
        keywordSearch: credentials.get('myKadDetails') ?? '');

    if (result.isSuccess) {
      setState(() {
        studcheckResult = 'Student';
        studentIc = credentials.get('myKadDetails') ?? '';
        credentials.put('studentIc', studentIc);
      });
      getEnrollByIC(studcheckResult);
      return result.data;
    } else if (response.isSuccess) {
      setState(() {
        checkResult = 'Trainer';
        trainerIc = credentials.get('myKadDetails') ?? '';
        credentials.put('trainerIc', trainerIc);
      });
      getEnrollByIC(checkResult);
      return response.data;
    } else {
      setState(() {
        _lazyload = false;
        credentials.delete('studentIc');
        credentials.delete('trainerIc');
        customDialog.show(
          context: context,
          content: 'This is not registered as Trainer or Student',
          onPressed: () => Navigator.pop(context),
          type: DialogType.error,
        );
      });
    }
    return result.message;
  }

  getEnrollByIC(String checked) async {
    Response<List<Enroll>?> result = await epanduRepo.getEnrollByCode(
        groupId: groupIdController.text,
        icNo: credentials.get('myKadDetails') ?? '');

    if (result.isSuccess) {
      setState(() {
        dsCode = result.data?[0].dsCode ?? '';

        if (checked == 'Student') {
          _lazyload = false;
          thumboutTime = DateFormat('HH:mm a').format(today);
          credentials.put('thumboutTime', thumboutTime);
          if (!context.mounted) return;
          customDialog.show(
            context: context,
            title: const Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 120,
              ),
            ),
            content: 'Successfully Thumb Out\n Time will be $thumboutTime',
            barrierDismissable: false,
            type: DialogType.success,
            onPressed: () async {
              context.router.pop();
            },
          );
        } else if (checked == 'Trainer') {
          _lazyload = false;
          trainerThumboutTime = DateFormat('HH:mm a').format(today);
          credentials.put('trainerThumboutTime', trainerThumboutTime);
          if (!context.mounted) return;
          customDialog.show(
            context: context,
            title: const Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 120,
              ),
            ),
            content: 'Successfully Thumb Out\n Time will be $trainerThumboutTime',
            barrierDismissable: false,
            type: DialogType.success,
            onPressed: () async {
              context.router.pop();
            },
          );
        }
      });

      return result.data;
    } else {
      _lazyload = false;
      if (credentials.get('studentIc') != '') {
          setState(() {
            credentials.delete('studentIc');
          });
        } else if (credentials.get('trainerIc') != '') {
          setState(() {
            credentials.delete('trainerIc');
          });
        }
      if (!context.mounted) return;
      customDialog.show(
        context: context,
        title: const Center(
          child: Icon(
            Icons.check_circle_outline,
            color: Colors.red,
            size: 120,
          ),
        ),
        content:
            'Calon Belum Mendaftar Kelas ${groupIdController.text}. Sila Buat Pendaftaran di Kaunter',
        barrierDismissable: false,
        type: DialogType.error,
        onPressed: () async {
          context.router.pop();
        },
      );
    }
    return result.message;
  }

  void refreshData(){
    setState(() {
      fingerPrnStatus = credentials.get('fingerPrnStatus') ?? 'N';
      _lazyload = true;
      checkStuTrn();
    });
  }

  void tagRead(){
    NfcManager.instance.isAvailable().then((isAvailable) {
      if (isAvailable) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ready to Scan'),
              content: const Text('Hold your device near the item'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            result.value = tag.data;

            Ndef? ndef = Ndef.from(tag);
            final languageCodeLength =
                ndef!.cachedMessage!.records[0].payload.first;
            final textBytes = ndef.cachedMessage!.records[0].payload
                .sublist(1 + languageCodeLength);
            print(utf8.decode(textBytes));
            NfcManager.instance.stopSession();
            setState(() {
              textByte = utf8.decode(textBytes);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Success'),
                    content: Text('Tag Read Completed. Your tag number will be $textByte'),
                    actions: [
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () async {
                          await context.router.pop();
                          if (!context.mounted) return;
                          context.router.pop();
                          getIcByMifareCard();
                        },
                      )
                    ],
                  );
                },
              );
            });
          },
          onError: (dynamic error) {
            print('Error during NFC session: $error');
            return error;
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'NFC is not available for this device or may be temporarily turned off.'),
              actions: [
                TextButton(
                  child: const Text('GOT IT'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      // Handle errors related to checking NFC availability
      print('Error checking NFC availability: $error');
    });
  }

  @override
  void initState(){
    super.initState();

    credentials.delete('studentIc');
    credentials.delete('trainerIc');
    credentials.delete('thumboutTime');
    credentials.delete('trainerThumboutTime');

    year = today.year;
    month = today.month;
    day = today.day;
    hour = today.hour;
    minute = today.minute;
    second = today.second;
  }

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
                Text(AppLocalizations.of(context)!.translate('thumbout_lbl')),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              child: Column(
                children: [
                  _lazyload
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(30)),
                          child: const Center(
                            child: SpinKitHourGlass(color: Colors.white),
                          ),
                        )
                      : InkWell(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "${DateFormat('EEEE').format(today)} ,$day-$month-$year",
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      "Current Time: ${DateFormat('HH:mm a').format(DateTime.now())}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Group Id: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50.w,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 15),
                                                    controller: groupIdController,
                                                    focusNode: groupIdFocus,
                                                    enabled: false,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      focusedErrorBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 3,
                                                                      color: Colors
                                                                          .red)),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 3,
                                                                      color: Colors
                                                                          .blue)),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black)),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      hintStyle: TextStyle(
                                                        color: primaryColor,
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      labelText: widget.groupId 
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 100.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const Text(
                                                  'Course Code: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50.w,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 15),
                                                    controller:
                                                        courseCodeController,
                                                    focusNode: courseCodeFocus,
                                                    enabled: false,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      focusedErrorBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 3,
                                                                      color: Colors
                                                                          .red)),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 3,
                                                                      color: Colors
                                                                          .blue)),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black)),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      hintStyle: TextStyle(
                                                        color: primaryColor,
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      labelText: widget.courseCode
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 100.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const Text(
                                                  'Vehicle: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50.w,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 15),
                                                    controller:
                                                        vehicleController,
                                                    focusNode: vehicleFocus,
                                                    enabled: false,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      focusedErrorBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 3,
                                                                      color: Colors
                                                                          .red)),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 3,
                                                                      color: Colors
                                                                          .blue)),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black)),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      hintStyle: TextStyle(
                                                        color: primaryColor,
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      labelText: widget.vehNo
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 300.h,
                                    ),
                                    const Text(
                                      'Thumb In by',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () async {
                                            EasyLoading.show(
                                              maskType:
                                                  EasyLoadingMaskType.black,
                                            );
                                            try {
                                              final result = await platform
                                                  .invokeMethod<String>(
                                                      'onCreate');
                                              setState(() {
                                                status = result.toString();
                                              });
                                            } on PlatformException catch (e) {
                                              setState(() {
                                                status = "'${e.message}'.";
                                              });
                                            }
                                            try {
                                              final result = await platform
                                                  .invokeMethod<String>(
                                                      'onReadMyKad');
                                              setState(() {
                                                readMyKad = result.toString();
                                              });
                                            } on PlatformException catch (e) {
                                              setState(() {
                                                readMyKad = "'${e.message}'";
                                              });
                                            }
                                            if (formKey.currentState!
                                                .validate()) {
                                              formKey.currentState!.save();
                                              if (status == "Connect success") {
                                                if (!context.mounted) return;
                                                EasyLoading.dismiss();
                                                customDialog.show(
                                                  context: context,
                                                  title: const Center(
                                                    child: Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                      size: 120,
                                                    ),
                                                  ),
                                                  content: 'Connected success',
                                                  barrierDismissable: false,
                                                  type: DialogType.success,
                                                  onPressed: () async {
                                                    await context.router.pop();
                                                    if (!context.mounted) return;
                                                    var refresh = await context
                                                        .router
                                                        .push(MyKad(
                                                            groupId:
                                                                groupIdController
                                                                    .text,
                                                            courseCode:
                                                                courseCodeController
                                                                    .text));
                                                    if (refresh == 'refresh') {
                                                      refreshData();
                                                    }
                                                  },
                                                );
                                              } else {
                                                if (!context.mounted) return;
                                                EasyLoading.dismiss();
                                                customDialog.show(
                                                  context: context,
                                                  content:
                                                      'Fail to connect device',
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  type: DialogType.error,
                                                );
                                              }
                                            } else {
                                              if (!context.mounted) return;
                                              EasyLoading.dismiss();
                                              if (groupIdController
                                                  .text.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(groupIdFocus);
                                              } else if (courseCodeController
                                                  .text.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        courseCodeFocus);
                                              }
                                            }
                                          },
                                          child: const Text('My Kad'),
                                        ),
                                        SizedBox(
                                          width: 100.w,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            EasyLoading.show(
                                              maskType:
                                                  EasyLoadingMaskType.black,
                                            );
                                            if (formKey.currentState!
                                                .validate()) {
                                              EasyLoading.dismiss();
                                              formKey.currentState!.save();
                                              tagRead();
                                            } else {
                                              EasyLoading.dismiss();
                                              if (groupIdController
                                                  .text.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(groupIdFocus);
                                              } else if (courseCodeController
                                                  .text.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        courseCodeFocus);
                                              }
                                            }
                                          },
                                          child: const Text('MiFare'),
                                        ),
                                        // ElevatedButton(
                                        //   onPressed: () async {
                                        //     var refresh = await context.router.push(MyKad(
                                        //                 groupId:
                                        //                     groupIdController
                                        //                         .text,
                                        //                 courseCode:
                                        //                     courseCodeController
                                        //                         .text));
                                        //     if (refresh == 'refresh') {
                                        //       refreshData();
                                        //     }
                                        //   },
                                        //   child: const Text('Testing'),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    // Text(status),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    Text(
                                        'Student details: ${credentials.get('studentIc') ?? 'No student thumbed yet'}  ${credentials.get('thumboutTime') ?? ''}'),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    Text(
                                        'Trainer details: ${credentials.get('trainerIc') ?? 'No trainer thumbed yet'}  ${credentials.get('trainerThumboutTime') ?? ''}'),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        thumboutStuPrac();
                                      },
                                      child: const Text('Thumbout'),
                                    ),
                                    SizedBox(
                                      height: 200.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}