import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (dynamic error, dynamic stack) {
    print(error);
    print(stack);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: ListView(
            children: [
              ListTile(
                title: InfoCard(
                  height: 200.0,
                  widget: Image.asset(
                    'assets/stag.png',
                    height: 100.0,
                  ),
                  widgetHeight: 10.0,
                  title: 'Stag OS version',
                  spaceHeight: 10.0,
                  subtitle: _deviceData['version.securityPatch'],
                ),
              ),
              ListTile(
                title: InfoCard(
                  height: 80.0,
                  leftAligned: true,
                  title: 'Android Version',
                  subtitle: _deviceData['version.release'],
                  spaceHeight: 10.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key key,
    this.height,
    this.widget,
    this.title,
    this.subtitle,
    this.spaceHeight,
    this.widgetHeight,
    this.leftAligned = false,
  }) : super(key: key);

  final height;
  final Widget widget;
  final widgetHeight;
  final String title;
  final String subtitle;
  final spaceHeight;
  final bool leftAligned;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      // width: 300.0,
      child: Card(
        color: Colors.grey[200],
        margin: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: leftAligned
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                widget ??
                    Container(
                      height: 0,
                    ),
                SizedBox(
                  height: widgetHeight ?? 10.0,
                ),
                Text(
                  title ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: spaceHeight ?? 10.0,
                ),
                Text(
                  subtitle ?? '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ListView(
//           children: _deviceData.keys.map(
//             (String property) {
//               return Row(
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text(
//                       property,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
//                       child: Text(
//                         '${_deviceData[property]}',
//                         maxLines: 10,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ).toList(),
//         ),
