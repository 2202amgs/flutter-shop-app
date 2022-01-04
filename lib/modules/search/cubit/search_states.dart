import 'package:shop_app/models/chane_favourite_model.dart';

abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class SearchGetSuccesState extends SearchStates {}

class SearchGetErrorState extends SearchStates {}

class SearchGetLoadingState extends SearchStates {}

class SearchSuccessChangeFavouritesState extends SearchStates {
  final ChangeFavouriteModel changeFavouriteModel;

  SearchSuccessChangeFavouritesState(this.changeFavouriteModel);
}

class SearchErrorChangeFavouritesState extends SearchStates {}

class SearchReadyChangeFavouritesState extends SearchStates {}
