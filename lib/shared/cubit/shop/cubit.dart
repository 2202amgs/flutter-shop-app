import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/cubit/shop/state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(InitialShopState());
}
