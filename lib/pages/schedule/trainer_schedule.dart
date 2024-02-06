import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:edriving_spim_app/common_library/services/repository/epandu_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/instructor_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/payment_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/schedule_repository.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/common_library/utils/custom_dialog.dart';
import 'package:edriving_spim_app/common_library/utils/local_storage.dart';
import 'package:edriving_spim_app/router.gr.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class TrainerSchedule extends StatefulWidget {
  const TrainerSchedule({super.key});

  @override
  State<TrainerSchedule> createState() => _TrainerScheduleState();
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _TrainerScheduleState extends State<TrainerSchedule> {
  final primaryColor = ColorConstant.primaryColor;
  Future? _getTrainer;
  final localStorage = LocalStorage();
  final customDialog = CustomDialog();
  final scheduleRepo = ScheduleRepo();
  final trainerRepo = InstructorRepo();
  final paymentRepo = PaymentRepo();
  final epanduRepo = EpanduRepo();
  final selectedDateFocus = FocusNode();
  final selectedDateController = TextEditingController();
  final calendarController = CalendarController();
  DateTime today = DateTime.now();
  final int _startIndex = 0;
  final int _noOfRecord = 100;
  var timeLogData;
  List<Appointment> meetings = <Appointment>[];
  String startDt = '';
  String endDt = '';
  String startDate = '';
  String endDate = '';
  // String subject = 'No subject';
  String studentIc = '';
  String add1 = '';
  String add2 = '';
  String add3 = '';
  String state = '';
  String city = '';
  String zip = '';
  String courseCode = '';
  String cupertinoDob = '';
  String totalAdd = '';
  String groupId = '';
  String testDt = '';
  String icNo = '';
  String trnCode = '';
  String licenseType = '';
  String licenseExpDt = '';
  String trnName = '';
  String phnNo = '';
  String vehNo = '';
  String name = '';
  String dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String dateTo = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String nxtAppDt = '';
  String address = '';
  String _message = '';
  String message = '';
  bool noData = false;
  String totalPrice = '';
  String paidAmount = '';
  double checking = 0;
  String paymentStatus = '';
  DateTime selectedDate = DateTime.now();

  getTrainerInfo() async {
    var result = await trainerRepo.getTrainerInfo(context: context);

    if (result.isSuccess) {
      for (var i = 0; i < result.data.length; i++) {
        if (result.data[i].trnCode != null) {
          setState(() {
            trnCode = result.data[i].trnCode;
            // trnCode = 'SHAIK';
            trnName = result.data[i].trnName;
          });
        }
      }
      if (!context.mounted) return;
      var response = await scheduleRepo.getTrainerSchedule(
          context: context,
          dateFrom: dateFrom,
          dateTo: dateTo,
          startIndex: _startIndex,
          trnCode: trnCode,
          noOfRecords: _noOfRecord);
      if (response.isSuccess) {
        setState(() {
          for (var i = 0; i < response.data.length; i++) {
            if (response.data[i].startDate != null) {
              startDt = response.data[i].startDate;
              endDt = response.data[i].endDate;
            } else {
              startDt = calendarController.selectedDate.toString();
              endDt = calendarController.selectedDate.toString();
            }
            courseCode = response.data[i].courseCode ?? '-';
            groupId = response.data[i].groupId ?? '-';
            // subject = result.data[i].subject ?? 'No Subject';
            studentIc = response.data[i].icNo ?? '-';
            add1 = response.data[i].add1 ?? '-';
            add2 = response.data[i].add2 ?? '';
            add3 = response.data[i].add3 ?? '';
            state = response.data[i].state ?? '-';
            city = response.data[i].city ?? '-';
            zip = response.data[i].zip ?? '-';
            phnNo = response.data[i].phnNo ?? '-';
            address = '$add1, $add2, $add3';
            vehNo = response.data[i].vehNo ?? '-';
            name = response.data[i].name ?? '-';
            getAppointments(startDt, endDt, address, state, city, zip,
                studentIc, phnNo, vehNo, name);
          }
        });
        return response.data;
      } else{
        setState(() {
          if (result.message == null) {
            _message = 'No appointments today';
          } else {
            _message = result.message!;
          }
        });
      }

      return result.data;
    } else {
      setState(() {
        noData = true;
        if (result.message == null) {
          message = 'Trainer not registered';
        } else {
          message = result.message!;
        }
      });
      return message;
    }
  }

  _getDTestByCode(String icNo) async {
    var response = await epanduRepo.getDTestByCode(
      context: context,
      icNo: icNo,
    );
    if (!context.mounted) return;
    var result = await scheduleRepo.getStudentLicense(
      context: context,
      icNo: icNo,
      licenseType: 'L',
    );
    if (!context.mounted) return;
    var results = await paymentRepo.getStudentPaymentStatus(
      context: context,
      icNo: icNo,
      startIndex: _startIndex,
      noOfRecords: _noOfRecord,
    );

    if (result.isSuccess) {
      setState(() {
        for (var i = 0; i < response.data.length; i++) {
          licenseExpDt = convertDateFormat(result.data[i].expDate);
        }
      });
    } else {
      setState(() {
        licenseExpDt = 'Expiry Date Not Set';
      });
    }

    if (response.isSuccess) {
      setState(() {
        for (var i = 0; i < response.data.length; i++) {
          testDt = convertDateFormat(response.data[i].testDate);
        }
      });
    } else {
      setState(() {
        testDt = 'Test Date Not Set';
      });
    }

    if (results.isSuccess) {
      setState(() {
        for (var i = 0; i < results.data.length; i++) {
          totalPrice = results.data[i].tranTotal;
          paidAmount = results.data[i].payAmount;
          checking = double.parse(totalPrice) - double.parse(paidAmount);
          if (checking == 0) {
            paymentStatus = 'Paid';
          } else if (checking > 0) {
            paymentStatus =
                'Still having RM${checking.toStringAsFixed(2)} not paid';
          } else if (checking < 0) {
            paymentStatus =
                'User had paid extra RM${checking.abs().toStringAsFixed(2)}';
          }
        }
      });
      return results.data;
    } else {
      setState(() {
        totalPrice = '-';
        paidAmount = '-';
        paymentStatus = '-';
      });
    }
    return results.message;
  }

  List<Appointment> getAppointments(startDt, endDt, address, state, city, zip,
      studentIc, phnNo, vehNo, name) {
    DateTime startTime;
    DateTime endTime;

    startTime = DateTime.parse(parseDateWithoutOffset(startDt));
    endTime = DateTime.parse(parseDateWithoutOffset(endDt));

    String formattedString =
        '$courseCode   \n$groupId\n$studentIc\n${extractTimeFromDateTimeString(startTime)} -> ${extractTimeFromDateTimeString(endTime)}\n$name\n$phnNo\n$vehNo';

    int year = startTime.year;
    int month = startTime.month;
    int day = startTime.day;
    int hour = startTime.hour;
    int minute = startTime.minute;
    int second = startTime.second;
    int endYear = endTime.year;
    int endMonth = endTime.month;
    int endDay = endTime.day;
    int endHour = endTime.hour;
    int endMinute = endTime.minute;
    int endSecond = endTime.second;

    setState(() {
      meetings.add(Appointment(
        startTime: DateTime(year, month, day, hour, minute, second),
        endTime:
            DateTime(endYear, endMonth, endDay, endHour, endMinute, endSecond),
        subject: formattedString.trim(),
        notes: '$address,$state,$city,$zip',
        color: Colors.blue,
        // recurrenceRule: 'FREQ=DAILY;COUNT=10',
        // isAllDay: true
      ));
    });
    // startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    // endTime = startTime.add(const Duration(hours: 2));

    return meetings;
  }

  String extractTimeFromDateTimeString(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    return time.format(context);
  }

  DateTime convertTimeStringToDateTime(String timeString) {
    final formattedTime = DateFormat('HH:mm').parse(timeString);
    return formattedTime;
  }

  String parseDateWithoutOffset(String dateString) {
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
    DateTime dateTime = format.parse(dateString);
    return DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").format(dateTime);
  }

  String convertDateFormat(String dateString) {
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
    DateTime dateTime = format.parse(dateString);
    String formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);

    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    _getTrainer = getTrainerInfo();

    setState(() {
      selectedDateController.text = DateFormat('yyyy-MM-dd').format(
        today,
      );
      // if(today.isBefore(DateTime.parse(startDt))){
      //   nxtAppDt = startDt;
      // }
    });
  }

