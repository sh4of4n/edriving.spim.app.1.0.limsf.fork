import 'dart:async';
import 'dart:io';

// import 'package:app_settings/app_settings.dart';
import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/services/repository/fpx_repository.dart';
import 'package:edriving_spim_app/common_library/services/repository/profile_repository.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:string_validator/string_validator.dart';
import '../../common_library/services/location.dart';
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

@RoutePage()
class Home extends StatefulWidget {
  final String? appVersion;
  const Home({super.key, this.appVersion});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final adText = TextStyle(
    fontSize: ScreenUtil().setSp(50),
    fontWeight: FontWeight.bold,
    color: const Color(0xff231f20),
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final authRepo = AuthRepo();
  final kppRepo = KppRepo();
  final inboxRepo = InboxRepo();
  final customDialog = CustomDialog();
  final localStorage = LocalStorage();
  final profileRepo = ProfileRepo();
  final fpxRepo = FpxRepo();
  final appConfig = AppConfig();
  final primaryColor = ColorConstant.primaryColor;
  // String _username = '';
  dynamic studentEnrollmentData;
  // var feed;
  final myImage = ImagesConstant();
  // get location
  Location location = Location();
  String latitude = '';
  String longitude = '';
  // StreamSubscription<Position> positionStream;

  String? instituteLogo = '';
  bool isLogoLoaded = false;
  bool isApproved = false;
  
  String appVersion = '';

  final _iconText = TextStyle(
    fontSize: ScreenUtil().setSp(55),
    fontWeight: FontWeight.w500,
  );

  String? _message = '';
  bool _isLoading = false;
  int _startIndex = 0;
  List<dynamic> items = [];
  final RegExp removeBracket =
      RegExp("\\[(.*?)\\]", multiLine: true, caseSensitive: true);

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
            _isLoading = true;
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
      if (result.data.length > 0) {
        setState(() {
          for (int i = 0; i < result.data.length; i += 1) {
            items.add(result.data[i]);
          }
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _message = result.message;
          _isLoading = false;
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
              AppSettings.openAppSettings();
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

  String _getPackageCode({udf}) {
    if (udf != null && udf.contains('package')) {
      int? startIndex = udf.indexOf('{');

      String? packages = udf.substring(startIndex);

      debugPrint(packages);

      return '&package=$packages';
    }
    return '';
  }

  loadUrl(feed, BuildContext context) async {
    if (Provider.of<CallStatusModel>(context, listen: false).status == false) {
      Provider.of<CallStatusModel>(context, listen: false).callStatus(true);

      var caUid = await localStorage.getCaUid();
      var caPwd = await localStorage.getCaPwd();
      if (!context.mounted) return;
      var result = await profileRepo.getUserProfile(context: context);

      if (mounted) {
        if (result.isSuccess) {
          String merchantNo = 'P1001';
          String? phone = result.data[0].phone;
          String? email = result.data[0].eMail;
          String icName = result.data[0].name;
          String? icNo = result.data[0].icNo;
          String? dob = result.data[0].birthDate;
          String? userId = await localStorage.getUserId();
          String? loginDeviceId = await localStorage.getLoginDeviceId();
          // String profilePic = result.data[0].picturePath != null &&
          //         result.data[0].picturePath.isNotEmpty
          //     ? result.data[0].picturePath
          //         .replaceAll(removeBracket, '')
          //         .split('\r\n')[0]
          //     : '';

          String? url = feed.feedNavigate +
              '?' +
              'appId=${appConfig.appId}' +
              '&appVersion=${widget.appVersion}' +
              '&userId=$userId' +
              '&deviceId=$loginDeviceId' +
              '&caUid=$caUid' +
              '&caPwd=${Uri.encodeQueryComponent(caPwd!)}' +
              _getMerchantNo(
                  udf: feed.udfReturnParameter, merchantNo: merchantNo) +
              _getIcName(
                  udf: feed.udfReturnParameter,
                  icName: Uri.encodeComponent(icName)) +
              _getIcNo(udf: feed.udfReturnParameter, icNo: icNo ?? '') +
              _getPhone(udf: feed.udfReturnParameter, phone: phone) +
              _getEmail(udf: feed.udfReturnParameter, email: email) +
              _getBirthDate(
                  udf: feed.udfReturnParameter, dob: dob?.substring(0, 10)) +
              _getLatitude(udf: feed.udfReturnParameter) +
              _getLongitude(udf: feed.udfReturnParameter) +
              _getPackageCode(udf: feed.udfReturnParameter);
          if (!context.mounted) return;
          context.router.push(
            Webview(url: url),
          );

          (BuildContext context) {
            Provider.of<HomeLoadingModel>(context, listen: false)
                .loadingStatus(false);
          };
          /* launch(url,
                              forceWebView: true, enableJavaScript: true); */
        } else {
          customDialog.show(
            context: context,
            barrierDismissable: false,
            content: result.message!,
            customActions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.translate('ok_btn')),
                onPressed: () {
                  context.router.pop();
                  Provider.of<HomeLoadingModel>(context, listen: false)
                      .loadingStatus(false);
                },
              ),
            ],
            type: DialogType.general,
          );
        }
      }
    }
  }
  
  String _getMerchantNo({udf, merchantNo}) {
    if (udf != null && udf.contains('merchant_no')) {
      return '&merchantNo=$merchantNo';
    }
    return '';
  }

  String _getIcName({udf, icName}) {
    if (udf != null && udf.contains('name')) {
      return '&icName=${Uri.encodeComponent(icName)}';
    }
    return '';
  }

  String _getIcNo({udf, icNo}) {
    if (udf != null && udf.contains('ic_no')) {
      return '&icNo=$icNo';
    }
    return '';
  }

  String _getPhone({udf, phone}) {
    if (udf != null && udf.contains('phone')) {
      return '&phone=$phone';
    }
    return '';
  }

  String _getEmail({udf, email}) {
    if (udf != null && udf.contains('e_mail')) {
      return '&email=${email ?? ''}';
    }
    return '';
  }

  String _getBirthDate({udf, dob}) {
    if (udf != null && udf.contains('birth_date')) {
      return '&dob=${dob?.substring(0, 10)}';
    }
    return '';
  }

  String _getLatitude({udf}) {
    if (udf != null && udf.contains('latitude')) {
      return '&latitude=$latitude';
    }
    return '';
  }

  String _getLongitude({udf}) {
    if (udf != null && udf.contains('longitude')) {
      return '&longitude=$longitude';
    }
    return '';
  }

  _getCurrentLocation(feed, context) async {
    // LocationPermission permission = await checkPermission();
    
    if (feed.udfReturnParameter != null &&
        feed.udfReturnParameter.contains('latitude') &&
        feed.udfReturnParameter.contains('longitude')) {
      LocationPermission permission = await location.checkLocationPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await location.getCurrentLocation();

        localStorage.saveUserLatitude(location.latitude.toString());
        localStorage.saveUserLongitude(location.longitude.toString());

        setState(() {
          latitude = location.latitude.toString();
          longitude = location.longitude.toString();
        });

        loadUrl(feed, context);
      } else {
        Provider.of<HomeLoadingModel>(context, listen: false)
            .loadingStatus(false);

        customDialog.show(
            context: context,
            content:
                AppLocalizations.of(context)!.translate('loc_permission_on'),
            type: DialogType.info);
      }
    } else {
      loadUrl(feed, context);
    }
  }

