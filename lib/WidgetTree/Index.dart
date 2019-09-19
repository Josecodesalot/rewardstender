// Created By Jose Ignacio Lara Arandia 2019/09/11/time:09:03

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/BusinessLogic/Reward.dart';
import 'package:rewardstender/CloudServices/FirebaseMethod.dart';
import 'package:rewardstender/CloudServices/FirebaseMethod.dart' as prefix0;
import 'package:rewardstender/Future/GuestFuture.dart';
import 'package:rewardstender/Models/HistoryTicket.dart';
import 'package:rewardstender/Models/PlaceGuest.dart';
import 'package:rewardstender/Provider/CameraBloc.dart';
import 'package:rewardstender/Provider/UserBloc.dart';
import 'package:rewardstender/Utils/Const.dart';
import 'package:flutter/services.dart';
import 'package:rewardstender/Utils/fieldFormat.dart';
import 'package:rewardstender/Widget/MyButton.dart';
import 'package:rewardstender/WidgetTree/HistoryTicketsPage.dart';

class Index extends StatelessWidget {

  //Constants
  final String error1 = "Camera permission was denied";
  final String error2 = "Unknown Error ";
  final String error3= "You pressed the back button before scanning anything";

  //Keys
  final GlobalKey<FormState> dialogKey = GlobalKey<FormState>();
  final GlobalKey<FormState> mKey = GlobalKey<FormState>();

  //Objects
  final myController =  TextEditingController();

  //Providers
  UserBloc userBloc;
  CameraBloc cameraBloc;

  //Variables
  int startingPoints;
  int awardingPoints;
  int endingPoints;
  double subTotal;
  String guestId;
  String guestName;
  Map placeGuest;
  bool newUser;
  String placeId;
  String placeName;


  @override
  Widget build(BuildContext context) {
    debugPrint("Index called");
    userBloc = Provider.of<UserBloc>(context);
    cameraBloc = Provider.of<CameraBloc>(context);

    placeId = userBloc.clerk[ClerkFields.placeId];
    placeName =userBloc.clerk[ClerkFields.placeName];

    return Scaffold(
      appBar: AppBar(title: Text("Welcome " + (userBloc.clerk[ClerkFields.name])),),
      body: content(context),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Center(child: Text("Scan")),
        onPressed: _scanQR,
      ),
      drawer: drawer(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget content(BuildContext context){
    if(cameraBloc.resultGotten){
      return SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: onValue(cameraBloc.result, context)),
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

  Widget onValue(String uid, BuildContext context){

    return FutureBuilder(
      future: GetGuestFuture.getData(uid, placeId),
      builder: (_,asyncSnap){
        if(asyncSnap.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }else{
          if(asyncSnap.data!=null){
            Map data = asyncSnap.data;
            if (data.isNotEmpty){
               placeGuest = data[GuestFutureFields.getGuestMap];
              if(placeGuest.isNotEmpty){
                startingPoints = placeGuest[PlaceGuestFields.points];
                guestName = placeGuest[PlaceGuestFields.guestName];
                guestId = placeGuest[PlaceGuestFields.guestId];
                newUser = data[GuestFutureFields.newUsernbool];

                return pointsAndSubTotal(startingPoints, context);
              }else{
                debugPrint("PlaceGuest is empty");
                return Text("Error user not found contact developer");
              }
            }else{
              return Text("Error user not found");
            }
          }else{
            return Text("Something went Wrong Please try again");
          }
        }
      },
    );
  }

  Widget pointsAndSubTotal(int points, BuildContext context){
    List<Widget> buttons= List();
    buttons.add(Text("First Reward after " + Const.fiveDollars.toString() +" points"));

    if(points>Const.fiveDollars){
      buttons.removeLast();
      Widget fiveBtn = MyButton("5\$ off");
      buttons.add(
          GestureDetector(
            onTap: (){redeemAlet(Const.fiveDollars, context);},
            child: Container(
                margin: EdgeInsets.all(5),
                child: fiveBtn),
          ));
    }

    if(points>Const.tenDollars){
      Widget tenBtn = MyButton("10\$off");

      buttons.add(Container(
          margin: EdgeInsets.all(5),
          child: tenBtn));
    }

    if(points>Const.twentieDollars){
      Widget twentyBtn = MyButton("20\$ off");

      buttons.add(Container(
          margin: EdgeInsets.all(5),
          child: twentyBtn));
    }

    return Container(

      child: Column(

        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
              child: Text(
                  "points " + points.toString(),
              style: TextStyle(fontSize: 18),textAlign: TextAlign.center,)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child: TextFormField(
              textAlign: TextAlign.center,
              key: mKey,
              autofocus:true,
              controller: myController,
              decoration: InputDecoration(
                  hintText: 'SubTotal'
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],


            ),
          ),

          GestureDetector(
              onTap: (){
                if(myController.text.toString()!="") {
                  debugPrint("hasText");
                  subTotal = double.parse(myController.text.toString());
                  _showDialog(context);
                }else{
                  debugPrint("has no Txt");
                  _showSubTotalDialog(context);
                }
              },
              child: MyButton("Submit Subtotal")),

        ],
      ),
    );
  }

  void _showSubTotalDialog(BuildContext thisContext){
    debugPrint("ShowSubTotalDialog");
    showDialog(
      context: thisContext,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Please Put The SubTotal Here"),
          content: Form(
            key: dialogKey,
            child: TextFormField(
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              keyboardType:  TextInputType.numberWithOptions(decimal: true),
              onSaved: (value){
                debugPrint("on Saved Called");
                subTotal = double.parse(value.toString());
               },

              decoration: InputDecoration(
                hintText: "SubText"
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              textColor: Colors.white,
              child: Text("Accept"),
              onPressed: (){
                debugPrint("Accept Button clicked");
                Navigator.pop(context);
                final FormState form = dialogKey.currentState;
                if(form.validate()){
                  form.save();
                  debugPrint(" subtotal = $subTotal");
                  myController.text=subTotal.toString();
                }
              },
            ),

            RaisedButton(
              textColor: Colors.white,
              child: Text("Cancel"),
              onPressed: (){

              },
            )
          ],
        );
      }
    );
  }

