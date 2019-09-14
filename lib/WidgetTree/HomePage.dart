import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/BusinessLogic/Reward.dart';
import 'package:rewardstender/CloudServices/FirebaseMethod.dart';
import 'package:rewardstender/Models/ClerkUser.dart';
import 'package:rewardstender/Models/Costumer.dart';
import 'package:rewardstender/Models/HistoryTicket.dart';
import 'package:rewardstender/Models/Place.dart';
import 'package:rewardstender/Models/User.dart';
import 'package:rewardstender/Provider/UserBloc.dart';
import 'package:rewardstender/Utils/Const.dart';
import 'dart:math' as math;
import 'package:rewardstender/Utils/fieldFormat.dart';
import 'package:rewardstender/WidgetTree/Index.dart';


class HomePage extends StatefulWidget {

  //vars

  final String error1 = "Camera permission was denied";
  final String error2 = "Unknown Error ";
  final String error3= "You pressed the back button before scanning anything";
  final myController =  TextEditingController();

  //shows results in mainpage
  bool resultGotten = false;
  String result;

  //models
  Place place;
  Costumer costumer;
  Clerk clerk = ClerkTools.developerCleck();
  HistoryTicket ticket = TicketTools.getNonNullHistoryTicket();


  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = "Hey there !";
  UserBloc userBloc;
  //method which initiates the QR scanner

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan().then((value){
        setState(() {
          widget.resultGotten = true;
          widget.result = value.toString();
        });
        return value;
        });
      return qrResult.toString();
    }

    on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        return widget.error1;
      } else {
        print(widget.error2 + ex.toString());
        return widget.error2;
      }
    } on FormatException {
      return widget.error3;
    } catch (ex) {
      print(widget.error2 + ex.toString());
      return widget.error2;
    }
  }

  @override
  Widget build(BuildContext context) {
     userBloc = Provider.of<UserBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      drawer: drawer(),
      body: Center(
        child: Content(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget Content() {
    if (!widget.resultGotten) {

      return Text("Ready To Scan Something for you");
    }else{

      if(widget.result!=widget.error1&&widget.result!=widget.error2&&widget.result!=widget.error3){
        return getUserInfo(widget.result);

      }else{
        return Text("error " + widget.result + " please try again");
      }
    }
  }

  Future getPlace(String code){
    return FirebaseDatabase
        .instance.reference()
        .child(Const.costumers)
        .child(code)
        .child(widget.clerk.placeName)
        .child(code)
        .once();
  }

  Widget getUserInfo (String uid){
    return FutureBuilder(
      future: MyFirebase.ref.child(Const.costumers).child(widget.clerk.placeName).child(uid).once(),
      //the above reference doesnt exist, to test handling for error
      builder: (_,data){
        DataSnapshot snap = data.data;
        if(data.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }else {

          if (snap.value != null) {
            print("User Found");
            return CurrenUserDataAndPoins(snap);
          } else {
            print("id not associated with this place, checking if user exists.");
            return _handleUserNotAssociated(uid);
          }
        }
       }
      );
  }

  Widget _handleUserNotAssociated(String uid){
    return FutureBuilder(
      future: MyFirebase.ref.child(Const.usersfield).child(uid).once(),
      builder: (_,data){
        DataSnapshot snap =  data.data;
        if (data.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }else if (snap.value!=null){
          hookUserUpWithPlace(snap);
          return Text("User found, but not associated, gt this code working, 165 line");
        } else{
          return Text(" User not found, please try scanning again");
        }
      }
    );
  }

  void hookUserUpWithPlace(DataSnapshot snapshot){
    print("hookUserUpWithPlace");
    User user = UserTools.getNewUserFromSnapShot(snapshot);
    MyFirebase.associateUserWithPlace(user, widget.clerk.placeName).then((onValue){
      print("user aquired");
      setState(() {
        widget.result=user.userid;
        widget.resultGotten=true;
      });
    });
  }

  Widget CurrenUserDataAndPoins(snap){
    widget.costumer = CostumerTools.getCostumerFromSnapshot(snap);
    double points = double.parse(widget.costumer.points);
    widget.ticket.startingPoints = widget.costumer.points;
    widget.ticket.costumer=widget.costumer.username;

    if (points<Const.fiveDollars){
      return _GivePoints();

    }else if ( points> Const.fiveDollars && points < Const.tenDollars){
      return _redeemFive();
    }
    else if (points > Const.tenDollars){
      return _redeemUpToTen();
    }
  }


  Widget _redeemFive() {
    return Column(
      children: <Widget>[
        _GivePoints(),
        RaisedButton(
          child: Text(" Discount 5 dollars " ),
          onPressed: (){
            _discountDialog(Const.minusFive);
          }
        ),
      ],
    );
  }

  void _discountDialog(int redeemedPoints){
    print("will this enable the button?");
    String title = "error please re scan";
    if (redeemedPoints==Const.minusFive){
      title = "Give 5 dollar discount, then input total here";
    }else if (redeemedPoints==Const.minusTen){
      title = "Give 10 dollar discount, then input total here";
    }else{
      title = "error please re scan";
    }

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              RaisedButton(
                textColor: Colors.white,
                child: Text(
                  "yes",
                ),
                onPressed:(){

                  addPointsToWidgetUser(redeemedPoints);
                  dismissDialog();

                },
              ),
              RaisedButton(
                textColor: Colors.white,
                child: Text("no"),
                onPressed: (){
                  setState(){
                    
                    widget.resultGotten =  false;
                  }
                },
              )
            ],
          );
        }
    );
  }


  Widget _redeemUpToTen() {
    return Column(
      children: <Widget>[
        _redeemFive(),
        RaisedButton(
          child: Text(" Discount 10 dollars"),
          onPressed: (){_discountDialog(Const.minusTen);},
        )
      ],
    );
  }

  void _tenDollarsOff(){
    addPointsToWidgetUser(Const.minusTen);
  }

  Widget _GivePoints (){

    return  Column(
      children: <Widget>[

        Text(widget.costumer.username),
        Text(widget.costumer.email),
        Text(widget.costumer.points),

        TextFormField(
          controller: widget.myController,
          decoration: InputDecoration(
              hintText: 'SubTotal'
          ),
          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        RaisedButton(
            child: Text("GivePoints"),
            onPressed: (){
              return _showDialog( double.parse(widget.myController.text));
              //    _givePoints(double.parse(myController.text));
            }
        ),
      ],
    );
  }

  void _showDialog(double subTotal){
    widget.ticket.subTotal = subTotal.toString();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Are you sure you want to add $subTotal to the your points?"),
            actions: <Widget>[
              RaisedButton(
                textColor: Colors.white,
                child: Text(
                  "yes",
                ),
                onPressed:(){
                  _putPointsBysubTotal(subTotal);
                  dismissDialog();
                },
              ),
              RaisedButton(
                textColor: Colors.white,
                child: Text("no"),
                onPressed: (){
                  setState(){
                    widget.resultGotten =  false;
                  }
                },
              )
            ],
          );
        }
    );
  }

  void _putPointsBysubTotal(double subTotal){
    int addingPoints = Reward.getPointsBySubtotal(subTotal);
    addPointsToWidgetUser( addingPoints);
  }


  Widget pointButtons(String Points){
    int points = Points as int;
    if (points>Const.tenDollars){
      return Column(children: <Widget>[
        RaisedButton(
          child: Text("10 dollar discount"),
          onPressed: null
        )
      ],
      );
    }else{
      return Text("Not enough Points");
    }
  }

  void givePoints(double subTotal){

  }

  //----------This Method Decides the Point Scheme---------//


  void addPointsToWidgetUser(int addedPoints){
    print("UpdatedPoints = $addedPoints");
    int currentPoints = int.parse(widget.costumer.points);
    int newPoints = currentPoints + addedPoints;
    widget.ticket.newPoints = "$newPoints";
    widget.ticket.type = "points_added";
    widget.costumer.points= "$newPoints";
    print("poins updated " + widget.costumer.points);
    MyFirebase.finalizeTransaction(widget.costumer, widget.clerk, widget.ticket);
  }

  //replace developerClerk with a call to the User, who will have a special clerk account.

  void dismissDialog(){
    widget.myController.clear();
    setState(() {
      widget.resultGotten=false;
    });
    Navigator.of(context).pop();
  }

  Widget drawer(){
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
  }

