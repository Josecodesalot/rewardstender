import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'package:rewardstender/main.dart';


class CameraView extends StatefulWidget {
  CameraView({@required this.onResult});
  final Function onResult;
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController controller;
  CameraDescription camera = cameras[2];

  @override
  void initState() {
    super.initState();
    controller = CameraController(camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller.startImageStream((image)async {
        final results = await FlutterBarcodeSdk(
        ).decodeFileBytes(concatenatePlanes(image.planes));
        if(results.isNotEmpty) {
          widget.onResult(results.first.text);
        }
      });

    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller),
    );
  }

  void onNewCameraSelected(CameraDescription description) {
    setState(() {
      camera = description;
    });
  }
}

Uint8List concatenatePlanes(List<Plane> planes) {
  final WriteBuffer allBytes = WriteBuffer();
  planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
  return allBytes.done().buffer.asUint8List();
}