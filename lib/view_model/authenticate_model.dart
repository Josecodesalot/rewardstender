import 'package:flutter/material.dart';
import 'package:rewards_network_shared/models/public_place.dart';
import 'package:rewardstender/services/place_service.dart';

enum PlaceFetchState{
  unInitiated,
  loading,
  completed,
  failed,
}

class AuthenticateModel extends ChangeNotifier {
  AuthenticateModel({@required this.placeService}){
    nameController = TextEditingController()..addListener(() {
      notifyListeners();
    });
  }

  final PlaceService placeService;

  bool get fetchCompleted => _state == PlaceFetchState.completed;

  Future findPlace(String placeId) async {
    state = PlaceFetchState.loading;
    final findPlaceResponse = await placeService.getPublicPlace(placeId);
    if (!findPlaceResponse.hasError) {
      publicPlace = findPlaceResponse.data;
      state = PlaceFetchState.completed;
    }else{
      state = PlaceFetchState.failed;
    }
  }

  TextEditingController nameController;
  PageController pageController  = PageController();
  FocusNode focusNode = FocusNode();

  PlaceFetchState _state = PlaceFetchState.unInitiated;
  PublicPlace _publicPlace;

  PlaceFetchState get state => _state;
  PublicPlace get publicPlace => _publicPlace;

  set state(PlaceFetchState fetchState){
    _state = fetchState;
    notifyListeners();
  }

  set publicPlace(PublicPlace place) {
    _publicPlace = place;
    notifyListeners();
  }
}
