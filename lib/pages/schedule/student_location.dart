import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

@RoutePage()
class MapScreen extends StatefulWidget {
  final address;
  final studName;

  const MapScreen({
    super.key,
    required this.address,
    required this.studName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;

  String studentAdd = '';
  LatLng _studAddress = LatLng(5.396434902461404, 100.39682462911831);
  String _name = '';
  final List<Marker>_markers = <Marker>[];
  bool isLoading = false;
  String add1 = '';
  String add2 = '';
  String add3 = '';

  Future<void> getAddressCoordinates() async {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    studentAdd = widget.address;
    if(studentAdd.isNotEmpty){
      try {
        List<Location> locations = await locationFromAddress(studentAdd);
          if (locations.isNotEmpty) {
          // final Location location = locations.first;
          // double latitude = location.latitude;
          // double longitude = location.longitude;
          // print('Latitude: $latitude, Longitude: $longitude');
          EasyLoading.dismiss();
          setState(() {
            _studAddress = LatLng(locations[0].latitude, locations[0].longitude);

          _markers.add(
            Marker(
              width: 80,
              height: 80,
              point: _studAddress,
              builder: (BuildContext context) { 
                return const Icon(
                  Icons.location_on, 
                  color: Colors.blue,
                  size: 50,
                );
              },
            ),);
            _mapController.move(_studAddress, 18);
          });
          
        } else {
          EasyLoading.dismiss();
          print('No coordinates found for the address');
        }
      } catch (e) {
        EasyLoading.dismiss();
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    getAddressCoordinates();
    setState(() {
      _name = widget.studName;
      List<String> parts = widget.address.split(', ');
      add1 = parts[0].trim();
      add2 = parts[1].trim();
      add3 = parts[2].trim();
    });
    super.initState();
    
    
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('map_lbl'))),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: 
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: ScreenUtil().screenWidth,
                  child: 
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: 
                    Row(
                      children: [
                        Text('$_name \n$add1,\n$add2,\n$add3'),
                      
                        IconButton(
                          iconSize: 20,
                          onPressed: () {
                            setState(() {
                              _mapController.move(_studAddress, 18);
                            });
                          },
                          icon: const Icon(Icons.location_searching_rounded)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  interactiveFlags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                  enableMultiFingerGestureRace: true,
                  center: _studAddress,
                  zoom: 18,
                  maxZoom: 18,
                  minZoom: 3,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: _markers,
                    rotate: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
