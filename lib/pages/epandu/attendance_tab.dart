import 'package:auto_route/auto_route.dart';

import '/common_library/services/repository/epandu_repository.dart';
import '/pages/epandu/epandu.dart';
import '/utils/constants.dart';
import '/common_library/utils/custom_dialog.dart';
import '/common_library/utils/local_storage.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  AttendanceTabState createState() => AttendanceTabState();
}

class AttendanceTabState extends State<AttendanceTab>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<AttendanceTab> {
  final List<Tab> myTabs = <Tab>[
    const Tab(
      text: 'Attendance',
    ),
    /* Tab(
      icon: new Icon(
        Icons.account_balance_wallet,
        size: 28.0,
      ),
    ), */
    const Tab(
      text: 'Check In',
    ),
  ];
  TabController? _tabController;
  int _tabIndex = 0;
  final epanduRepo = EpanduRepo();
  final localStorage = LocalStorage();
  final primaryColor = ColorConstant.primaryColor;
  final customDialog = CustomDialog();

  final RegExp removeBracket =
      RegExp("\\[(.*?)\\]", multiLine: true, caseSensitive: true);

  dynamic attendanceData;
  dynamic checkInData;

  String enrollmentMessage = '';
  String paymentMessage = '';
  String attendanceMessage = '';

  dynamic enrollData;
  bool stuPracIsLoading = false;
  bool checkInLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController!.addListener(_getTabSelection);

    Future.wait([
      _getStuPracByCode(),
      _getJpjTestCheckIn(),
    ]);
  }

  Future<void> _getStuPracByCode() async {
    setState(() {
      stuPracIsLoading = true;
    });

    var response = await epanduRepo.getStuPracByCode(context: context);

    if (response.isSuccess) {
      setState(() {
        attendanceData = response.data;
      });
    }

    setState(() {
      stuPracIsLoading = false;
    });
  }

  Future<void> _getJpjTestCheckIn() async {
    setState(() {
      checkInLoading = true;
    });

    var result = await epanduRepo.getJpjTestCheckIn();

    if (result.isSuccess) {
      checkInData = result.data;
    }

    setState(() {
      checkInLoading = false;
    });
  }

  _getTabSelection() {
    setState(() {
      _tabIndex = _tabController!.index;
    });
  }

  _getTitle() {
    switch (_tabIndex) {
      case 0:
        return const Text('Attendance');
      // case 1:
      //   return Text(AppLocalizations.of(context).translate('edompet_title'));
      case 1:
        return const Text('Check In');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
            title: _getTitle(),
          ),
          backgroundColor: Colors.transparent,
          body: TabBarView(controller: _tabController, children: [
            AttendanceRecord(
              attendanceData: attendanceData,
              isLoading: stuPracIsLoading,
            ),
            // Edompet(),
            CheckInRecord(
              checkInData: checkInData,
              isLoading: checkInLoading,
            ),
          ]),
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
    _tabController!.dispose();
    super.dispose();
  }
}
