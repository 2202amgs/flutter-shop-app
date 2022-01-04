import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop/cubit/staties.dart';
import 'package:shop_app/models/FavouritesModel.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/chane_favourite_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favourites/favourites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/remote/end_points.dart';

class ShopLayoutCubit extends Cubit<ShopLayoutState> {
  ShopLayoutCubit() : super(ShopLayoutInitialState());

  static ShopLayoutCubit get(context) => BlocProvider.of(context);

  // bottom navbar
  int currentIndex = 0;

  List<Widget> screens = const [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingScreen(),
  ];

  List<String> titles = [
    'Home',
    'Categories',
    'Favourites',
    'Settings',
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangBottomNavState());
  }

  // home get data
  HomeModel? homeData;

  void getHomeData() {
    emit(ShopLayoutLoadingHomeState());
    DioHelper.getData(
      url: Home,
      token: token!,
    ).then(
      (value) {
        homeData = HomeModel.fromJson(value.data);
        homeData!.data!.products.forEach((value) {
          favourites.addAll({value.id!: value.inFavorites!});
        });
        emit(ShopLayoutSuccessHomeState());
      },
    ).catchError(
      (error) {
        emit(ShopLayoutErrorHomeState());
      },
    );
  }

  // categories get data
  CategoriesModel? categoriesData;

  void getCategoriesData() {
    emit(ShopLayoutLoadingCategoriesState());
    DioHelper.getData(
      url: CATEGORIES,
    ).then(
      (value) {
        categoriesData = CategoriesModel.fromJson(value.data);
        emit(ShopLayoutSuccessCategoriesState());
      },
    ).catchError(
      (error) {
        emit(ShopLayoutErrorCategoriesState());
      },
    );
  }

  // Favourites

  void changeFoavourites(int id) {
    print(token);
    favourites[id] = !favourites[id]!;

    emit(ShopLayoutReadyChangeFavouritesState());
    DioHelper.postData(
      url: FAVOURITES,
      data: {
        "product_id": id,
      },
      token: token,
    ).then(
      (value) {
        changeFavouriteModell = ChangeFavouriteModel.fromJson(value.data);
        if (value.data['status'] == false) {
          favourites[id] = !favourites[id]!;
        } else {
          getFavouritesData();
        }
        emit(ShopLayoutSuccessChangeFavouritesState(changeFavouriteModell!));
      },
    ).catchError(
      (error) {
        favourites[id] = !favourites[id]!;
        emit(ShopLayoutErrorChangeFavouritesState());
      },
    );
  }

  // Favourites get data
  void getFavouritesData() {
    emit(ShopLayoutLoadingFavouritesState());
    DioHelper.getData(
      url: FAVOURITES,
      token: token.toString(),
    ).then(
      (value) {
        favouritesModel = FavouritesModel.fromJson(value.data);
        emit(ShopLayoutSuccessFavouritesState());
      },
    ).catchError(
      (error) {
        emit(ShopLayoutErrorFavouritesState());
      },
    );
  }

  // User get and update data

  void getUser() {
    emit(ShopLayoutLoadingProfileState());
    DioHelper.getData(
      url: PROFILE,
      token: token.toString(),
    ).then(
      (value) {
        user = LoginModel.fromJson(value.data);
        emit(ShopLayoutSuccessProfileState());
      },
    ).catchError(
      (error) {
        emit(ShopLayoutErrorProfileState());
      },
    );
  }

  void updateUser({
    required String name,
    required String email,
    // required String password,
    required String phone,
  }) {
    emit(ShopLayoutLoadingUpdateProfileState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token.toString(),
      data: {
        'name': name,
        'email': email,
        // 'password': password,
        'phone': phone,
      },
    ).then(
      (value) {
        user = LoginModel.fromJson(value.data);
        if (user != null) {
          emit(ShopLayoutSuccessUpdateProfileState(user!));
        }
      },
    ).catchError(
      (error) {
        emit(ShopLayoutErrorUpdateProfileState(error.toString()));
      },
    );
  }
}
