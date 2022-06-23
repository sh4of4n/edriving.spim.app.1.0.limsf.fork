// ignore_for_file: use_key_in_widget_constructors

//import 'package:auto_route/auto_route.dart';
import '/common_library/services/location.dart';
import '/common_library/services/repository/auth_repository.dart';
import '/common_library/services/repository/kpp_repository.dart';
import '/utils/constants.dart';
import '/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

//import '../../router.gr.dart';
import 'home_module.dart';
import 'home_top_menu.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final authRepo = AuthRepo();
  final kppRepo = KppRepo();
  final localStorage = LocalStorage();
  final primaryColor = ColorConstant.primaryColor;
  // String _username = '';
  final myImage = ImagesConstant();
  // get location
  Location location = Location();
  final geolocator = Geolocator();

  String instituteLogo = '';
  bool isLogoLoaded = false;

  @override
  void initState() {
    super.initState();

    //_openHiveBoxes();
    // getStudentInfo();
    //_getCurrentLocation();
    //_getDiProfile();
    //_getActiveFeed();

    _openHiveBoxes();
  }

  @override
  void dispose() {
    // positionStream.cancel();
    super.dispose();
  }

  _openHiveBoxes() async {
    await Hive.openBox('telcoList');
    await Hive.openBox('serviceList');
    // await Hive.openBox('emergencyContact');
  }

/*
  /* _getDiProfile() async {
    // String instituteLogoPath = await localStorage.getInstituteLogo();

    var result = await authRepo.getDiProfile(context: context);

    if (result.isSuccess && result.data != null) {
      // Uint8List decodedImage = base64Decode(
      //     result.data);

      setState(() {
        instituteLogo = result.data;
        isLogoLoaded = true;
      });
    }

    if (instituteLogoPath.isEmpty) {
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
    }
  } */

  /* _getActiveFeed() async {
    var result = await authRepo.getActiveFeed(
      context: context,
      feedType: 'MAIN',
    );

    if (result.isSuccess) {
      setState(() {
        feed = result.data;
      });
    }
  } */

  /* _getCurrentLocation() async {
    await location.getCurrentLocation();
    await _checkSavedCoord();
    userTracking();
  } */

  // Check if stored latitude and longitude is null
  /* _checkSavedCoord() async {
    double _savedLatitude =
        double.tryParse(await localStorage.getUserLatitude());
    double _savedLongitude =
        double.tryParse(await localStorage.getUserLongitude());

    if (_savedLatitude == null || _savedLongitude == null) {
      localStorage.saveUserLatitude(location.latitude.toString());
      localStorage.saveUserLongitude(location.longitude.toString());
    }
  } */

  // remember to add positionStream.cancel()
  /* Future<void> userTracking() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();

    // print(geolocationStatus);

    if (geolocationStatus == GeolocationStatus.granted) {
      positionStream = geolocator
          .getPositionStream(locationOptions)
          .listen((Position position) async {
        localStorage.saveUserLatitude(position.latitude.toString());
        localStorage.saveUserLongitude(position.longitude.toString());
      });
    }
  } */

  /* _openHiveBoxes() async {
    await Hive.openBox('telcoList');
    await Hive.openBox('serviceList');
    // await Hive.openBox('emergencyContact');
  } */
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.white,
              Color.fromARGB(255, 241, 233, 198),
              Colors.amber
            ])),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const HomeTopMenu(),
              HomeModule(),
              //LimitedBox(maxHeight: ScreenUtil().setHeight(30)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        tooltip: 'Chat',
        backgroundColor: const Color.fromARGB(255, 32, 56, 90),
        child: const Icon(Icons.chat),
      ),
    );
  }
}
