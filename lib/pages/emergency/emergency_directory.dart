import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import '/common_library/services/location.dart';
import '/common_library/services/repository/emergency_repository.dart';
import '/utils/constants.dart';
import '/common_library/utils/custom_dialog.dart';
import '/common_library/utils/custom_snackbar.dart';
import '/common_library/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '/common_library/utils/app_localizations.dart';
import '../../router.gr.dart';
import 'directory_card.dart';

@RoutePage()
class EmergencyDirectory extends StatefulWidget {
  const EmergencyDirectory({super.key});

  @override
  EmergencyDirectoryState createState() => EmergencyDirectoryState();
}

class EmergencyDirectoryState extends State<EmergencyDirectory> {
  final primaryColor = ColorConstant.primaryColor;
  final localStorage = LocalStorage();
  final emergencyRepo = EmergencyRepo();
  final myImage = ImagesConstant();
  final customDialog = CustomDialog();
  final customSnackbar = CustomSnackbar();
  final iconText = TextStyle(
    fontSize: ScreenUtil().setSp(64),
    fontWeight: FontWeight.bold,
    color: const Color(0xff5d6767),
  );
  final location = Location();

  String? policeNumber = '';
  String? ambulanceNumber = '';
  String? bombaNumber = '';
  String? carWorkshopNumber = '';
  String? bikeWorkshopNumber = '';

