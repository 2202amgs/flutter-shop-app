import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/FavouritesModel.dart';
import 'package:shop_app/models/chane_favourite_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/search_states.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/remote/end_points.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  // get search data
  SearchModel? searchModel;
  void getSearchData({
    required String word,
  }) {
    emit(SearchGetLoadingState());
    DioHelper.postData(
      url: SEARCH,
      data: {
        'text': '${word}',
      },
    ).then(
      (value) {
        print('object');
        searchModel = SearchModel.fromJson(value.data);
        print(searchModel!.allData!.data[0].name);
        emit(SearchGetSuccesState());
      },
    ).catchError(
      (error) {
        print(error);
        emit(SearchGetErrorState());
      },
    );
  }

  void changeFoavourites(int id) {
    print(token);
    favourites[id] = !favourites[id]!;

    emit(SearchReadyChangeFavouritesState());
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
          DioHelper.getData(
            url: FAVOURITES,
            token: token.toString(),
          ).then(
            (value) {
              favouritesModel = FavouritesModel.fromJson(value.data);
            },
          ).catchError(
            (error) {},
          );
        }
        emit(SearchSuccessChangeFavouritesState(changeFavouriteModell!));
      },
    ).catchError(
      (error) {
        favourites[id] = !favourites[id]!;
        emit(SearchErrorChangeFavouritesState());
      },
    );
  }
}