  validator(String value){
    return value.isEmpty ? 'SubTotal can\'t be empty' : null;
  }

  void _showDialog( BuildContext thiscontext){
    showDialog(
        context: thiscontext,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("SubTotal is $subTotal , Proceed?"),
            actions: <Widget>[
              RaisedButton(
                textColor: Colors.white,
                child: Text(
                  "yes",
                ),
                onPressed:()async{
                   awardingPoints = Reward.getPointsBySubtotal(subTotal);
                   endingPoints = startingPoints + awardingPoints;
                   placeGuest[PlaceGuestFields.points]=endingPoints;
                   var now = new DateTime.now();
                   String rightNow= now.millisecondsSinceEpoch.toString();
                   HistoryTicket ht= HistoryTicket(
                       userBloc.clerk[ClerkFields.name],
                     placeId,
                     "error",
                       HistoryTicketFields.typePointsGiven,
                       guestId,
                       guestName,
                       startingPoints.toString(),
                       awardingPoints.toString(),
                       endingPoints.toString(),
                       subTotal.toString(),
                       userBloc.clerk[ClerkFields.name],
                       userBloc.clerk[ClerkFields.userId],
                       " ",
                       rightNow);

                   debugPrint("HistoryTicketCreated");

                   MyFirebase.createTicket(ht, guestId, placeId, userBloc.clerk[ClerkFields.userId]);
                   await MyFirebase.updatePoints(placeGuest, placeName, placeId);
                   Navigator.pop(context);
                   //todo reset edit text to empty string
                   cameraBloc.setResulGottem(false);
                   },
              ),
              RaisedButton(
                textColor: Colors.white,
                child: Text("no"),
                onPressed: () {
                    Navigator.pop(context);

                }
              )
            ],
          );
        }
    );
  }

  void discountPoints(BuildContext context, String transType)async{
      endingPoints = startingPoints + awardingPoints;
      placeGuest[PlaceGuestFields.points]=endingPoints;
      var now = new DateTime.now();
      String rightNow= now.millisecondsSinceEpoch.toString();
      HistoryTicket ht= HistoryTicket(
          userBloc.clerk[ClerkFields.name],
          placeId,
          "error",
          transType,
          guestId,
          guestName,
          startingPoints.toString(),
          awardingPoints.toString(),
          endingPoints.toString(),
          subTotal.toString(),
          userBloc.clerk[ClerkFields.name],
          userBloc.clerk[ClerkFields.userId],
          " ",
          rightNow);

      debugPrint("HistoryTicketCreated");

      MyFirebase.createTicket(ht, guestId, placeId, userBloc.clerk[ClerkFields.userId]);
      await MyFirebase.updatePoints(placeGuest, placeName, placeId);
      Navigator.pop(context);
      //todo reset edit text to empty string
      cameraBloc.setResulGottem(false);
  }

  Widget drawer(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Options'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Index'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Index()));
            },
          ),
          ListTile(
            title: Text('History Tickets'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryTicketsPage()));
            },
          ),
          ListTile(
            title: Text('Signout'),
            onTap: () {
              Navigator.pop(context);
              userBloc.signOut();
            },
          ),
        ],
      ),
    );
  }

  void redeemAlet(int amount, BuildContext context) {
    String dollars="";
    if(amount == Const.fiveDollars){
      dollars="5\$";
    }
    if(amount == Const.tenDollars){
      dollars="10\$";
    }
    if(amount == Const.twentieDollars){
      dollars="20\$";
    }
    showDialog(
        context:  context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Redeem $dollars ?"),
            actions: <Widget>[
              RaisedButton(
                child: Text("yes",style: TextStyle(color: Colors.white),),
                onPressed: (){
                  debugPrint("Yes on pressed called");
                  awardingPoints = -amount;
                  debugPrint("awardingPoints = $awardingPoints");
                  discountPoints(context, HistoryTicketFields.typePointsRedeemed);
                },
              ),
              RaisedButton(child: Text("no",style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.pop(context);

                  },
              )
            ],
          );

        });
  }
}




