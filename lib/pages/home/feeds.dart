// ignore_for_file: use_key_in_widget_constructors

import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import '/common_library/services/model/provider_model.dart';
import '/common_library/services/location.dart';
import '/common_library/services/repository/fpx_repository.dart';
import '/common_library/services/repository/profile_repository.dart';
import '/utils/app_config.dart';
import '/common_library/utils/custom_dialog.dart';
import '/common_library/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:string_validator/string_validator.dart';
// import 'package:url_launcher/url_launcher.dart';

import '/common_library/utils/app_localizations.dart';
import '../../router.gr.dart';

class Feeds extends StatefulWidget {
  final dynamic feed;
  final bool? isLoading;
  final String? appVersion;

  const Feeds({this.feed, this.isLoading, this.appVersion});

  @override
  State<Feeds> createState() => FeedsState();
}

class FeedsState extends State<Feeds> {
  final adText = TextStyle(
    fontSize: ScreenUtil().setSp(50),
    fontWeight: FontWeight.bold,
    color: const Color(0xff231f20),
  );

  final adTabText = TextStyle(
    fontSize: ScreenUtil().setSp(60),
    fontWeight: FontWeight.bold,
    color: const Color(0xff231f20),
  );

  final RegExp removeBracket =
      RegExp("\\[(.*?)\\]", multiLine: true, caseSensitive: true);

  // get location
  Location location = Location();

  String latitude = '';
  String longitude = '';

  final customDialog = CustomDialog();

  final localStorage = LocalStorage();
  final profileRepo = ProfileRepo();
  final fpxRepo = FpxRepo();
  final appConfig = AppConfig();

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

  String _getPackageCode({udf}) {
    if (udf != null && udf.contains('package')) {
      int? startIndex = udf.indexOf('{');

      String? packages = udf.substring(startIndex);

      debugPrint(packages);

      return '&package=$packages';
    }
    return '';
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return defaultLayout();
      }
      return tabLayout();
    });
  }

  defaultLayout() {
    if (widget.feed.length > 0) {
      return ListView(
        // padding: const EdgeInsets.only(top: 20.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (var item in widget.feed)
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
                      feedValue = 'VCLUB';
                      if (feedValue != null) {
                        bool isUrl = isURL(feedValue);

                        // Navigation
                        if (!isUrl) {
                          switch (feedValue) {
                            case 'ETESTING':
                              context.router.push( EtestingCategory());
                              break;
                            case 'EDRIVING':
                              context.router.push( EpanduCategory());
                              break;
                            case 'ENROLLMENT':
                              context.router.push(const Enrollment());
                              break;
                            case 'DI_ENROLLMENT':
                              String packageCodeJson =
                                  _getPackageCode(udf: item.udfReturnParameter);

                              context.router
                                  .push(
                                    DiEnrollment(
                                        packageCodeJson: packageCodeJson
                                            .replaceAll('&package=', '')),
                                  )
                                  .then(
                                      (value) => getOnlinePaymentListByIcNo());
                              break;
                            case 'KPP':
                              context.router.push(const KppCategory());
                              break;
                            case 'VCLUB':
                              context.router.push(const ValueClub());
                              break;
                            case 'MULTILVL':
                              context.router.push(
                                Multilevel(
                                  feed: item,
                                ),
                              );
                              break;
                            default:
                              break;
                          }
                        } else {
                          _checkLocationPermission(item, context);
                        }
                      }
                      // else {
                      //   context.router
                      //       .push(Promotions());
                      // }
                    },
                    child: Column(
                      children: <Widget>[
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
                          // height: ScreenUtil().setHeight(180),
                          padding: EdgeInsets.symmetric(
                              horizontal: 70.w, vertical: 50.h),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          // alignment: Alignment.centerLeft,
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
                        /* Container(
                          height: ScreenUtil().setHeight(180),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(70),
                          ),
                          decoration: BoxDecoration(
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
                                Icon(
                                  Icons.chevron_right,
                                ),
                            ],
                          ),
                        ), */
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
    if (widget.isLoading!) return _loadingShimmer();
    return Text(AppLocalizations.of(context)!.translate('no_active_feeds'));
  }

  tabLayout() {
    if (widget.feed.length > 0) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (var item in widget.feed)
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
                            case 'ETESTING':
                              context.router.push( EtestingCategory());
                              break;
                            case 'EDRIVING':
                              context.router.push( EpanduCategory());
                              break;
                            case 'ENROLLMENT':
                              context.router.push(const Enrollment());
                              break;
                            case 'DI_ENROLLMENT':
                              String packageCodeJson =
                                  _getPackageCode(udf: item.udfReturnParameter);

                              context.router
                                  .push(
                                    DiEnrollment(
                                      packageCodeJson: packageCodeJson
                                          .replaceAll('&package=', ''),
                                    ),
                                  )
                                  .then(
                                      (value) => getOnlinePaymentListByIcNo());
                              break;
                            case 'KPP':
                              context.router.push(const KppCategory());
                              break;
                            case 'VCLUB':
                              context.router.push(const ValueClub());
                              break;
                            case 'MULTILVL':
                              context.router.push(
                                Multilevel(
                                  feed: item,
                                ),
                              );
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
                        /* Container(
                          height: ScreenUtil().setHeight(180),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(70),
                          ),
                          decoration: BoxDecoration(
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
                                Icon(
                                  Icons.chevron_right,
                                ),
                            ],
                          ),
                        ), */
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
    if (widget.isLoading!) return _loadingTabShimmer();
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
}