  @override
  void initState() {
    super.initState();

    _checkLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _checkLocationPermission() async {
    // contactBox = Hive.box('emergencyContact');

    // await location.getCurrentLocation();

    bool serviceLocationStatus = await Geolocator.isLocationServiceEnabled();

    // GeolocationStatus geolocationStatus =
    //     await Geolocator().checkGeolocationPermissionStatus();

    if (serviceLocationStatus) {
      _getCurrentLocation();
    } else {
      if (!context.mounted) return;
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
              context.router.pop();
              context.router.pop();
              AppSettings.openAppSettings();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.translate('no_lbl')),
            onPressed: () {
              context.router.pop();
              context.router.pop();
            },
          ),
        ],
        type: DialogType.general,
      );
    }
  }

  _getCurrentLocation() async {
    LocationPermission permission = await location.checkLocationPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await location.getCurrentLocation();
      await _checkSavedCoord();
      // userTracking();

      Future.wait([
        _getSosContact('POLICE'),
        _getSosContact('AMBULANCE'),
        _getSosContact('BOMBA'),
        _getSosContact('WORKSHOP'),
        _getSosContact('BIKEWORKSHOP'),
      ]);
    } else {
      if (!context.mounted) return;
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
              context.router.pop();
              context.router.pop();
              AppSettings.openAppSettings();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.translate('no_lbl')),
            onPressed: () {
              context.router.pop();
              context.router.pop();
            },
          ),
        ],
        type: DialogType.general,
      );
    }
  }

  // Check if stored latitude and longitude is null
  _checkSavedCoord() async {
    localStorage.saveUserLatitude(location.latitude.toString());
    localStorage.saveUserLongitude(location.longitude.toString());

    /* double _savedLatitude =
        double.tryParse(await localStorage.getUserLatitude());
    double _savedLongitude =
        double.tryParse(await localStorage.getUserLongitude());
 */
    /* if (_savedLatitude == null || _savedLongitude == null) {
      localStorage.saveUserLatitude(location.latitude.toString());
      localStorage.saveUserLongitude(location.longitude.toString());
    } */
  }

  Future<void> _getSosContact(type) async {
    var response = await emergencyRepo.getSosContactSortByNearest(
      context: context,
      sosContactType: type,
      maxRadius: '30',
    );

    if (response.isSuccess && type == 'POLICE') {
      var policeContacts = response.data;

      for (int i = 0; i < policeContacts.length; i += 1) {
        if (policeContacts[i].sosContactSubtype == 'IPD' && mounted) {
          setState(() {
            policeNumber = policeContacts[i].phone;
          });
          break;
        }
      }
    } else if (response.isSuccess && type == 'AMBULANCE') {
      var ambulanceContacts = response.data;

      /* for (int i = 0; i < ambulanceContacts.length; i += 1) {
        if (ambulanceContacts[i].sosContactSubtype == 'PUBLIC' && mounted) {
          setState(() {
            ambulanceNumber = ambulanceContacts[i].phone;
          });
          break;
        }
      } */

      setState(() {
        ambulanceNumber = ambulanceContacts[0].phone;
      });
    } else if (response.isSuccess && type == 'BOMBA') {
      var bombaContacts = response.data;

      for (int i = 0; i < bombaContacts.length; i += 1) {
        if (bombaContacts[i].phone != null && mounted) {
          setState(() {
            bombaNumber = bombaContacts[i].phone;
          });
          break;
        }
      }

      // setState(() {
      //   bombaNumber = bombaContacts[0].phone;
      // });
    } else if (response.isSuccess && type == 'WORKSHOP') {
      var carWorkshopContacts = response.data;

      if (mounted) {
        setState(() {
          carWorkshopNumber = carWorkshopContacts[0].phone;
        });
      }
    } else if (response.isSuccess && type == 'BIKEWORKSHOP') {
      var bikeWorkshopContacts = response.data;

      if (mounted) {
        setState(() {
          bikeWorkshopNumber = bikeWorkshopContacts[0].phone;
        });
      }
    }
  }

  _callPoliceNumber() async {
    if (policeNumber!.isEmpty) {
      customSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.translate('no_nearby_contacts'),
        duration: 5000,
        type: MessageType.info,
      );
    } else {
      String trimNumber = policeNumber!.replaceAll('-', '').replaceAll(' ', '');

      await launchUrl(Uri.parse('tel:$trimNumber'));
    }
  }

  _callEmergencyNumber() async {
    if (ambulanceNumber!.isEmpty) {
      customSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.translate('no_nearby_contacts'),
        duration: 5000,
        type: MessageType.info,
      );
    } else {
      String trimNumber =
          ambulanceNumber!.replaceAll('-', '').replaceAll(' ', '');

      await launchUrl(Uri.parse('tel:$trimNumber'));
    }
  }

  _callBombaNumber() async {
    if (bombaNumber!.isEmpty) {
      customSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.translate('no_nearby_contacts'),
        duration: 5000,
        type: MessageType.info,
      );
    } else {
      String trimNumber = bombaNumber!.replaceAll('-', '').replaceAll(' ', '');

      await launchUrl(Uri.parse('tel:$trimNumber'));
    }
  }

  _callCarWorkshopNumber() async {
    if (carWorkshopNumber!.isEmpty) {
      customSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.translate('no_nearby_contacts'),
        duration: 5000,
        type: MessageType.info,
      );
    } else {
      String trimNumber =
          carWorkshopNumber!.replaceAll('-', '').replaceAll(' ', '');

      await launchUrl(Uri.parse('tel:$trimNumber'));
    }
  }

  _callBikeWorkshopNumber() async {
    if (bikeWorkshopNumber!.isEmpty) {
      customSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.translate('no_nearby_contacts'),
        duration: 5000,
        type: MessageType.info,
      );
    } else {
      String trimNumber =
          bikeWorkshopNumber!.replaceAll('-', '').replaceAll(' ', '');

      await launchUrl(Uri.parse('tel:$trimNumber'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xffffcd11)],
          stops: [0.65, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 232, 186, 4),
          title: Text(AppLocalizations.of(context)!.translate('sos_lbl')),
        ),
        body: SizedBox(
          // margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(50)),
          height: ScreenUtil().screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FadeInImage(
                  alignment: Alignment.center,
                  placeholder: MemoryImage(kTransparentImage),
                  image: AssetImage(
                    myImage.sosBanner,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                _renderCards(),
                SizedBox(
                  height: ScreenUtil().setHeight(70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _renderCards() {
    if (policeNumber!.isNotEmpty && ambulanceNumber!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Table(
          // defaultVerticalAlignment: TableCellVerticalAlignment.top,
          // border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                DirectoryCard(
                  title:
                      AppLocalizations.of(context)!.translate('police_title'),
                  image: myImage.policeIcon,
                  phoneIcon: myImage.phoneButton,
                  directoryIcon: myImage.directoryButton,
                  iconText: iconText,
                  phoneAction: _callPoliceNumber,
                  directory: DirectoryList(directoryType: 'POLICE'),
                ),
                DirectoryCard(
                  title: AppLocalizations.of(context)!
                      .translate('ambulance_title'),
                  image: myImage.ambulanceIcon,
                  phoneIcon: myImage.phoneButton,
                  directoryIcon: myImage.directoryButton,
                  iconText: iconText,
                  phoneAction: _callEmergencyNumber,
                  directory: DirectoryList(directoryType: 'AMBULANCE'),
                ),
              ],
            ),
            TableRow(
              children: [
                DirectoryCard(
                  title: AppLocalizations.of(context)!.translate('bomba_title'),
                  image: myImage.bombaIcon,
                  phoneIcon: myImage.phoneButton,
                  directoryIcon: myImage.directoryButton,
                  iconText: iconText,
                  phoneAction: _callBombaNumber,
                  directory: DirectoryList(directoryType: 'BOMBA'),
                ),
                DirectoryCard(
                  title:
                      AppLocalizations.of(context)!.translate('towing_service'),
                  image: myImage.towingIcon,
                  phoneIcon: myImage.phoneButton,
                  directoryIcon: myImage.directoryButton,
                  iconText: iconText,
                  phoneAction: () => {
                    customSnackbar.show(
                      context,
                      message: AppLocalizations.of(context)!
                          .translate('select_insurance'),
                      duration: 5000,
                      type: MessageType.info,
                    ),
                  },
                  directory: DirectoryList(directoryType: 'INSURANCE'),
                ),
              ],
            ),
            TableRow(
              children: [
                DirectoryCard(
                  title:
                      AppLocalizations.of(context)!.translate('workshop_cars'),
                  image: myImage.workshopCar,
                  phoneIcon: myImage.phoneButton,
                  directoryIcon: myImage.directoryButton,
                  iconText: iconText,
                  phoneAction: _callCarWorkshopNumber,
                  directory: DirectoryList(directoryType: 'WORKSHOP'),
                ),
                DirectoryCard(
                  title:
                      AppLocalizations.of(context)!.translate('workshop_bike'),
                  image: myImage.workshopBike,
                  phoneIcon: myImage.phoneButton,
                  directoryIcon: myImage.directoryButton,
                  iconText: iconText,
                  phoneAction: _callBikeWorkshopNumber,
                  directory: DirectoryList(directoryType: 'BIKEWORKSHOP'),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Table(
          children: [
            TableRow(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: DirectoryCard(
                    title: '',
                    image: myImage.policeIcon,
                    phoneIcon: myImage.phoneButton,
                    directoryIcon: myImage.directoryButton,
                    iconText: iconText,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: DirectoryCard(
                    title: '',
                    image: myImage.ambulanceIcon,
                    phoneIcon: myImage.phoneButton,
                    directoryIcon: myImage.directoryButton,
                    iconText: iconText,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: DirectoryCard(
                    title: '',
                    image: myImage.bombaIcon,
                    phoneIcon: myImage.phoneButton,
                    directoryIcon: myImage.directoryButton,
                    iconText: iconText,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: DirectoryCard(
                    title: '',
                    image: myImage.towingIcon,
                    phoneIcon: myImage.phoneButton,
                    directoryIcon: myImage.directoryButton,
                    iconText: iconText,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: DirectoryCard(
                    title: '',
                    image: myImage.workshopCar,
                    phoneIcon: myImage.phoneButton,
                    directoryIcon: myImage.directoryButton,
                    iconText: iconText,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: DirectoryCard(
                    title: '',
                    image: myImage.workshopBike,
                    phoneIcon: myImage.phoneButton,
                    directoryIcon: myImage.directoryButton,
                    iconText: iconText,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
