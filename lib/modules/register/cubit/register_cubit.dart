import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register/cubit/register_state.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/remote/end_points.dart';

class RegisterCubit extends Cubit<RegisterState> {
  // base
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  // Register

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      user = LoginModel.fromJson(value.data);
      emit(RegisterSuccessState(user!));
    }).catchError((error) {
      emit(RegisterErrorState(error));
    });
  }

  // Password secure
  bool isPassword = true;
  void passwordVisibility() {
    isPassword = !isPassword;
    emit(RegisterPasswordVisibilityState());
  }
}
