import 'package:shop_app/models/chane_favourite_model.dart';
import 'package:shop_app/models/login_model.dart';

abstract class ShopLayoutState {}

class ShopLayoutInitialState extends ShopLayoutState {}

class ShopChangBottomNavState extends ShopLayoutState {}

class ShopLayoutLoadingHomeState extends ShopLayoutState {}

class ShopLayoutSuccessHomeState extends ShopLayoutState {}

class ShopLayoutErrorHomeState extends ShopLayoutState {}

class ShopLayoutLoadingCategoriesState extends ShopLayoutState {}

class ShopLayoutSuccessCategoriesState extends ShopLayoutState {}

class ShopLayoutErrorCategoriesState extends ShopLayoutState {}

class ShopLayoutSuccessChangeFavouritesState extends ShopLayoutState {
  final ChangeFavouriteModel changeFavouriteModel;

  ShopLayoutSuccessChangeFavouritesState(this.changeFavouriteModel);
}

class ShopLayoutErrorChangeFavouritesState extends ShopLayoutState {}

class ShopLayoutReadyChangeFavouritesState extends ShopLayoutState {}

class ShopLayoutLoadingFavouritesState extends ShopLayoutState {}

class ShopLayoutSuccessFavouritesState extends ShopLayoutState {}

class ShopLayoutErrorFavouritesState extends ShopLayoutState {}

class ShopLayoutLoadingProfileState extends ShopLayoutState {}

class ShopLayoutSuccessProfileState extends ShopLayoutState {}

class ShopLayoutErrorProfileState extends ShopLayoutState {}

class ShopLayoutLoadingUpdateProfileState extends ShopLayoutState {}

class ShopLayoutSuccessUpdateProfileState extends ShopLayoutState {
  final LoginModel loginModel;

  ShopLayoutSuccessUpdateProfileState(this.loginModel);
}

class ShopLayoutErrorUpdateProfileState extends ShopLayoutState {
  final String error;

  ShopLayoutErrorUpdateProfileState(this.error);
}
