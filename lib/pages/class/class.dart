import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/services/repository/class_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/instructor_repository.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:edriving_spim_app/pages/class/today_class.dart' as todaypage;
import 'package:edriving_spim_app/pages/class/history_class.dart' as historypage;
import 'package:edriving_spim_app/pages/class/progress_class.dart' as progresspage;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

@RoutePage()
class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  TabController? _tabController;
  final primaryColor = ColorConstant.primaryColor;
  final trainerRepo = InstructorRepo();
  final classRepo = ClassRepo();
  List<dynamic> history = [];
  List<dynamic> progress = [];
  List<dynamic> today = [];
  String trnCode = '';
  String _message = '';
  String trnName = '';
  String icNo = '';
  String groupId = '';
  String todayMessage = '';
  String historyMessage = '';
  String progressMessage = '';
  String progressHaving = '';
  final int _startIndex = 0;
  final int _noOfRecord = 50;
  bool _isLoading = true;
  bool _lazyload = true;
  final List<Tab> myTabs = <Tab>[
    const Tab(
      child: Text('Today', style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),),
    ),
    const Tab(
      child: Text('Progress', style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),),
    ),
    const Tab(
      child: Text('History', style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),),
    ),
  ];

  getTrainerInfo() async {
    setState(() {
      _lazyload = true;
    });
    var result = await trainerRepo.getTrainerInfo(context: context);

    if (result.isSuccess) {
      for (var i = 0; i < result.data.length; i++) {
        if (result.data[i].trnCode != null) {
          setState(() {
            trnCode = result.data[i].trnCode;
            trnName = result.data[i].trnName;
            icNo = result.data[i].nric;
            groupId = result.data[i].spimGroupId/* .substring(0, result.data[i].spimGroupId.length - 1) */;
          });
        }
      }
      await getTodayClass(trnCode);
      await getCompleteClass(trnCode);
      await getProgressClass(trnCode);
      setState(() {
        _lazyload = false;
        _isLoading = false;
      });
      return result.data;
    } else {
      setState(() {
        _lazyload = false;
        _isLoading = true;
        if (result.message == null) {
          _message = 'Trainer not registered';
        } else {
          _message = result.message!;
        }
      });

      return _message;
    }
  }

  getTodayClass(String trnCode) async {
    var result = await classRepo.getTodayClass(
        context: context,
        groupId: '',
        trnCode: trnCode,
        icNo: '',
        startIndex: _startIndex,
        noOfRecords: _noOfRecord);

    if (result.isSuccess) {
      for (var i = 0; i < result.data.length; i++) {
        setState(() {
          today.add(result.data[i]);
        });
      }
      return result.data;
    } else {
      setState(() {
        if (result.message == null) {
          todayMessage = 'No class today';
        } else {
          todayMessage = result.message!;
        }
      });
    }
    return todayMessage;
  }

  getProgressClass(String trnCode) async {
    var result = await classRepo.getProgressClass(
        context: context,
        groupId: '',
        trnCode: trnCode,
        icNo: '',
        startIndex: _startIndex,
        noOfRecords: _noOfRecord,
        keywordSearch: '');

    if (result.isSuccess) {
      for (var i = 0; i < result.data.length; i++) {
        setState(() {
          progress.add(result.data[i]);
          progressHaving = 'Yes';
          progressMessage = '';
        });
      }
      return result.data;
    } else {
      setState(() {
        if (result.message == null) {
          progressMessage = 'No progress class';
          progressHaving = 'No';
        } else {
          progressMessage = result.message!;
        }
      });
    }
    return progressMessage;
  }

  getCompleteClass(String trnCode) async {
    var result = await classRepo.getCompleteClass(
      context: context,
      groupId: '',
      trnCode: trnCode,
      icNo: '',
      startIndex: _startIndex,
      noOfRecords: _noOfRecord,
      keywordSearch: ''
    );

    if(result.isSuccess){
      for (var i = 0; i < result.data.length; i++) {
        setState(() {
          history.add(result.data[i]);
          historyMessage = '';
        });
      }
      return result.data;
    } else {
      setState(() {
        if (result.message == null) {
          historyMessage = 'No history class';
        } else {
          historyMessage = result.message!;
        }
      });
    }
    return historyMessage;
  }

  @override
  void initState(){
    super.initState();
    getTrainerInfo();
  }

  void refreshData(){
    today.clear();
    progress.clear();
    history.clear();
    getTrainerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                title: Text(AppLocalizations.of(context)!.translate('class_lbl')),
              ),
              backgroundColor: Colors.transparent,
              body: _lazyload ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(30)),
                      child: const Center(
                        child: SpinKitHourGlass(color: Colors.white),
                      ),
                    )
                : _isLoading ? Padding(
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
                    ) :
                TabBarView(
                controller: _tabController,
                children: <Widget>[
                  todaypage.TodayClass(
                    trnName: trnName,
                    trnCode: trnCode,
                    todayClassInfo: today,
                    message: todayMessage,
                    progressMsg: progressHaving,
                  ),
                  progresspage.ProgressClass(
                    progressClassInfo: progress,
                    message: progressMessage,
                  ),
                  historypage.HistoryClass(
                    historyClassInfo: history,
                    message: historyMessage,
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 10.0),
                      blurRadius: 15.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                child: TabBar(
                  controller: _tabController,
                  onTap: (index){
                    refreshData();
                  },
                  indicatorColor: Colors.transparent,
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.grey.shade700,
                  tabs: myTabs,
                ),
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Use the null-aware operator (?)
    super.dispose();
  }
}