  _checkLocationPermission(feed, context) async {
    Provider.of<HomeLoadingModel>(context, listen: false).loadingStatus(true);
    // contactBox = Hive.box('emergencyContact');

    // await location.getCurrentLocation();

    bool serviceLocationStatus = await Geolocator.isLocationServiceEnabled();

    // GeolocationStatus geolocationStatus =
    //     await Geolocator().checkGeolocationPermissionStatus();

    if (serviceLocationStatus) {
      _getCurrentLocation(feed, context);
    } else {
      customDialog.show(
        context: context,
        barrierDismissable: false,
        title: Text(
            AppLocalizations.of(context)!.translate('loc_permission_title')),
        content: AppLocalizations.of(context)!.translate('loc_permission_desc'),
        customActions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.translate('yes_lbl')),
            onPressed: () {
              Provider.of<HomeLoadingModel>(context, listen: false)
                  .loadingStatus(false);
              context.router.pop();
              AppSettings.openAppSettings();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.translate('no_lbl')),
            onPressed: () {
              Provider.of<HomeLoadingModel>(context, listen: false)
                  .loadingStatus(false);

              context.router.pop();

              customDialog.show(
                  context: context,
                  content: AppLocalizations.of(context)!
                      .translate('loc_permission_on'),
                  type: DialogType.info);
            },
          ),
        ],
        type: DialogType.general,
      );
    }
  }

  getOnlinePaymentListByIcNo() async {
    String? icNo = await localStorage.getStudentIc();
    if (!context.mounted) return;
    var result = await fpxRepo.getOnlinePaymentListByIcNo(
      context: context,
      icNo: icNo ?? '',
      startIndex: '-1',
      noOfRecords: '-1',
    );

    if (mounted) {
      if (result.isSuccess) {
        return customDialog.show(
          context: context,
          title: Text(AppLocalizations.of(context)!.translate('success')),
          content:
              'Paid Amount: ${result.data[0].paidAmt}\nTransaction status: ${result.data[0].status}',
          customActions: <Widget>[
            TextButton(
                child: Text(AppLocalizations.of(context)!.translate('ok_btn')),
                onPressed: () {
                  context.router.pop();
                }),
          ],
          type: DialogType.general,
        );
      }
    }
  }

  defaultLayout(BuildContext context) {
    if (items.isNotEmpty) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (var item in items)
            Column(
              children: <Widget>[
                Ink(
                  // height: ScreenUtil().setHeight(780),
                  width: ScreenUtil().setWidth(1300),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 0.4),
                        blurRadius: 0.3,
                        spreadRadius: 0.5,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      var feedValue = item.feedNavigate;

                      if (feedValue != null) {
                        bool isUrl = isURL(feedValue);

                        // Navigation
                        if (!isUrl) {
                          switch (feedValue) {
                            case 'ENROLLMENT':
                              context.router.push(const Enrollment());
                              break;
                            case 'DI_ENROLLMENT':
                              String packageCodeJson = _getPackageCode(
                                  udf: item.udfReturnParameter);

                              context.router
                                  .push(
                                    DiEnrollment(
                                        packageCodeJson: packageCodeJson
                                            .replaceAll('&package=', '')),
                                  )
                                  .then((value) =>
                                      getOnlinePaymentListByIcNo());
                              break;
                            case 'KPP':
                              context.router.push(const KppCategory());
                              break;
                            case 'VCLUB':
                              context.router.push(const ValueClub());
                              break;
                            default:
                              break;
                          }
                        } else {
                          _checkLocationPermission(item, context);
                        }
                      }
                      /* else {
                        context.router
                            .push(Routes.promotions);
                      } */
                    },
                    child: Column(
                      children: <Widget>[
                        /* Container(
                          // width: double.infinity,
                          // height: ScreenUtil().setHeight(600),
                          width: 1300.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: feed[index].feedMediaFilename != null
                                ? Image.network(
                                    feed[index]
                                        .feedMediaFilename
                                        .replaceAll(removeBracket, '')
                                        .split('\r\n')[0],
                                    fit: BoxFit.contain,
                                  )
                                : Container(),
                          ),
                        ), */
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: item.feedMediaFilename != null
                                ? Image.network(
                                    item.feedMediaFilename
                                        .replaceAll(removeBracket, '')
                                        .split('\r\n')[0],
                                    fit: BoxFit.contain,
                                  )
                                : Container(),
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(180),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(70),
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  item.feedText ?? '',
                                  style: adText,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (item.feedText != null &&
                                  item.feedText.isNotEmpty)
                                const Icon(
                                  Icons.chevron_right,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
              ],
            ),
        ],
      );
    }
    if (isApproved) return _loadingShimmer();
    return Text(AppLocalizations.of(context)!.translate('no_active_feeds'));
  }

  tabLayout(BuildContext context) {
    if (items.isNotEmpty) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (var item in items)
            Column(
              children: <Widget>[
                Ink(
                  // height: ScreenUtil().setHeight(980),
                  width: ScreenUtil().setWidth(1300),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 0.4),
                        blurRadius: 0.3,
                        spreadRadius: 0.5,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      var feedValue = item.feedNavigate;

                      if (feedValue != null) {
                        bool isUrl = isURL(feedValue);

                        // Navigation
                        if (!isUrl) {
                          switch (feedValue) {
                            case 'ENROLLMENT':
                              context.router.push(const Enrollment());
                              break;
                            case 'DI_ENROLLMENT':
                              String packageCodeJson = _getPackageCode(
                                  udf: item.udfReturnParameter);

                              context.router
                                  .push(
                                    DiEnrollment(
                                        packageCodeJson: packageCodeJson
                                            .replaceAll('&package=', '')),
                                  )
                                  .then((value) =>
                                      getOnlinePaymentListByIcNo());
                              break;
                            case 'KPP':
                              context.router.push(const KppCategory());
                              break;
                            case 'VCLUB':
                              context.router.push(const ValueClub());
                              break;
                            default:
                              break;
                          }
                        } else {
                          _checkLocationPermission(item, context);
                        }
                      }
                      /* else {
                      context.router
                          .push(Routes.promotions);
                    } */
                    },
                    child: Column(
                      children: <Widget>[
                        /* Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(800),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: feed[index].feedMediaFilename != null
                              ? Image.network(
                                  feed[index]
                                      .feedMediaFilename
                                      .replaceAll(removeBracket, '')
                                      .split('\r\n')[0],
                                  fit: BoxFit.fill,
                                )
                              : Container(),
                        ),
                      ), */
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: item.feedMediaFilename != null
                                ? Image.network(
                                    item.feedMediaFilename
                                        .replaceAll(removeBracket, '')
                                        .split('\r\n')[0],
                                    fit: BoxFit.contain,
                                  )
                                : Container(),
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(180),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(70),
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(item.feedText ?? '', style: adText),
                              if (item.feedText != null &&
                                  item.feedText.isNotEmpty)
                                const Icon(
                                  Icons.chevron_right,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
              ],
            ),
        ],
      );
    }
    if (isApproved) return _loadingTabShimmer();
    return Text(AppLocalizations.of(context)!.translate('no_active_feeds'));
  }

  _loadingShimmer() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
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
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
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
        ),
      ],
    );
  }

  _loadingTabShimmer() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
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
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
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
        ),
      ],
    );
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
                if (!context.mounted) return;
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
                  if (!context.mounted) return;
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
                      if (_isLoading) shimmer(),
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
