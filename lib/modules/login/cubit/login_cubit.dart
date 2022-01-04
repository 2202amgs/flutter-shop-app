import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/login_state.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/remote/end_points.dart';

class LoginCubit extends Cubit<LoginState> {
  // base
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  // login

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      user = LoginModel.fromJson(value.data);
      emit(LoginSuccessState(user!));
    }).catchError((error) {
      emit(LoginErrorState(error));
    });
  }

  // Password secure
  bool isPassword = true;
  void passwordVisibility() {
    isPassword = !isPassword;
    emit(LoginPasswordVisibilityState());
  }
}
