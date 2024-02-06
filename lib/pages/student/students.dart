import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:edriving_spim_app/common_library/services/repository/class_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/instructor_repository.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:info_widget/info_widget.dart';
import 'package:intl/intl.dart';
import 'package:supercharged/supercharged.dart';

@RoutePage()
class Students extends StatefulWidget {
  const Students({super.key});

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final primaryColor = ColorConstant.primaryColor;
  final classRepo = ClassRepo();
  final trainerRepo = InstructorRepo();
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();
  final searchFocus = FocusNode();
  final myImage = ImagesConstant();
  String search = '';
  String trnCode = '';
  String _message = '';
  String trnName = '';
  String expiredText = '';
  String icNo = '';
  String profilePicBase64 = '';
  String startDate = '';
  String endDate = '';
  TextStyle dateStyle = const TextStyle(fontSize: 14);
  DateTime today = DateTime.now();
  int _startIndex = 0;
  bool _lazyload = true;
  List<dynamic> students = [];
  String studName = '';
  final int _noOfRecord = 5;
  final RegExp removeBracket =
      RegExp("\\[(.*?)\\]", multiLine: true, caseSensitive: true);
  DateTimeRange? _selectedDateRange;

  void refreshData() {
    setState(() {
      students.clear();
      _startIndex = 0;
      _lazyload = true;
      getTrainerInfo();
    });
  }