//   void openMapWithAddress(String address) async {

//   Uri mapUri = Uri(
//   scheme: 'https',
//   host: 'www.google.com',
//   path: '/maps/search/',
//   queryParameters: {
//     'api': '1',
//     'query': address,
//   },
// );

//   if (await canLaunchUrl(mapUri)) {
//     await launchUrl(mapUri);
//   } else {
//     throw 'Could not launch $mapUri';
//   }
// }

  Future<List<Location>> getLocationFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      return locations;
    } catch (e) {
      print("Error converting address to coordinates: $e");
      return [];
    }
  }

  _openDestination(context) async {
    try {
      const title = 'Student Address';
      final locations = await getLocationFromAddress(totalAdd);
      String description = totalAdd;
      double latitude = locations[0].latitude;
      double longitude = locations[0].longitude;
      final coords = Coords(latitude, longitude);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          map.showMarker(
                            coords: coords,
                            title: title,
                            description: description,
                          );
                        },
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  refreshData() {
    setState(() {
      meetings.clear();
      dateFrom = cupertinoDob;
      dateTo = cupertinoDob;
      _getTrainer = getTrainerInfo();
    });
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
            title: Text(AppLocalizations.of(context)!.translate('scd_lbl')),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DateTimeField(
                    focusNode: selectedDateFocus,
                    controller: selectedDateController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    readOnly: true,
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.blue)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white)),
                      contentPadding: const EdgeInsets.all(10.0),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      prefixIcon: const Text('    Date:',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                    onShowPicker: (context, currentValue) async {
                      if (Platform.isAndroid) {
                        if (selectedDateController.text.isEmpty) {
                          setState(() {
                            selectedDateController.text =
                                DateFormat('yyyy-MM-dd').format(
                              today,
                            );
                          });
                        }

                        await showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              title: const Text('Pick a date'),
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Cancel'),
                                onPressed: () => context.router.pop(),
                              ),
                              actions: <Widget>[
                                SizedBox(
                                  height: 900.h,
                                  child: CupertinoDatePicker(
                                    initialDateTime: DateTime.parse(
                                        selectedDateController.text),
                                    onDateTimeChanged: (DateTime date) {
                                      setState(() {
                                        cupertinoDob = DateFormat('yyyy-MM-dd')
                                            .format(date);
                                      });
                                    },
                                    minimumYear: 2000,
                                    maximumYear: 2100,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    if (cupertinoDob.isNotEmpty) {
                                      selectedDateController.text =
                                          cupertinoDob;
                                      calendarController.selectedDate =
                                          DateTime.parse(cupertinoDob);
                                      calendarController.displayDate =
                                          DateTime.parse(cupertinoDob);
                                      // credentials.put('date', cupertinoDob);
                                    }
                                    refreshData();
                                    context.router.pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            initialDate: currentValue ?? today,
                            lastDate: DateTime(2100));
                      }
                      return null;
                    },
                  ),
                  FutureBuilder(
                    future: _getTrainer,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(600)),
                            child: const Center(
                              child: SpinKitHourGlass(color: Colors.white),
                            ),
                          );
                        case ConnectionState.done:
                          if (snapshot.data is String) {
                            return Container(
                              margin: const EdgeInsets.only(top: 30.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    trnCode,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      trnName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  noData
                                      ? Text(
                                          message,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          snapshot.data,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  SizedBox(
                                    height: 60.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () {
                                          setState(
                                            () {
                                              String date = '';
                                              selectedDate =
                                                  selectedDate.subtract(
                                                      const Duration(days: 1));
                                              date = DateFormat('yyyy-MM-dd')
                                                  .format(selectedDate);
                                              selectedDateController.text =
                                                  date;
                                              cupertinoDob = date;
                                            },
                                          );
                                          calendarController.backward!();
                                          refreshData();
                                        },
                                        label: const Text('Previous'),
                                      ),
                                      SizedBox(
                                        width: 200.w,
                                      ),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          setState(
                                            () {
                                              String date = '';
                                              selectedDate = selectedDate
                                                  .add(const Duration(days: 1));
                                              date = DateFormat('yyyy-MM-dd')
                                                  .format(selectedDate);
                                              selectedDateController.text =
                                                  date;
                                              cupertinoDob = date;
                                            },
                                          );
                                          calendarController.forward!();
                                          refreshData();
                                        },
                                        label: const Text('Next'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 60.h,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(2200),
                                    child: SfCalendar(
                                      controller: calendarController,
                                      view: CalendarView.day,
                                      initialSelectedDate: today,
                                      initialDisplayDate: today,
                                      onViewChanged: (ViewChangedDetails
                                          viewChangedDetails) {
                                        selectedDate =
                                            viewChangedDetails.visibleDates[0];
                                      },
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '($trnCode)',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        trnName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // Text('Next Appointment Date: $nxtAppDt', style: const TextStyle(
                                    //   fontSize: 20,
                                    //   color: Colors.white,
                                    //   fontWeight: FontWeight.bold
                                    // ),),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: () {
                                            setState(() {
                                              String date = '';
                                              selectedDate =
                                                  selectedDate.subtract(
                                                      const Duration(days: 1));
                                              date = DateFormat('yyyy-MM-dd')
                                                  .format(selectedDate);
                                              selectedDateController.text =
                                                  date;
                                              cupertinoDob = date;
                                            });
                                            calendarController.backward!();
                                            refreshData();
                                          },
                                          label: const Text('Previous'),
                                        ),
                                        SizedBox(
                                          width: 200.w,
                                        ),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.arrow_forward),
                                          onPressed: () {
                                            setState(() {
                                              String date = '';
                                              selectedDate = selectedDate
                                                  .add(const Duration(days: 1));
                                              date = DateFormat('yyyy-MM-dd')
                                                  .format(selectedDate);
                                              selectedDateController.text =
                                                  date;
                                              cupertinoDob = date;
                                            });
                                            calendarController.forward!();
                                            refreshData();
                                          },
                                          label: const Text('Next'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 60.h,
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(2200),
                                      child: SfCalendar(
                                        controller: calendarController,
                                        view: CalendarView.day,
                                        initialSelectedDate: today,
                                        minDate: DateTime(2000 - 01 - 01),
                                        maxDate: DateTime(2100 - 12 - 31),
                                        initialDisplayDate: today,
                                        onViewChanged: (ViewChangedDetails
                                            viewChangedDetails) {
                                          selectedDate = viewChangedDetails
                                              .visibleDates[0];
                                        },
                                        backgroundColor: Colors.white,
                                        dataSource: MeetingDataSource(meetings),
                                        onTap: (CalendarTapDetails details)async {
                                          // dynamic appointment = details.appointments;
                                          // DateTime date = details.date!;
                                          // CalendarElement element = details.targetElement;
                                          EasyLoading.show(
                                            maskType: EasyLoadingMaskType.black,
                                          );
                                              if (details.targetElement ==
                                                  CalendarElement.appointment) {
                                                String totalAdd = details
                                                    .appointments?[0].notes;
                                                // List<String> partAdd =
                                                //     add.split('+');
                                                // String address =
                                                //     partAdd[0].trim();
                                                // String state =
                                                //     partAdd[1].trim();
                                                // String city = partAdd[2].trim();
                                                // String zip = partAdd[3].trim();
                                                // totalAdd =
                                                //     '$address, $state, $city, $zip';

                                                String subject = details
                                                    .appointments?[0].subject;
                                                List<String> parts =
                                                    subject.split('\n');
                                                String course = parts[0].trim();
                                                String groupid =
                                                    parts[1].trim();
                                                icNo = parts[2].trim();
                                                String timeRange = parts[3];
                                                String name = parts[4].trim();
                                                String phoneNumber =
                                                    parts[5].trim();
                                                String vehicleNo =
                                                    parts[6].trim();

                                                List<String> times =
                                                    timeRange.split(" -> ");
                                                String startTime =
                                                    times[0].trim();
                                                String endTime =
                                                    times[1].trim();

                                                await _getDTestByCode(icNo);
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                EasyLoading.dismiss();
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Student Details',
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                  'Name: $name \n'),
                                                              Text(
                                                                  'Phone Number: $phoneNumber \n'),
                                                              Text(
                                                                  "Student's Ic: $icNo\n"),

                                                              // '${widget.trnInfo.trnName ?? ''}',
                                                              // Text(
                                                              //     "Trainer's Name:  $trnName \n"),
                                                              Text(
                                                                  'Course Code: $course \n'),
                                                              Text(
                                                                  'Test Date: $testDt \n'),
                                                              Text(
                                                                  'License Expiry Date: $licenseExpDt \n'),
                                                              Text(
                                                                  'Group Id: $groupid \n'),
                                                              Text(
                                                                  'Vehicle Plate Number: $vehicleNo \n'),
                                                              Text(
                                                                  'Start Time: $startTime\n'
                                                                  'End Time: $endTime\n'),
                                                              Text(
                                                                  'Total Price: RM$totalPrice\n'
                                                                  'Paid Amount: RM$paidAmount\n'
                                                                  'Payment Status: $paymentStatus\n'),
                                                              Text(
                                                                  'Address: \n$totalAdd \n'),
                                                              // Text(
                                                              //   'Start Time: ${details.appointments?[0].startTime}\n'
                                                              //   'End Time: ${details.appointments?[0].endTime}',
                                                              // ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ElevatedButton
                                                                      .icon(
                                                                    onPressed:
                                                                        () {
                                                                      if (phoneNumber ==
                                                                          '-') {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              content: const Text('Please require admin to add a phone number to this student'),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const Text('Ok'),
                                                                                )
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      } else {
                                                                        var phoneNo = phoneNumber.replaceAll(
                                                                            "tel_hp:",
                                                                            "");

                                                                        final Uri
                                                                            telLaunchUri =
                                                                            Uri(
                                                                          scheme:
                                                                              'tel',
                                                                          path:
                                                                              phoneNo,
                                                                        );
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              content: const Text('Do you sure you want to call this number?'),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    launchUrl(telLaunchUri);
                                                                                  },
                                                                                  child: const Text('Call'),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const Text('Cancel'),
                                                                                )
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      }
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .phone),
                                                                    label: const Text(
                                                                        'Call'),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 50.w,
                                                                  ),
                                                                  ElevatedButton
                                                                      .icon(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .navigation_rounded),
                                                                    label: const Text(
                                                                        'Navigate'),
                                                                    onPressed:
                                                                        () {
                                                                      _openDestination(
                                                                          context);
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ElevatedButton
                                                                      .icon(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .location_on),
                                                                    label: const Text(
                                                                        'Address Location'),
                                                                    onPressed:
                                                                        () {
                                                                      context
                                                                          .router
                                                                          .push(
                                                                              MapScreen(
                                                                        address:
                                                                            totalAdd,
                                                                        studName:
                                                                            name,
                                                                      ));
                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            ]),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('Ok'),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else if (details.appointments ==
                                                      null ||
                                                  details
                                                      .appointments!.isEmpty) {
                                                EasyLoading.dismiss();
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Blank Event'),
                                                      content: const Text(
                                                          'No event is set at this time yet.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
                        default:
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(600)),
                            child: Center(
                              child: SpinKitHourGlass(color: primaryColor),
                            ),
                          );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
