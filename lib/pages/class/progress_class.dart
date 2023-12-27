import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ProgressClass extends StatefulWidget {
  final progressClassInfo;
  final message;
  const ProgressClass(
      {super.key, required this.progressClassInfo, required this.message});

  @override
  State<ProgressClass> createState() => _ProgressClassState();
}

class _ProgressClassState extends State<ProgressClass> {
  final myImage = ImagesConstant();
  List<dynamic> progress = [];

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

  String convertTimeToAMPM(String timeString) {
    try {
      // Format the time string to display only the time in AM/PM format
      String formattedTime = DateFormat('h:mm a').format(DateFormat('HH:mm:ss').parse(timeString));

      return formattedTime;
    } catch (e) {
      // Handle any parsing errors
      print('Error parsing time: $e');
      return 'Not Thumb In Yet';
    }
  }

  profileImage() {
    return Image(
      width: 200.w,
      height: 200.w,
      image: AssetImage(
        myImage.dummyProfile,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    progress = widget.progressClassInfo;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var item in progress)
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('${item.classes}'),
                            leading: profileImage(),
                            visualDensity: const VisualDensity(vertical: -2),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          ListTile(
                            title: Text('Trainer Code: ${item.trnCode}'),
                            visualDensity: const VisualDensity(vertical: -2),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          ListTile(
                            title: Text('Student IC: ${item.icNo}'),
                            visualDensity: const VisualDensity(vertical: -2),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          ListTile(
                            title: Text(
                                'Class Date: ${convertDateFormat(item.trandate)}'),
                            visualDensity: const VisualDensity(vertical: -2),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          ListTile(
                            title: Text(
                                'Time: ${convertTimeToAMPM(item.actBgTime)} -> ${convertTimeToAMPM(item.actEndTime)}'),
                            subtitle: Text('Total Time: ${item.totalTime}', style: const TextStyle(fontSize: 14),),
                            visualDensity: const VisualDensity(vertical: -2),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          ListTile(
                            title: Text('Course Code: ${item.courseCode}'),
                            visualDensity: const VisualDensity(vertical: -2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            // Padding(
            //     padding:
            //         EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(600)),
            //     child: const Center(
            //       child: Text(
            //         'No history class',
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            if (widget.message.isNotEmpty)
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(600)),
                child: Center(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
