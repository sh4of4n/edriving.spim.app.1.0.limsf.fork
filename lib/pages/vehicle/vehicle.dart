import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/services/model/vehicle_model.dart';
import 'package:edriving_spim_app/common_library/services/repository/instructor_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/vehicle_repository.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/pages/vehicle/multiselect.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:supercharged/supercharged.dart';

@RoutePage()
class Vehicle extends StatefulWidget {
  const Vehicle({super.key});

  @override
  State<Vehicle> createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  final primaryColor = ColorConstant.primaryColor;
  final vehicleRepo = VehicleRepo();
  final trainerRepo = InstructorRepo();
  final searchController = TextEditingController();
  final searchFocus = FocusNode();
  List<dynamic> items = [];
  bool _lazyload = true;
  int _startIndex = 0;
  final int _noOfRecord = 10;
  bool isLessThanOneMonth = false;
  bool rtisLessThanOneMonth = false;
  bool isExpired = false;
  bool rtisExpired = false;
  TextStyle dateStyle = const TextStyle(fontSize: 14);
  String expiredText = '';
  String vehNo = '';
  String make = '';
  String search = '';
  String model = '';
  String groupId = '';
  String trnCode = '';
  String _message = '';
  String trnName = '';
  String dateWithoutOffset = 'Expiry Date not set';
  String puspakomWithoutOffset = 'Expiry Date not set';
  DateTime today = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  List<String> selectedGroup = [];
  String selectedText = '';
  final RegExp removeBracket =
      RegExp("\\[(.*?)\\]", multiLine: true, caseSensitive: true);
  final List<String> groupID = [
    "D",
    "DA",
    "B",
    "B2",
    "E",
    "E1",
    "E2",
    "ALL",
  ];

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

  void refreshData() {
    setState(() {
      items.clear();
      _startIndex = 0;
      _lazyload = true;
      getTrainerInfo();
    });
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
      getVehicle(trnCode);
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

  getVehicle(String trnCode) async {
    var result = await vehicleRepo.getVehicleList(
        context: context,
        groupId: selectedText,
        trnCode: trnCode,
        startIndex: _startIndex,
        noOfRecords: _noOfRecord,
        keywordSearch: search);

    if (result.isSuccess) {
      List<VehicleList> vehicleListCopy = List.from(result.data);
      for (var i = 0; i < result.data.length; i++) {
        setState(() {
          items.add(result.data[i]);
        });
        //sorting date
        // vehicleListCopy.sort((a, b) {
        //   final aDate = DateTime.tryParse(a.sm3ExpDt ?? '');
        //   final bDate = DateTime.tryParse(b.sm3ExpDt ?? '');

        //   if (aDate == null && bDate == null) {
        //     return 0;
        //   } else if (aDate == null) {
        //     return 1;
        //   } else if (bDate == null) {
        //     return -1;
        //   }
        //   return aDate.compareTo(bDate);
        // });

      }
      setState(() {
        _lazyload = false;
      });
      return vehicleListCopy;
    }
    setState(() {
      _lazyload = false;
      if (result.message == null) {
        _message = 'No vehicle found';
      } else {
        _message = result.message!;
      }
    });

    return _message;
  }

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          title: "Select Group Id",
          groupID: groupID, 
          initialSelectedGroup: selectedGroup);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        // Clear the existing selection
        selectedGroup.clear();
        selectedGroup.addAll(results); // Update with new selection
        if (selectedGroup.contains("ALL") ||
            selectedGroup.contains("D;DA") &&
                selectedGroup.contains("B;B2") &&
                selectedGroup.contains("E;E1;E2")) {
          selectedText = "";
          refreshData();
        } else {
          selectedText = selectedGroup.join(", ");
          refreshData();
        }
      });
    }
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
            title: Text(AppLocalizations.of(context)!.translate('vehicle_lbl')),
          ),
          backgroundColor: Colors.transparent,
          //TO DO
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                          onPressed: _showMultiSelect,
                          child: const Text('Filter'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  for (var item in items)
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    item.vehNo ?? 'Vehicle not found',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: -2),
                                ),
                                ListTile(
                                  title: Text(
                                    'Vehicle: ${item.make ?? ' -'}',
                                    textAlign: TextAlign.left,
                                  ),
                                  subtitle: Text(item.model ?? ''),
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                ),
                                ListTile(
                                  title: Text(
                                    'Vehicle Class: ${item.groupId ?? ' -'}',
                                    textAlign: TextAlign.left,
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                ),
                                ListTile(
                                  title: Text(
                                    'Road Tax Expiry Date: ${parseDateAndCheck(item.rtExpDt ?? '')}$expiredText',
                                    textAlign: TextAlign.left,
                                    style: dateStyle,
                                  ),
                                  subtitle: Text(
                                    'PUSPAKOM Expiry Date: ${parseDateAndCheck(item.sm3ExpDt ?? '')}$expiredText',
                                    style: dateStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                  // visualDensity: const VisualDensity(vertical: -4),
                                ),
                                ListTile(
                                          title: Text('Next Service Date: ${parseDateAndCheck(item.nextInspectDt ?? '')}',
                                            textAlign: TextAlign.left,
                                            style: dateStyle,
                                          ),
                                        ),
                                ListTile(
                                  title: Text(
                                    'Trainer Name:  $trnName',
                                    textAlign: TextAlign.left,
                                  ),
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
                      : trnCode.isEmpty || items.isEmpty
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
