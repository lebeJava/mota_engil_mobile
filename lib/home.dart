import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mota_engil_mobile/Updater.dart';
import 'package:mota_engil_mobile/widgets/drawer.dart';
import 'package:mota_engil_mobile/loads.dart';
import 'package:mota_engil_mobile/messages.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';
import 'package:mota_engil_mobile/widgets/custom_button.dart';
import 'package:mota_engil_mobile/widgets/custom_fab.dart';
import 'package:mota_engil_mobile/widgets/custom_input.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Singleton singleton = new Singleton();
  Random random = new Random();
  bool loading = false;
  bool isDeviceConnected = false;
  bool isStandBy = false;
  bool isOptionsShow = false;

  late final AnimationController _animationController;
  final storage = const FlutterSecureStorage();

  bool showSocialLogin = true;
  bool showSocialLoginApple = false;

  final TextInputType text = TextInputType.text;

  final msgController = TextEditingController();

  late Timer _requestCurrentLocationTimer;

  bool isEnable = false;

  var polyLines = [
    Polyline(
      points: [
        LatLng(-16.4070000, -71.5500000),
        LatLng(-16.4020000, -71.5500000),
        LatLng(-16.4030000, -71.5450000),
        LatLng(-16.4020000, -71.5350000),
        LatLng(-16.3988900, -71.5350000),
        LatLng(-16.3788900, -71.5300000),
      ],
      strokeWidth: 8.0,
      gradientColors: [
        const Color(0xFF8E2DE2),
        const Color(0xff4A00E0),
      ],
    ),
  ];

  final markers = [
    /*Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(-16.4030000, -71.5450000),
        builder: (ctx) => _Marker(Color(0xFF00B912))),*/
    Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(-16.4020000, -71.5350000),
        builder: (ctx) => _Marker(Color(0xFFF92323))),
    Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(-16.4020000, -71.5500000),
        builder: (ctx) => _Marker(Color(0xFFF92323))),
  ];

  late Location _myCurrentLocation = Location(
      longitude: -16.3988900,
      latitude: -71.5350000,
      altitude: null,
      accuracy: null,
      bearing: null,
      speed: null,
      time: null,
      isMock: null);

  late final MapController mapController;

  late Timer globalRefresh;

  TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return homeUI();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animationController.repeat();
    super.initState();
    mapController = MapController();

    globalRefresh = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    globalRefresh.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    setState(() {
      loading = true;
    });

    if (!isEnable) {
      _sendLocation(moveController: true);
      setState(() {
        isEnable = true;
        loading = false;
      });
    }

    _requestCurrentLocationTimer =
        Timer.periodic(Duration(seconds: 10), (timer) async {
      _sendLocation();
    });
  }

  _sendLocation({bool moveController = false}) async {
    Location position = new Location();
    position.latitude = -16.39889;
    position.longitude = -71.535;
    if (moveController) {
      mapController.move(LatLng(position.latitude!, position.longitude!), 12.0);
    }
    setState(() {
      _myCurrentLocation = position;
    });
  }

  Widget homeUI() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006EB9),
        title: Text(
          singleton.name,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: EdgeInsets.all(8.0),
            child: isDeviceConnected
                ? CustomButton(
                    color: isStandBy
                        ? [Color(0xFFF9B023), Color(0xFFF9B023)]
                        : [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                    radius: 8.0,
                    onTap: () async {
                      textController.text = "";
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color(0xFFF9B023),
                            content: Container(
                              color: Color(0xFFF9B023),
                              height: 300.0, // Change as per your requirement
                              width: 150.0, // Change as per your requirement
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    isStandBy
                                        ? 'Se quitará el modo stand-by'
                                        : 'Se iniciará el modo stand-by',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Ingresa el motivo:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  CustomInput(
                                    text: '',
                                    controller: textController,
                                    textInputType: text,
                                    dark: true,
                                  ),
                                  CustomButton(
                                    color: [
                                      Color(0xFF006EB9),
                                      Color(0xFF006EB9)
                                    ],
                                    radius: 8.0,
                                    onTap: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        isStandBy = !isStandBy;
                                      });
                                    },
                                    child: const Center(
                                      child: Text(
                                        'Guardar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 4.0),
                          child: Icon(Icons.dangerous,
                              color: isStandBy
                                  ? Color(0xFF000000)
                                  : Color(0xFF006EB9),
                              size: 32.0),
                        ),
                        Expanded(
                          child: Text(
                            'Stand-by',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isStandBy
                                    ? Color(0xFF000000)
                                    : Color(0xFF006EB9),
                                fontSize: 24.0),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(''),
          )
        ],
      ),
      drawer: DrawerMenu(context, singleton.name),
      body: Stack(
        children: [
          // LatLng(-16.3988900, -71.5350000)
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
                center: LatLng(-16.3988900, -71.5350000),
                zoom: 12.0,
                minZoom: 12.0,
                maxZoom: 14.0),
            layers: [
              TileLayerOptions(
                tileProvider: const FileTileProvider(),
                maxZoom: 14.0,
                urlTemplate: '${singleton.localDir}/map/{z}/{x}/{y}.png',
              ),
              /*TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/ftamayom/cl2cj616e003b14mygtl3fu75/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZnRhbWF5b20iLCJhIjoiY2twcmQzZHE5MGMyZDJwbzBlZXZocDN1diJ9.I47XS_CBlqs9pkkOYWANfw",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiZnRhbWF5b20iLCJhIjoiY2twcmQzZHE5MGMyZDJwbzBlZXZocDN1diJ9.I47XS_CBlqs9pkkOYWANfw',
                  'id': 'mapbox.mapbox-streets-v8'
                },
                /*attributionBuilder: (_) {
              return Text("© OpenStreetMap contributors");
            },*/
              ),*/
              PolylineLayerOptions(
                polylines: polyLines,
              ),
              MarkerLayerOptions(
                markers: isEnable && _myCurrentLocation.latitude != null
                    ? [
                        Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(_myCurrentLocation.latitude!,
                                _myCurrentLocation.longitude!),
                            builder: (ctx) =>
                                _MyLocationMarker(_animationController)),
                        ...markers
                      ]
                    : markers,
              ),
            ],
          ),
          isDeviceConnected
              ? Container(
                  width: MediaQuery.of(context).size.width / 3,
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        singleton.trips.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'viaje${singleton.trips == 1 ? '' : 's'}',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFF000000), fontSize: 24.0),
                      )
                    ],
                  ),
                )
              : Text(''),
          isDeviceConnected
              ? Positioned(
                  top: 16,
                  right: 16,
                  height: 56.0,
                  child: FloatingActionButton(
                    heroTag: 'location',
                    backgroundColor: isEnable ? Colors.black : Colors.white,
                    child: Icon(
                      Icons.my_location,
                      size: 32.0,
                      color: isEnable ? Colors.white : Colors.black,
                    ),
                    onPressed: () async {
                      if (isEnable) {
                        _requestCurrentLocationTimer.cancel();
                        setState(() {
                          isEnable = false;
                        });
                      } else {
                        _determinePosition();
                      }
                    },
                  ),
                )
              : Text(''),
          isOptionsShow
              ? Positioned(
                  right: 0,
                  bottom: 56 + 32,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: FloatingActionButton(
                      heroTag: "btn_msg",
                      child: Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.black,
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MessagesScreen()));
                      },
                    ),
                  ),
                )
              : Text(''),
          isOptionsShow
              ? Positioned(
                  right: 56 + 16,
                  bottom: 16,
                  height: 56.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: FloatingActionButton(
                      heroTag: "btn_load",
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.black,
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoadsScreen()));
                      },
                    ),
                  ),
                )
              : Text(''),
          isDeviceConnected
              ? Positioned(
                  right: 0,
                  bottom: 16.0,
                  height: 56.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: FloatingActionButton(
                      heroTag: "btn_menu",
                      child: Icon(
                        Icons.dashboard,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.black,
                      onPressed: () async {
                        setState(() {
                          isOptionsShow = !isOptionsShow;
                        });
                      },
                    ),
                  ),
                )
              : Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16.0,
                  height: 56.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: CustomButton(
                      color: [Color(0xFFF9B023), Color(0xFFF9B023)],
                      radius: 8.0,
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });

                        EasyLoading.show(
                          status: 'Cargando...',
                        );

                        int randomValue = random.nextInt(4) + 1;

                        await delay(randomValue);

                        setState(() {
                          loading = false;
                        });

                        EasyLoading.dismiss();

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Dispositivos encontrados'),
                                content: Container(
                                  height:
                                      300.0, // Change as per your requirement
                                  width:
                                      150.0, // Change as per your requirement
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.bluetooth_searching,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                  'MEX_400${(index + 1) * 2}',
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () async {
                                          EasyLoading.show(
                                            status: 'Conectando...',
                                          );

                                          randomValue = random.nextInt(4) + 1;

                                          await delay(randomValue);

                                          EasyLoading.dismiss();

                                          Navigator.pop(context);

                                          setState(() {
                                            isDeviceConnected = true;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            });

                        // Simulate login
                        // await Future.delayed(const Duration(seconds: 3), (){});
                        // EasyLoading.dismiss();
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Icon(Icons.bluetooth_searching,
                                color: Color(0xFF000000), size: 32.0),
                          ),
                          Expanded(
                            child: Text(
                              'Conectarse al dispositivo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF000000), fontSize: 24.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          loading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0x46000000),
                )
              : Text('')
        ],
      ),
    );
  }
}

