import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/services/repository/class_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/epandu_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/schedule_repository.dart';
import 'package:edriving_spim_app/router.gr.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class TodayClass extends StatefulWidget {
  final trnCode;
  final todayClassInfo;
  final message;
  final trnName;
  final progressMsg;
  const TodayClass(
      {super.key,
      required this.trnCode,
      required this.trnName,
      required this.todayClassInfo,
      required this.message,
      required this.progressMsg});

  @override
  State<TodayClass> createState() => _TodayClassState();
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _TodayClassState extends State<TodayClass> {
  final myImage = ImagesConstant();
  final primaryColor = ColorConstant.primaryColor;
  final classRepo = ClassRepo();
  final epanduRepo = EpanduRepo();
  final credentials = Hive.box('credentials');
  final scheduleRepo = ScheduleRepo();
  DateTime today = DateTime.now();
  List<Appointment> meetings = <Appointment>[];
  String todayMessage = '';
  String courseCode = '';
  String groupId = '';
  String studentIc = '';
  String add1 = '';
  String add2 = '';
  String add3 = '';
  String state = '';
  String city = '';
  String zip = '';
  String phnNo = '';
  String address = '';
  String vehNo = '';
  String name = '';
  String startDt = '';
  String endDt = '';
  String totalAdd = '';
  String icNo = '';
  String licenseExpDt = '';
  String testDt = '';
  String trnCode = '';
  int year = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;
  int endYear = 0;
  int endMonth = 0;
  int endDay = 0;
  int endHour = 0;
  int endMinute = 0;
  int endSecond = 0;

  String extractTimeFromDateTimeString(DateTime dateTime) {
    String dateString = dateTime.toString();
    if (dateString != '') {
      final time = TimeOfDay.fromDateTime(dateTime);
      return time.format(context);
    } else {
      return '-';
    }
  }

  String parseDateWithoutOffset(String dateString) {
    if (dateString != '') {
      DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
      DateTime dateTime = format.parse(dateString);
      return DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").format(dateTime);
    } else {
      return '-';
    }
  }

  String convertDateFormat(String dateString) {
    if (dateString != '') {
      DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
      DateTime dateTime = format.parse(dateString);
      String formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);

      return formattedDate;
    } else {
      return '-';
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
      return response.data;
    } else {
      setState(() {
        testDt = 'Test Date Not Set';
      });
    }
    return response.message;
  }

  List<Appointment> getAppointments() {
    DateTime startTime;
    DateTime endTime;
    String extractedTime = '';
    String extractedEndTime = '';
    for (var i = 0; i < widget.todayClassInfo.length; i++) {
      setState(() {
        trnCode = widget.todayClassInfo[i].trnCode;
        startDt = widget.todayClassInfo[i].startDate;
        endDt = widget.todayClassInfo[i].endDate;
        courseCode = widget.todayClassInfo[i].courseCode ?? '-';
        groupId = widget.todayClassInfo[i].groupId ?? '-';
        // subject = result.data[i].subject ?? 'No Subject';
        studentIc = widget.todayClassInfo[i].icNo ?? '-';
        add1 = widget.todayClassInfo[i].add1 ?? '-';
        add2 = widget.todayClassInfo[i].add2 ?? '';
        add3 = widget.todayClassInfo[i].add3 ?? '';
        state = widget.todayClassInfo[i].state ?? '-';
        city = widget.todayClassInfo[i].city ?? '-';
        zip = widget.todayClassInfo[i].zip ?? '-';
        phnNo = widget.todayClassInfo[i].handPhone ?? '-';
        address = '$add1, $add2, $add3';
        vehNo = widget.todayClassInfo[i].vehNo ?? '-';
        name = widget.todayClassInfo[i].name ?? '-';
      });
    }
    if (startDt != '') {
      setState(() {
        startTime = DateTime.parse(parseDateWithoutOffset(startDt));
        year = startTime.year;
        month = startTime.month;
        day = startTime.day;
        hour = startTime.hour;
        minute = startTime.minute;
        second = startTime.second;
        extractedTime = extractTimeFromDateTimeString(startTime);
      });
    } else {}
    if (endDt != '') {
      setState(() {
        endTime = DateTime.parse(parseDateWithoutOffset(endDt));
        endYear = endTime.year;
        endMonth = endTime.month;
        endDay = endTime.day;
        endHour = endTime.hour;
        endMinute = endTime.minute;
        endSecond = endTime.second;
        extractedEndTime = extractTimeFromDateTimeString(endTime);
      });
    }

    String formattedString =
        '$courseCode   \n$groupId\n$studentIc\n$extractedTime -> $extractedEndTime\n$name\n$phnNo\n$vehNo';

    setState(() {
      meetings.add(Appointment(
        startTime: DateTime(year, month, day, hour, minute, second),
        endTime:
            DateTime(endYear, endMonth, endDay, endHour, endMinute, endSecond),
        subject: formattedString.trim(),
        notes: '$address+$state+$city+$zip',
        color: Colors.blue,
        // recurrenceRule: 'FREQ=DAILY;COUNT=10',
        // isAllDay: true
      ));
    });
    // startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    // endTime = startTime.add(const Duration(hours: 2));

    return meetings;
  }

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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getAppointments();
    });
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     setState(() {
    //       _lazyload = true;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: SizedBox(
            child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              if (widget.progressMsg == 'No') {
                credentials.put('trncode', widget.trnCode);
                context.router.push(AddClass(
                    fingerPrnStatus: 'N',
                    myKadDetails: '',
                    courseCode: '',
                    groupId: ''));
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Fail to Add Class'),
                      content: const Text('There is a class in progressing cannot add class.\n Please check progress tab and thumbout to add a new class.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            backgroundColor: const Color.fromARGB(255, 243, 33, 33),
            child: const Icon(Icons.add),
          ),
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '(${widget.trnCode})',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.trnName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (widget.message == "No class today")
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "No class today",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        height: 60.h,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(2200),
                        child: SfCalendar(
                          view: CalendarView.day,
                          initialSelectedDate: today,
                          minDate: DateTime(2000 - 01 - 01),
                          maxDate: DateTime(2100 - 12 - 31),
                          initialDisplayDate: today,
                          backgroundColor: Colors.white,
                          dataSource: MeetingDataSource(meetings),
                          onTap: (CalendarTapDetails details) {
                            // dynamic appointment = details.appointments;
                            // DateTime date = details.date!;
                            // CalendarElement element = details.targetElement;
                            EasyLoading.show(
                              maskType: EasyLoadingMaskType.black,
                            );
                            setState(
                              () async {
                                if (details.targetElement ==
                                    CalendarElement.appointment) {
                                  String add = details.appointments?[0].notes;
                                  List<String> partAdd = add.split('+');
                                  String address = partAdd[0].trim();
                                  String state = partAdd[1].trim();
                                  String city = partAdd[2].trim();
                                  String zip = partAdd[3].trim();
                                  totalAdd = '$address, $state, $city, $zip';

                                  String subject =
                                      details.appointments?[0].subject;
                                  List<String> parts = subject.split('\n');
                                  String course = parts[0].trim();
                                  String groupid = parts[1].trim();
                                  icNo = parts[2].trim();
                                  String timeRange = parts[3];
                                  String name = parts[4].trim();
                                  String phoneNumber = parts[5].trim();
                                  String vehicleNo = parts[6].trim();

                                  List<String> times = timeRange.split(" -> ");
                                  String startTime = times[0].trim();
                                  String endTime = times[1].trim();

                                  await _getDTestByCode(icNo);
                                  if (!context.mounted) {
                                    return;
                                  }
                                  EasyLoading.dismiss();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Student Details',
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Name: $name \n'),
                                                Text(
                                                    'Phone Number: $phoneNumber \n'),
                                                Text("Student's Ic: $icNo\n"),

                                                // '${widget.trnInfo.trnName ?? ''}',
                                                Text(
                                                    "Trainer's Name:  ${widget.trnName} \n"),
                                                Text('Course Code: $course \n'),
                                                Text('Test Date: $testDt \n'),
                                                Text(
                                                    'License Expiry Date: $licenseExpDt \n'),
                                                Text('Group Id: $groupid \n'),
                                                Text(
                                                    'Vehicle Plate Number: $vehicleNo \n'),
                                                Text('Start Time: $startTime\n'
                                                    'End Time: $endTime\n'),
                                                Text(
                                                    'Address: \n$address, $state, $city, $zip \n'),
                                                // Text(
                                                //   'Start Time: ${details.appointments?[0].startTime}\n'
                                                //   'End Time: ${details.appointments?[0].endTime}',
                                                // ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        if (phoneNumber ==
                                                            '-') {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                content: const Text(
                                                                    'Please require admin to add a phone number to this student'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                            'Ok'),
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          var phoneNo =
                                                              phoneNumber
                                                                  .replaceAll(
                                                                      "tel_hp:",
                                                                      "");

                                                          final Uri
                                                              telLaunchUri =
                                                              Uri(
                                                            scheme: 'tel',
                                                            path: phoneNo,
                                                          );
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                content: const Text(
                                                                    'Do you sure you want to call this number?'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      launchUrl(
                                                                          telLaunchUri);
                                                                    },
                                                                    child: const Text(
                                                                        'Call'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: const Text(
                                                                        'Cancel'),
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.phone),
                                                      label: const Text('Call'),
                                                    ),
                                                    SizedBox(
                                                      width: 50.w,
                                                    ),
                                                    ElevatedButton.icon(
                                                      icon: const Icon(Icons
                                                          .navigation_rounded),
                                                      label: const Text(
                                                          'Navigate'),
                                                      onPressed: () {
                                                        _openDestination(
                                                            context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      icon: const Icon(
                                                          Icons.location_on),
                                                      label: const Text(
                                                          'Address Location'),
                                                      onPressed: () {
                                                        context.router
                                                            .push(MapScreen(
                                                          address: totalAdd,
                                                          studName: name,
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
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Ok'),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else if (details.appointments == null ||
                                    details.appointments!.isEmpty) {
                                  EasyLoading.dismiss();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Blank Event'),
                                        content: const Text(
                                            'No event is set at this time yet.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
