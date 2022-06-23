// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

// import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import '/common_library/services/repository/inbox_repository.dart';
import '/common_library/utils/custom_dialog.dart';
import '/router.gr.dart';
import '/common_library/services/model/provider_model.dart';
// import '/common_library/services/location.dart';
import '/common_library/services/repository/auth_repository.dart';
import '/common_library/services/repository/kpp_repository.dart';
import '/services/provider/notification_count.dart';
import '/utils/app_config.dart';
import '/utils/constants.dart';
import '/common_library/utils/local_storage.dart';
import '/common_library/utils/loading_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

// import '/common_library/utils/app_localizations.dart';
import 'bottom_menu.dart';
import 'feeds.dart';
import 'home_page_header.dart';
import 'home_top_menu.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final authRepo = AuthRepo();
  final kppRepo = KppRepo();
  final inboxRepo = InboxRepo();
  final customDialog = CustomDialog();
  final localStorage = LocalStorage();
  final primaryColor = ColorConstant.primaryColor;
  // String _username = '';
  dynamic studentEnrollmentData;
  // var feed;
  final myImage = ImagesConstant();
  // get location
  // Location location = Location();
  // StreamSubscription<Position> positionStream;

  String? instituteLogo = '';
  bool isLogoLoaded = false;
  String appVersion = '';
  // String latitude = '';
  // String longitude = '';

  final _iconText = TextStyle(
    fontSize: ScreenUtil().setSp(55),
    fontWeight: FontWeight.w500,
  );

  String? _message = '';
  bool _loadMore = false;
  bool _isLoading = false;
  int _startIndex = 0;
  List<dynamic> items = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _openHiveBoxes();
    // getStudentInfo();
    // _getCurrentLocation();
    // _checkLocationPermission();
    _getDiProfile();
    _getActiveFeed();
    _getAppVersion();
    getUnreadNotificationCount();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _startIndex += 10;
        });

        if (_message!.isEmpty) {
          setState(() {
            _loadMore = true;
          });

          _getActiveFeed();
        }
      }
    });
  }

  getUnreadNotificationCount() async {
    var result = await inboxRepo.getUnreadNotificationCount();

    if (mounted) {
      if (result.isSuccess) {
        if (int.tryParse(result.data[0].msgCount)! > 0) {
          Provider.of<NotificationCount>(context, listen: false).setShowBadge(
            showBadge: true,
          );

          Provider.of<NotificationCount>(context, listen: false)
              .updateNotificationBadge(
            notificationBadge: int.tryParse(result.data[0].msgCount),
          );
        } else {
          Provider.of<NotificationCount>(context, listen: false).setShowBadge(
            showBadge: false,
          );
        }
      } else {
        Provider.of<NotificationCount>(context, listen: false).setShowBadge(
          showBadge: false,
        );
      }
    }
  }

  _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  void dispose() {
    // positionStream.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getDiProfile() async {
    // String instituteLogoPath = await localStorage.getInstituteLogo();

    var result = await authRepo.getDiProfile(context: context);

    if (result.isSuccess && result.data != null) {
      // Uint8List decodedImage = base64Decode(
      //     result.data);
      if (mounted) {
        setState(() {
          instituteLogo = result.data;
          isLogoLoaded = true;
        });
      }
    }

    /* if (instituteLogoPath.isEmpty) {
      var result = await authRepo.getDiProfile(context: context);

      if (result.isSuccess && result.data != null) {
        // Uint8List decodedImage = base64Decode(
        //     result.data);

        setState(() {
          instituteLogo = result.data;
          isLogoLoaded = true;
        });
      }
    } else {
      // Uint8List decodedImage = base64Decode(instituteLogoPath);

      setState(() {
        instituteLogo = instituteLogoPath;
        isLogoLoaded = true;
      });
    } */
  }

  Future<void> _getActiveFeed() async {
    setState(() {
      _isLoading = true;
    });

    var result = await authRepo.getActiveFeed(
      context: context,
      feedType: 'MAIN',
      startIndex: _startIndex,
      noOfRecords: 10,
    );

    /* if (result.isSuccess) {
      setState(() {
        feed = result.data;
      });
    } */

    if (result.isSuccess) {
      if (result.data.length > 0 && mounted) {
        setState(() {
          for (int i = 0; i < result.data.length; i += 1) {
            items.add(result.data[i]);
          }
        });
      } else if (mounted) {
        setState(() {
          _loadMore = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _message = result.message;
          _loadMore = false;
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  /* _checkLocationPermission() async {
    // contactBox = Hive.box('emergencyContact');

    // await location.getCurrentLocation();

    bool serviceLocationStatus = await Geolocator().isLocationServiceEnabled();

    // GeolocationStatus geolocationStatus =
    //     await Geolocator().checkGeolocationPermissionStatus();

    if (serviceLocationStatus) {
      _getCurrentLocation();
    } else {
      customDialog.show(
        context: context,
        barrierDismissable: false,
        title: Text(
            AppLocalizations.of(context).translate('loc_permission_title')),
        content: AppLocalizations.of(context).translate('loc_permission_desc'),
        customActions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context).translate('yes_lbl')),
            onPressed: () {
              context.router.pop();
              context.router.pop();
              AppSettings.openLocationSettings();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context).translate('no_lbl')),
            onPressed: () {
              context.router.pop();
              context.router.pop();
            },
          ),
        ],
        type: DialogType.GENERAL,
      );
    }
  }

  _getCurrentLocation() async {
    await location.getCurrentLocation();

    localStorage.saveUserLatitude(location.latitude.toString());
    localStorage.saveUserLongitude(location.longitude.toString());

    setState(() {
      latitude = location.latitude.toString();
      longitude = location.longitude.toString();
    });
  } */

  // remember to add positionStream.cancel()
  /* Future<void> _userTracking() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();

    // print(geolocationStatus);

    if (geolocationStatus == GeolocationStatus.granted) {
      positionStream = geolocator
          .getPositionStream(locationOptions)
          .listen((Position position) async {
        localStorage.saveUserLatitude(position.latitude.toString());
        localStorage.saveUserLongitude(position.longitude.toString());

        setState(() {
          latitude = location.latitude.toString();
          longitude = location.longitude.toString();
        });
      });
    }
  } */

  _openHiveBoxes() async {
    await Hive.openBox('telcoList');
    await Hive.openBox('serviceList');
    await Hive.openBox('inboxStorage');
    // await Hive.openBox('emergencyContact');
  }

  shimmer() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
      child: Column(
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            child: Container(
              width: ScreenUtil().setWidth(1300),
              height: ScreenUtil().setHeight(750),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    var result = await authRepo.validateAppVersion(appVersion: appVersion);

    if (result.isSuccess) {
      if (int.tryParse(appVersion.split('.')[0])! <
              int.tryParse(result.data[0].appMinVersion.split('.')[0])! ||
          int.tryParse(appVersion.split('.')[1])! <
              int.tryParse(result.data[0].appMinVersion.split('.')[1])! ||
          int.tryParse(appVersion.split('.')[2])! <
              int.tryParse(result.data[0].appMinVersion.split('.')[2])!) {
        customDialog.show(
          context: context,
          content: 'App version is outdated and must be updated.',
          barrierDismissable: false,
          customActions: [
            TextButton(
              onPressed: () async {
                if (Platform.isIOS) {
                  await launchUrl(Uri.parse(
                      'https:// ${result.data[0].newVerApplestoreUrl}'));
                } else {
                  await launchUrl(
                      Uri.parse(result.data[0].newVerGooglestoreUrl));
                }
              },
              child: const Text('Ok'),
            ),
          ],
          type: DialogType.general,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            primaryColor,
          ],
          stops: const [0.45, 0.65],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: EdgeInsets.only(top: 120.h),
          height: 350.h,
          width: 450.w,
          child: FloatingActionButton(
            onPressed: () {
              context.router.push(const EmergencyDirectory());
            },
            backgroundColor: Colors.transparent,
            child: Image.asset(
              myImage.sos,
              // width: ScreenUtil().setWidth(300),
            ),
          ),
        ),
        bottomNavigationBar: BottomMenu(
          iconText: _iconText,
          // positionStream: positionStream,
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () async {
                  String? caUid = await localStorage.getCaUid();
                  String? caPwd = await localStorage.getCaPwd();

                  await authRepo.getWsUrl(
                    context: context,
                    acctUid: caUid,
                    acctPwd: caPwd,
                    loginType: AppConfig().wsCodeCrypt,
                  );

                  await _validateAppVersion();

                  setState(() {
                    _startIndex = 0;
                    items.clear();
                    _message = '';
                  });

                  _getDiProfile();
                  _getActiveFeed();
                  _getAppVersion();
                  getUnreadNotificationCount();
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(60)),
                        child: HomePageHeader(
                          instituteLogo: instituteLogo,
                          // positionStream: positionStream,
                        ),
                      ),
                      HomeTopMenu(
                        iconText: _iconText,
                        getDiProfile: () => _getDiProfile(),
                        getActiveFeed: () => _getActiveFeed(),
                      ),
                      LimitedBox(maxHeight: ScreenUtil().setHeight(30)),
                      Feeds(
                        feed: items,
                        isLoading: _isLoading,
                        appVersion: appVersion,
                      ),
                      if (_loadMore) shimmer(),
                    ],
                  ),
                ),
              ),
              Consumer<HomeLoadingModel>(
                builder: (BuildContext context, loadingModel, child) {
                  return LoadingModel(
                    isVisible: loadingModel.isLoading,
                    color: primaryColor,
                  );
                },
              ),
              /* LoadingModel(
                isVisible:
                    Provider.of<FeedsLoadingModel>(context, listen: false)
                        .isLoading,
                color: primaryColor,
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
