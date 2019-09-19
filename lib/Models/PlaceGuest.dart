// Created By Jose Ignacio Lara Arandia 2019/09/16/time:06:32

class PlaceGuest{
  PlaceGuest(this.uid,this.points,this.name);
  String uid, points, name;

}

class GuestPlace{
  String placeId, points, placeName;
  GuestPlace(this.placeId,this.points,this.placeName);
}


class GuestPlacesFields{
  static final String placeId= "place_id";
  static final String points = "points";
  static final String placeName = "place_name";
}

class PlaceGuestFields{
  static final String guestId= "guest_id";
  static final String points = "points";
  static final String guestName = "guest_name";
}
