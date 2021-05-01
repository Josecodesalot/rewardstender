import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rewards_network_shared/models/auth_fields.dart';
import 'package:rewards_network_shared/models/clerk.dart';
import 'package:rewardstender/services/FirebaseReferences.dart';
import 'package:rewardstender/Models/HistoryTicket.dart';
import 'package:rewardstender/Models/PlaceGuest.dart';
import 'package:rewardstender/Utils/Const.dart';

class MyFirebase {
  static final ref = FirebaseDatabase.instance.reference();

  static Future getUsername(String uid) {
    debugPrint("getUsernameCalled");
    return FirebaseDatabase.instance
        .reference()
        .child(Const.userId)
        .child(uid)
        .once();
  }

  static Future<ClerkAccount> getClerk(String uid) async {
    debugPrint("Firebase getClerk Called");
    DataSnapshot snap =
        await MyRefs.db.child(MainFields.clerks).child(uid).once();

    debugPrint("past the first herdle");
    if (snap.value != null) {
      return ClerkAccount.fromMap(Map.from(snap.value));
    } else {
      return ClerkAccount();
    }
  }

  static Future<ClerkAccount> createClerk(AuthFields authFields, ClerkAccount clerk) async {
    debugPrint("Firebase getClerk Called");
    final auth = FirebaseAuth.instance;

    final result = await auth.createUserWithEmailAndPassword(
        email: authFields.email, password: authFields.password);

    final newlyCreatedGuest = clerk.copyWith(
        uid: result.user.uid,
        email: result.user.email,
        dateCreated: '${DateTime.now().millisecondsSinceEpoch}');

    await MyRefs.db
        .child(MainFields.clerks)
        .child(clerk.uid)
        .set(newlyCreatedGuest.toMap());

    return newlyCreatedGuest;
  }

  static Future<Map> getUser(String uid) async {
    debugPrint("Firebase get User called");
    DataSnapshot snap = await MyRefs.getUser(uid).once();

    if (snap.value != null) {
      return Map.from(snap.value);
    } else {
      return Map();
    }
  }

  static Future getHistoryTickets(String placeId, String clerkId) async {
    debugPrint("Firebase GetHistoryTickets Called");
    DataSnapshot snap = await MyRefs.getHistoryList(placeId, clerkId).once();
    if (snap.value != null) {
      return Map.from(snap.value).values.toList();
    } else {
      return [];
    }
  }

  static Future<Map> getGuest(String uid) async {
    debugPrint("Firebase Get guestCalled");
    DataSnapshot snapshot =
        await MyRefs.db.child(MainFields.guests).child(uid).once();
    if (snapshot != null) {
      return Map.from(snapshot.value);
    } else {
      return {};
    }
  }

  static Future<void> updatePoints(
      Map placeGuest, String placeName, placeId) async {
    debugPrint("Firebase updatePoints called");
    Map guestPlace = Map();
    guestPlace[GuestPlacesFields.points] = placeGuest[PlaceGuestFields.points];
    guestPlace[GuestPlacesFields.placeName] = placeName;
    guestPlace[GuestPlacesFields.placeId] = placeId;
    String guestId = placeGuest[PlaceGuestFields.guestId];

    MyRefs.db
        .child(MainFields.placeGuests)
        .child(placeId)
        .child(guestId)
        .set(placeGuest);
    await MyRefs.db
        .child(MainFields.guestPlaces)
        .child(guestId)
        .child(placeId)
        .set(guestPlace);
  }

  static void createTicket(
      HistoryTicket ht, String guestId, String placeId, String clerkId) async {
    debugPrint("create tickets called");
    String key = MyRefs.db.push().key.toString();
    ht.key = key;

    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());

    Map ticketDirectory = Map();
    ticketDirectory[HistoryTicketFields.key] = key;
    debugPrint(ticketDirectory.toString());
    Map historyTicketMap = HistoryTicketTools.toMap(ht);

    MyRefs.db.child(MainFields.historyTickets).child(key).set(historyTicketMap);
    MyRefs.db
        .child(MainFields.guestTickets)
        .child(guestId)
        .child(date)
        .child(key)
        .set(ticketDirectory);
    MyRefs.db
        .child(MainFields.clerkTickets)
        .child(clerkId)
        .child(date)
        .child(key)
        .set(ticketDirectory);
    MyRefs.db
        .child(MainFields.placeTickets)
        .child(placeId)
        .child(date)
        .child(key)
        .set(ticketDirectory);
    debugPrint("Method finalized");
  }

  static Future<List> getTickets(String clerkId, String date) async {
    debugPrint("Firebase Get tickets called date = " + date);
    DataSnapshot snap = await MyRefs.db
        .child(MainFields.clerkTickets)
        .child(clerkId)
        .child(date)
        .once();
    List keys = List();
    List tickets = List();
    if (snap.value != null) {
      debugPrint("Firebase get tickets snap value not null");
      keys = Map.from(snap.value).keys.toList();
      debugPrint("keys =" + keys.toString());
      for (int i = 0; i < keys.length; i++) {
        debugPrint("Firebase get tickets i= $i");
        DataSnapshot dataSnapshot = await MyRefs.db
            .child(MainFields.historyTickets)
            .child(keys[i])
            .once();
        if (dataSnapshot.value != null) {
          tickets.add(Map.from(dataSnapshot.value));
        }
      }
      return tickets;
    } else {
      return List();
    }
  }

  static Future<void> createIssue(Map ticket, String date) async {
    debugPrint("Firebase Create Issue Called");
    String key = ticket[HistoryTicketFields.key];
    String clerkId = ticket[HistoryTicketFields.clerkId];
    String placeId = ticket[HistoryTicketFields.placeId];

    debugPrint("key $key clerkId $clerkId placeId $placeId");

    Map ticketDirectory = Map();
    ticketDirectory[HistoryTicketFields.key] = key;

    MyRefs.db.child(MainFields.historyTickets).child(key).set(ticket);
    MyRefs.db
        .child(MainFields.clerkTickets)
        .child(clerkId)
        .child(date)
        .child(key)
        .set(ticketDirectory);
    MyRefs.db
        .child(MainFields.placeTickets)
        .child(placeId)
        .child(date)
        .child(key)
        .set(ticketDirectory);

    //cerateIssue
    MyRefs.db.child(MainFields.issues).child(placeId).child(key).set(ticket);
  }

  static Future<void> addCommentToHistory(Map ticket, String date) async {
    debugPrint("Firebase Add Comment To History Callerd");
    String guestId = ticket[HistoryTicketFields.guestId];
    String key = ticket[HistoryTicketFields.key];
    String clerkId = ticket[HistoryTicketFields.clerkId];
    String placeId = ticket[HistoryTicketFields.placeId];

    debugPrint("key $key clerkId $clerkId placeId $placeId guestId $guestId");

    Map ticketDirectory = Map();
    ticketDirectory[HistoryTicketFields.key] = key;

    MyRefs.db.child(MainFields.historyTickets).child(key).set(ticket);

    MyRefs.db
        .child(MainFields.guestTickets)
        .child(guestId)
        .child(date)
        .child(key)
        .set(ticketDirectory);
    MyRefs.db
        .child(MainFields.clerkTickets)
        .child(clerkId)
        .child(date)
        .child(key)
        .set(ticketDirectory);
    MyRefs.db
        .child(MainFields.placeTickets)
        .child(placeId)
        .child(date)
        .child(key)
        .set(ticketDirectory);
  }
}
