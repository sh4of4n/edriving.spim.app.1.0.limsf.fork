import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/services/repository/vehicle_repository.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/pages/vehicle/multiselect.dart';
import 'package:edriving_spim_app/router.gr.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

@RoutePage()
class MiFare extends StatefulWidget {
  final groupId;
  const MiFare({super.key, required this.groupId});

  @override
  State<MiFare> createState() => _MiFareState();
}

class _MiFareState extends State<MiFare> {
  final primaryColor = ColorConstant.primaryColor;
  final vehicleRepo = VehicleRepo();
  final formKey = GlobalKey<FormState>();
  final vehicleController = TextEditingController();
  final vehicleFocus = FocusNode();
  final myImage = ImagesConstant();
  final credentials = Hive.box('credentials');
  int _startIndex = 0;
  String message = "";
  bool haveData = true;
  final int _noOfRecord = 10;
  List<String> vehicles = [];
  List<String> selectedGroup = [];

  getVehicleList() async {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var result = await vehicleRepo.getVehicleList(
        context: context,
        groupId: widget.groupId,
        trnCode: credentials.get('trncode'),
        startIndex: _startIndex,
        noOfRecords: _noOfRecord,
        keywordSearch: '');

    if (result.isSuccess) {
      EasyLoading.dismiss();
      setState(() {
        vehicles.clear();
        for (var i = 0; i < result.data.length; i++) {
          if (result.data[i] != null && result.data[i].vehNo != null) {
            vehicles.add(result.data[i].vehNo.toString());
          }
        }
      });
      return result.data;
    }
    EasyLoading.dismiss();
    setState(() {
      haveData = true;
      message = "No Vehicle Found";
    });
    return result.message;
  }

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(
            title: "Select Group Id",
            groupID: vehicles,
            initialSelectedGroup: selectedGroup,
          );
        });

    if (results != null) {
      setState(() {
        selectedGroup.clear();
        selectedGroup.addAll(results);
        // groupIdTxt = selectedGroup.join(";");
        vehicleController.text = selectedGroup.join(";");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getVehicleList();
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
                  Text(AppLocalizations.of(context)!.translate('miFare_lbl')),
            ),
            backgroundColor: Colors.transparent,
            body: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(600)),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                             Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                                child: InkWell(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              myImage.mifareimg,
                                              height: 150,
                                            ),
                                            SizedBox(
                                              height: 150.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Vehicle: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50.w,
                                                ),
                                                haveData?
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
                                                              borderSide: BorderSide(
                                                                  width: 3,
                                                                  color: Colors
                                                                      .blue)),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black)),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      hintStyle: TextStyle(
                                                        color: primaryColor,
                                                      ),
                                                      labelStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      labelText: message,
                                                    ),
                                                  ),
                                                )
                                                : Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 15),
                                                    controller:
                                                        vehicleController,
                                                    focusNode: vehicleFocus,
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
                                                              borderSide: BorderSide(
                                                                  width: 3,
                                                                  color: Colors
                                                                      .blue)),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black)),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      hintStyle: TextStyle(
                                                        color: primaryColor,
                                                      ),
                                                      labelStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      labelText:
                                                          ' Please select vehicle',
                                                    ),
                                                    onTap: () {
                                                      _showMultiSelect();
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please select group id';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 150.h,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    context.router.push(
                                                        AddClass(
                                                            myKadDetails: ''));
                                                  });
                                                },
                                                child: const Text('Proceed')
                                            ),
                                            SizedBox(
                                              height: 100.h,
                                            ),
                                          ],
                                        ),
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
          ),
        ));
  }
}
