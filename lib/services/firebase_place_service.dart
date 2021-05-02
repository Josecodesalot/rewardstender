import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rewards_network_shared/models/public_place.dart';
import 'package:rewards_network_shared/models/response.dart';
import 'package:rewardstender/Utils/Const.dart';
import 'package:rewardstender/services/place_service.dart';

class FirebasePlaceService extends PlaceService {
  final FirebaseDatabase firebaseDatabase;

  FirebasePlaceService(this.firebaseDatabase);

  DatabaseReference placeReference(String placeId) =>
      firebaseDatabase.reference().child(Const.places).child(placeId);

  @override
  Future<Response<PublicPlace>> getPublicPlace(String placeId) async{
    try{
      final placeResponse = await placeReference(placeId).once();
      if(placeResponse.value!=null){
        final place = PublicPlace.fromMap(Map.from(placeResponse.value));
        return Response(data: place);
      }else{
        throw ResponseException(message: 'No places were found, please try again');
      }
    } catch(d){
      return Response<PublicPlace>(
          data: null,
          error: ResponseError(d.toString()));
    }
  }
}
