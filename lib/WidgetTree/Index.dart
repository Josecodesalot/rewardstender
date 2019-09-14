// Created By Jose Ignacio Lara Arandia 2019/09/11/time:09:03

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/Provider/CameraBloc.dart';
import 'package:rewardstender/Provider/UserBloc.dart';
import 'package:rewardstender/Utils/Const.dart';

import 'package:flutter/services.dart';


class Index extends StatelessWidget {
  final String error1 = "Camera permission was denied";
  final String error2 = "Unknown Error ";
  final String error3= "You pressed the back button before scanning anything";

   UserBloc userBloc;
   CameraBloc cameraBloc;

  //shows results in mainpage

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.of<UserBloc>(context);
    cameraBloc = Provider.of<CameraBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Welcome " + (userBloc.clerk[ClerkFields.name])),),
      body: content(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Center(child: Text("Scan")),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget content(){
    if(cameraBloc.resultGotten){
      return SafeArea(
        child: Column(
          children: <Widget>[
            Spacer(),
            Center(child: Text(cameraBloc.result)),
            Spacer(),
          ],
        ),
      );
    }else{
      return SafeArea(
        child: Column(
          children: <Widget>[
            Spacer(),
            Center(child: Text("Ready To Scan")),
            Spacer(),
          ],
        ),
      );
    }
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan().then((value){
        cameraBloc.changeResultStatus(true);
        cameraBloc.setResult(value.toString());
        return value;
      });
      return qrResult.toString();
    }
    on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        return cameraBloc.setResult(error1);
      } else {
        return cameraBloc.setResult(error2);
      }
    } on FormatException {
      return cameraBloc.setResult(error3);
    } catch (ex) {
      return cameraBloc.setResult(error2);
    }
  }
}
