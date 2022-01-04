import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop/cubit/cubit.dart';
import 'package:shop_app/layouts/shop/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/cubit/shop/cubit.dart';
import 'package:shop_app/shared/cubit/shop/state.dart';
import 'package:shop_app/shared/local/cache_helper.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();

  Widget start;
  token = CacheHelper.read(key: 'token');
  if (token != null) {
    start = const ShopLayout();
  } else if (CacheHelper.read(key: 'onBoarding') == null ||
      CacheHelper.read(key: 'onBoarding')) {
    start = const OnBoardingScreen();
  } else {
    start = const LoginScreen();
  }

  runApp(MyApp(
    start: start,
  ));
}

class MyApp extends StatelessWidget {
  final Widget start;
  const MyApp({Key? key, required this.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ShopCubit()),
        BlocProvider(
          create: (context) => ShopLayoutCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavouritesData()
            ..getUser(),
        ),
      ],
      child: BlocConsumer<ShopCubit, ShopState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            theme: light,
            home: start,
          );
        },
      ),
    );
  }
}
