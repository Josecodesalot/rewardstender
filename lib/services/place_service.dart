import 'package:rewards_network_shared/models/public_place.dart';
import 'package:rewards_network_shared/models/response.dart';

abstract class PlaceService{
  Future<Response<PublicPlace>> getPublicPlace(String placeId);
}

