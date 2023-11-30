import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/services/repository/auth_repository.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/pages/vehicle/multiselect.dart';
import 'package:edriving_spim_app/router.gr.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final primaryColor = ColorConstant.primaryColor;
  DateTime today = DateTime.now();
  final authRepo = AuthRepo();
  final groupIdController = TextEditingController();
  final courseCodeController = TextEditingController();
  final groupIdFocus = FocusNode();
  final courseCodeFocus = FocusNode();
  List<String> groupId = [];
  List<String> groupDesc = [];
  List<String> courseCode = [];
  List<String> selectedGroup = [];
  List<String> selectedCode = [];
  String groupIdTxt = '';
  int year = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;

  getGroupId() async {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var result = await authRepo.getGroupId(context: context);

    if (result.isSuccess) {
      EasyLoading.dismiss();
      setState(() {
        groupId.clear();

        for (var i = 0; i < result.data.length; i++) {
          if (result.data[i] != null && result.data[i].groupId != null) {
            groupId.add(
                result.data[i].groupId.toString()); // Adjust the type if needed
            groupDesc.add(result.data[i].grpDesc.toString());
          }
        }
      });
      return result.data;
    }

    return result.message;
  }

  getCourseCode() async {
    var result = await authRepo.getCourseCode(context: context, courseCode: '');

    if (result.isSuccess) {
      EasyLoading.dismiss();
      setState(() {
        courseCode.clear();
        for (var i = 0; i < result.data.length; i++) {
          if (result.data[i] != null && result.data[i].courseCode != null) {
            courseCode.add(result.data[i].courseCode);
          }
        }
      });
      return result.data;
    }
    return result.message;
  }

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(
            title: "Select Group Id",
            groupID: groupId,
            initialSelectedGroup: selectedGroup,
          );
        });

    if (results != null) {
      setState(() {
        selectedGroup.clear();
        selectedGroup.addAll(results);
        // groupIdTxt = selectedGroup.join(";");
        groupIdController.text = selectedGroup.join(";");
      });
    }
  }

  void _showCourseCode() async {
    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(
            title: "Select Course Code",
            groupID: courseCode,
            initialSelectedGroup: selectedCode,
          );
        });

    if (results != null) {
      setState(() {
        selectedCode.clear();
        selectedCode.addAll(results);
        // groupIdTxt = selectedGroup.join(";");
        courseCodeController.text = selectedCode.join(";");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getGroupId();
    getCourseCode();

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
                Text(AppLocalizations.of(context)!.translate('add_class_lbl')),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "$day-$month-$year",
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Current Time:$hour:$minute",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 100.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  textInputAction: TextInputAction.next,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3, color: Colors.red)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: Colors.blue)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.black)),
                                    contentPadding: const EdgeInsets.all(5.0),
                                    hintStyle: TextStyle(
                                      color: primaryColor,
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    labelText: ' Please select group id',
                                  ),
                                  onTap: () {
                                    _showMultiSelect();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  controller: courseCodeController,
                                  focusNode: courseCodeFocus,
                                  textInputAction: TextInputAction.next,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3, color: Colors.red)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: Colors.blue)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.black)),
                                    contentPadding: const EdgeInsets.all(5.0),
                                    hintStyle: TextStyle(
                                      color: primaryColor,
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    labelText: ' Please select course code',
                                  ),
                                  onTap: () {
                                    _showCourseCode();
                                  },
                                ),
                              )
                            ],
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  context.router.push(const MyKad());
                                },
                                child: const Text('My Kad'),
                              ),
                              SizedBox(
                                width: 100.w,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.router.push(const MiFare());
                                },
                                child: const Text('MiFare'),
                              ),
                            ],
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
            ),
          ),
        ),
      ),
    );
  }
}