class _MyLocationMarker extends AnimatedWidget {
  const _MyLocationMarker(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(0.5, 1.0, value)!;
    final firstSize = 40.0;
    final secondSize = 60.0;
    return Stack(
      children: [
        Center(
          child: Container(
            height: firstSize * newValue,
            width: firstSize * newValue,
            decoration: BoxDecoration(
                color: Color(0xFF006EB9).withOpacity(0.5),
                shape: BoxShape.circle),
          ),
        ),
        Center(
          child: Container(
            height: secondSize * value,
            width: secondSize * value,
            decoration: BoxDecoration(
                color: Color(0xFF006EB9).withOpacity(0.2),
                shape: BoxShape.circle),
          ),
        ),
        Center(
          child: Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
              color: Color(0xFF006EB9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Color(0xFF006EB9), blurRadius: 16.0),
              ],
              border: Border.all(
                width: 0.5,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Marker extends StatelessWidget {
  _Marker(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 20.0,
        width: 20.0,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 16.0),
          ],
          border: Border.all(
            width: 0.5,
            color: Colors.black,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}

class CustomPageRouteBuilder<T> extends PageRouteBuilder<T> {
  CustomPageRouteBuilder({
    required this.widget,
  })  : assert(widget != null),
        super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final Widget transition = SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(0.0, -0.7),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );

            return transition;
          },
        );

  final Widget widget;
}

delay(time) {
  return Future.delayed(Duration(seconds: time), () {});
}
