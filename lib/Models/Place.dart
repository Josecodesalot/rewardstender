import 'package:firebase_database/firebase_database.dart';
import 'package:rewardstender/Utils/Const.dart';

class Place {
  String placeId, placeImage, placeName;

  Place(this.placeId, this.placeImage,
      this.placeName);

  @override
  String toString() {
    return 'Place{restaurantId: $placeId, restaurantImage: $placeImage, restaurantName: $placeName}';
  }
}

class PlaceTools {
  List<Place> placesFromSnapShot(DataSnapshot snap){
    List<Place> places = new List();
    Map map = new Map<String, dynamic>.from(snap.value);
    List<String> keys =  map.keys.toList();

    for (int i=0; i< map.length;i++){

      places.add(
          new Place(
            map[keys[i]][Const.placeId],
            map[keys[i]][Const.placeImage],
            map[keys[i]][Const.placeName],
          ));}

    print(places.toString());
    return places;
  }
}