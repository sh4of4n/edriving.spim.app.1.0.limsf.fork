import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

@RoutePage()
class HistoryClass extends StatefulWidget {
  final historyClassInfo;
  final message;
  const HistoryClass({
    super.key,
    required this.historyClassInfo,
    required this.message
  });

  @override
  State<HistoryClass> createState() => _HistoryClassState();
}

class _HistoryClassState extends State<HistoryClass> {
  final myImage = ImagesConstant();
  List<dynamic> history = [];

  profileImage(){
    return Image(
        width: 200.w,
        height: 200.w,
        image: AssetImage(
          myImage.dummyProfile,
        ),
      );
  }

  String convertDateFormat(String dateString) {
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
    DateTime dateTime = format.parse(dateString);
    String formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);

    return formattedDate;
  }

  String formatDuration(String durationString) {
    // Parse the duration string into a Duration object
    Duration duration = Duration(
      hours: int.parse(durationString.split(':')[0]),
      minutes: int.parse(durationString.split(':')[1]),
      seconds: int.parse(durationString.split(':')[2]),
    );

    // Extract individual components
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    // Build the formatted string
    String formattedDuration = '';
    if (hours > 0) {
      formattedDuration += '$hours ${hours == 1 ? 'hour' : 'hours'} ';
    }
    if (minutes > 0) {
      formattedDuration += '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ';
    }
    if (seconds > 0 || formattedDuration.isEmpty) {
      formattedDuration += '$seconds ${seconds == 1 ? 'second' : 'seconds'}';
    }

    return formattedDuration.trim();
  }

  String convertTimeToAMPM(String timeString) {
    try {
      // Parse the time string to a DateTime object
      DateTime dateTime = DateTime.parse('2022-01-01 $timeString');

      // Format the DateTime object to display only the time in AM/PM format
      String formattedTime = DateFormat('h:mm a').format(dateTime);

      return formattedTime;
    } catch (e) {
      // Handle any parsing errors
      print('Error parsing time: $e');
      return 'Invalid Time';
    }
  }
  
  @override
  void initState(){
    super.initState();
    history = widget.historyClassInfo;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var item in history)
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
                          visualDensity:
                            const VisualDensity(vertical: -2),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        ListTile(
                          title: Text('Trainer Code: ${item.trnCode}'),
                          visualDensity:
                            const VisualDensity(vertical: -2),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        ListTile(
                          title: Text('Trainer IC: ${item.icNo}'),
                          visualDensity:
                            const VisualDensity(vertical: -2),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        ListTile(
                          title: Text('Class Date: ${convertDateFormat(item.trandate)}'),
                          visualDensity:
                            const VisualDensity(vertical: -2),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        ListTile(
                          title: Text('Time: ${convertTimeToAMPM(item.actBgTime)} -> ${convertTimeToAMPM(item.actEndTime)}'),
                          subtitle: Text('Total Time: ${formatDuration(item.totalTime)}', style: const TextStyle(fontSize: 14),),
                          visualDensity:
                            const VisualDensity(vertical: -2),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        ListTile(
                          title: Text('Course Code: ${item.courseCode}'),
                          visualDensity:
                            const VisualDensity(vertical: -2),
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
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(600)),
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