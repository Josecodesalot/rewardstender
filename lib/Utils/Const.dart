class Const{

 //Poins System
 static final int minusFive=-5000;
 static final int fiveDollars = 5000;
 static final int tenDollars = 10000;
 static final int minusTen = -10000;
 static final int twentieDollars = 15000;
 static final int tenPercentDiscount = 1000;

 //-----------Trans History Path and String----------//

 //paths
 static final String historyPath = "trans_history";
     // String placename

 //fields
 static final String usersfield = "users";
 static final String username ="username";
 static final String time = "time";
 static final String restaurantId ="restaurantId";

 static final String userId="user_id";

//mainFields
 static final String usersMain = "users";
 static final String placesMain = "places";
 static final String costumers = "costuemers";
 static final String places = "places";
 static final String myPlaces = "my_places";
// Clerk
 static final String dateCreated = "time_created";

 //PlaceUser fields

 // staitic final username already defined;
 static final String email = "email";
// static final String userid ="user_id";
 static final String points = "points";

//TicketFields


    static final String type = "type";
    //subset of type
    static final String pointsAdded = "points_added";
    
 static final String costumerName = "costumer_name";
 static final String clerkName = "clerkName";
 static final String subtotal = "subtotal";
 static final String startingPoints = "starting_points";
 static final String newPoints = "new_points";
 static final String clerkId= "clerk_id";
 static final String comments = "comments";

 // dsoinasofn

 static final String placeImage = "placeImage";
 static final String placeId ="placeId";
 static final String placeName ="placeName";


}
class MainFields{
 static final String users = "users";
 static final String placesMain = "places";
 static final String costumers = "costuemers";
 static final String places = "places";
 static final String myPlaces = "my_places";
 static final String admins="admins";
 static final String clerks = "clerks";
 static final String placeRequest ="place_requests";
 static final String preRelease = "pre_release";
 static final String adminPlace = "admin_place";
 static final String issues = "issues";
 static final String feedBack ="feedback";
 static final String placeGuests = "place_guests";
 static final String guests = "guests";
 static final String placeClerks="place_clerks";
 static final String userPlaces="user_places";
 static final String guestPlaces = "guest_places" ;
 static final String historyTickets = "history_tickets";
 static final String guestTickets = "guest_tickets";
 static final String placeTickets="place_tickets";
 static final String  clerkTickets = "clerk_tickets";
 static final String replies = "replies";

}

class PlaceRequestField{
 static final placeRequest ="place_requests";
 static final name ="name";
 static final uid="uid";
 static final urlPic="url_pic";
 static final website="website";
 static final location ="location";
 static final descritpion="description";
 static final phoneNumber="phone_number";
 static final placeId="place_id";
 static final adminId="admin_id";
}

class ReleaseFields{
 static final placeRequest ="place_requests";
 static final name ="name";
 static final uid="uid";
 static final urlPic="url_pic";
 static final website="website";
 static final location ="location";
 static final descritpion="description";
 static final phoneNumber="phone_number";
 static final placeId="place_id";
 static final adminId="admin_id";
}

class AdminFields {

 static final String adminMainField = "admins";
 static final String name = "name";
 static final String userId = "user_id";
 static final String email = "email";
 static final String phone = "phone";
 static final String adress = "adress";
 static final String dateCreated = "date_created";
 static final String lastSignedIn = "lastSignedIn";
 static final String issues ="issues";

}

class UserFields{

 static final String userMainField="users";
 static final String username = "username";
 static final String email="email";
 static final String userId="user_id";
 static final String type="type";
 static final String accountCreatedOn="createdOn";
 static final String userTypeMaster="master";
 static final String userTypeClerk="clerk";
 static final String userTypeGuest="guest";
 static final String userTypeAdmin="admin";
 static final String userTypeNothing="nothing";

}

class PlaceInfoFields{
 static final placeInfoMainField ="place_info";
 static final name ="name";
 static final uid="uid";
 static final urlPic="url_pic";
 static final website="website";
 static final location ="location";
 static final descripion="description";
 static final phoneNumber="phone_number";
 static final placeId="place_id";
 static final adminId="admin_id";
}

class PlaceFields{
 static final placeInfoMainField ="place_info";
 static final name ="name";
 static final uid="uid";
 static final urlPic="url_pic";
 static final website="website";
 static final location ="location";
 static final descripion="description";
 static final phoneNumber="phone_number";
 static final placeId="place_id";
 static final adminId="admin_id";
}

class AdminPlaceFields {
 static final String mainField = "admin_place";
 static final String adminId="admin_id";
 static final String placeName ="place_name";
 static final String placeId ="place_id";
}

class PlaceType {
 static final String editPlace = "edit_place";
 static final String catalog = "catalog";
 static final String managePlace = "managePlace";
 static final String preReleases = "preRelease";
 static final String noPlace = "noPlace";
 static final String myPlace= "myPlace";
}

class ClerkFields {

 static final String mainField = "clerks";
 static final String name = "username";
 static final String dateCreated = "time_created";
 static final String degree = "degree";
 static final String clerk = "clerk";
 static final String placeId = "placeId";
 static final String placeName = "placeName";
 static final String email = "email";
 static final String userId = "userid";

}

class HistoryTicketFields{
 static final String guestName = "costumer_name";
 static final String comments = "comments";
 static final String guestId = "costumer_id";
 static final String startingPoints = "points_start";
 static final String awardingPoints = "points_awarding";
 static final String endingPoints = "points_ending";
 static final String subTotal = "subtotal";
 static final String clerkName = "clerk_name";
 static final String clerkId = "clerk_id";
 static final String time = "time";
 static final String key = "key";
 static final String type = "type";
 static final String from = "from";

 //types
 static final String typePointsGiven = "points_given";
 static final String typePointsRedeemed = "points_redeemed";
 static final String typePointsAdjusted = "points_adjusted";

static final String placeId = "place_id"; }

class GuestFields{
 static final String timeCreated = "time_created";
 static final String userId = "user_id";
 static final String name = "username";
 static final String email = "email";
}