  String convertTo12HourFormat(String timeString) {
    if (timeString != '') {
      // Parse the input time string
      DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);

      // Check if it's after 12:00 PM
      bool isAfterNoon = dateTime.hour >= 12;

      // Format the time as hh:mm a (12-hour format with AM/PM)
      String formattedTime = DateFormat('hh:mm a').format(dateTime);

      // Add a condition to show PM for times after 12:00 PM
      if (isAfterNoon) {
        formattedTime = formattedTime.replaceFirst(
            RegExp('^0+'), ''); // Remove leading zeros
        formattedTime = formattedTime.replaceAll('AM', 'PM');
      }

      return formattedTime;
    } else {
      return 'Not thumb yet';
    }
  }

  String processPhotoFileName(String photoFileName) {
    // Split by '\r\n' and take the first part after removing brackets
    return photoFileName.replaceAll(removeBracket, '').split('\r\n')[0];
  }

  String parseDateAndCheck(String dateString) {
    if (dateString != '' || dateString.isNotEmpty) {
      DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
      DateTime dateTime = format.parse(dateString);
      String formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);

      final oneMonthFromToday = today.add(const Duration(days: 30));

      if (formattedDate.isEmpty || dateTime.isBefore(today)) {
        expiredText = ' (Expired)';
        dateStyle = const TextStyle(fontSize: 14, color: Colors.red);
        return formattedDate;
      } else if (dateTime.isBetween(today, oneMonthFromToday)) {
        expiredText = ' (Within One Month)';
        dateStyle = const TextStyle(fontSize: 14, color: Colors.red);
        return formattedDate;
      } else {
        expiredText = '';
        dateStyle = const TextStyle(fontSize: 14);
        return formattedDate;
      }
    } else {
      expiredText = '';
      dateStyle = const TextStyle(fontSize: 14);
    }
    return ' -';
  }

  getTrainerInfo() async {
    var result = await trainerRepo.getTrainerInfo(context: context);

    if (result.isSuccess) {
      for (var i = 0; i < result.data.length; i++) {
        if (result.data[i].trnCode != null) {
          setState(() {
            trnCode = result.data[i].trnCode;
            trnName = result.data[i].empno;
          });
        }
      }
      getStudentPrac(trnCode);
      return result.data;
    } else {
      setState(() {
        _lazyload = false;
        if (result.message == null) {
          _message = 'Trainer not registered';
        } else {
          _message = result.message!;
        }
      });

      return _message;
    }
  }

  getStudentPrac(String trnCode) async {
    var result = await classRepo.getStuPracByTrnCode(
        context: context,
        trnCode: trnCode,
        groupId: '',
        icNo: '',
        dateFromString: startDate,
        dateToString: endDate,
        startIndex: _startIndex,
        noOfRecords: _noOfRecord,
        keywordSearch: search);

    if (result.isSuccess) {
      for (var i = 0; i < result.data.length; i++) {
        setState(() {
          students.add(result.data[i]);
        });
      }
      setState(() {
        _lazyload = false;
      });
      return result.data;
    }
    setState(() {
      _lazyload = false;
      if (result.message == null) {
        _message = 'No students found';
      } else {
        _message = result.message!;
      }
    });
    return _message;
  }

  profileImage(String profilePicUrl) {
    if (profilePicBase64.isNotEmpty && profilePicUrl.isEmpty) {
      return InkWell(
        child: Image.memory(
          base64Decode(profilePicBase64),
          width: 200.w,
          height: 200.w,
          fit: BoxFit.cover,
          // gaplessPlayback: true,
        ),
      );
    } else if (profilePicUrl.isNotEmpty && profilePicBase64.isEmpty) {
      return InkWell(
        child: Image.network(
          profilePicUrl,
          width: 200.w,
          height: 200.w,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image(
        image: AssetImage(
          myImage.dummyProfile,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getTrainerInfo();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _startIndex += 10;
          getTrainerInfo();
          _lazyload = true;
        });
      }
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
            title: Text(AppLocalizations.of(context)!.translate('student_lbl')),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      startDate = '';
                      endDate = '';
                      search = '';
                      searchController.text = '';
                    });
                    refreshData();
                  },
                  icon: const Icon(Icons.refresh))
            ],
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      const Text(
                        "Searching criteria: ",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InfoWidget(
                        infoText:
                            "Class Code, Vehicle No, Student's IC, Group ID, Name, HandPhone, Course Code",
                        iconData: Icons.info,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          controller: searchController,
                          focusNode: searchFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            setState(() {
                              search = searchController.text;
                              refreshData();
                            });
                          },
                          decoration: InputDecoration(
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.white)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.white)),
                              contentPadding: const EdgeInsets.all(5.0),
                              hintStyle: TextStyle(
                                color: primaryColor,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              labelText: ' Search Here',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  setState(() {
                                    search = searchController.text;
                                    refreshData();
                                  });
                                },
                              ),
                              suffixIconColor: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Expanded(
                        flex: 1, // Adjust the flex value as needed
                        child: ElevatedButton(
                          onPressed: () async {
                            DateTimeRange? pickedRange =
                                await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );

                            if (pickedRange != null) {
                              setState(() {
                                _selectedDateRange = pickedRange;
                                startDate = DateFormat('yyyy-MM-dd')
                                    .format(_selectedDateRange!.start);
                                endDate = DateFormat('yyyy-MM-dd')
                                    .format(_selectedDateRange!.end);
                              });
                              refreshData();
                            }
                          },
                          child: const Text('Pick Date'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Text(
                      _selectedDateRange == null
                          ? 'No date range selected.'
                          : 'Date Rage Selected: $startDate - $endDate',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 50.h,
                  ),
                  for (var item in students)
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                // Column(
                                //   children: [
                                //     profileImage(
                                //           processPhotoFileName(
                                //               item.customerPhoto ??
                                //                   ''))
                                //   ],
                                // ),
                                ListTile(
                                  title: Text(
                                    item.name,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: profileImage(processPhotoFileName(
                                      item.customerphotoFilename ?? '')),
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                ),
                                ListTile(
                                  title: Text(
                                    'Ic Number: ${item.icNo}',
                                    textAlign: TextAlign.left,
                                  ),
                                  subtitle: Text(
                                    'Phone Number: ${item.handPhone}',
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.left,
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                ),
                                ListTile(
                                  title: Text(
                                    'Date: ${parseDateAndCheck(item.trandate)}',
                                    textAlign: TextAlign.left,
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                ),
                                ListTile(
                                  title: Text(
                                    'Vehicle Used: ${item.vehNo}',
                                    textAlign: TextAlign.left,
                                  ),
                                  subtitle: Text(
                                    'Course Code: ${item.courseCode}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                ),
                                ListTile(
                                  title: Text(
                                    'Class Time: ${convertTo12HourFormat(item.actBgTime)} -> ${convertTo12HourFormat(item.actEndTime)}',
                                    textAlign: TextAlign.left,
                                  ),
                                  subtitle: Text(
                                    'Class Code: ${item.classCode}',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  _lazyload
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(30)),
                          child: const Center(
                            child: SpinKitHourGlass(color: Colors.white),
                          ),
                        )
                      : students.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(600)),
                              child: Center(
                                child: Text(
                                  _message,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
