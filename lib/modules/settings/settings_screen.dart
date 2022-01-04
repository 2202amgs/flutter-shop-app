import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop/cubit/cubit.dart';
import 'package:shop_app/layouts/shop/cubit/staties.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/components/global_components.dart';
import 'package:shop_app/shared/local/cache_helper.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    return BlocConsumer<ShopLayoutCubit, ShopLayoutState>(
      listener: (context, state) {
        if (state is ShopLayoutSuccessUpdateProfileState) {
          toast(
            context,
            state.loginModel.message!,
            color: state.loginModel.status! ? Colors.green : Colors.red,
          );
        } else if (state is ShopLayoutErrorUpdateProfileState) {
          toast(
            context,
            state.error,
            color: Colors.red,
          );
        }
      },
      builder: (context, state) {
        ShopLayoutCubit cubit = ShopLayoutCubit.get(context);
        if (user != null && user!.status!) {
          nameController.text = user!.data!.name!;
          emailController.text = user!.data!.email!;
          phoneController.text = user!.data!.phone!;
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConditionalBuilder(
            condition: user != null,
            builder: (context) => Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is ShopLayoutLoadingUpdateProfileState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  customTextField(
                    label: 'name',
                    prefix: const Icon(Icons.person),
                    controller: nameController,
                    type: TextInputType.text,
                    validator: (value) {
                      if (value == null) {
                        return 'Name Is Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  customTextField(
                    label: 'Email',
                    prefix: const Icon(Icons.email),
                    controller: emailController,
                    type: TextInputType.text,
                    validator: (value) {
                      if (value == null) {
                        return 'Name Is Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  customTextField(
                    label: 'Phone',
                    prefix: const Icon(Icons.mobile_screen_share),
                    controller: phoneController,
                    type: TextInputType.text,
                    validator: (value) {
                      if (value == null) {
                        return 'Name Is Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  customButton(context, text: 'UPDATE', action: () {
                    if (formKey.currentState!.validate()) {
                      cubit.updateUser(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      );
                    }
                  }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  customButton(context, bgColor: Colors.red, text: 'LOGOUT',
                      action: () {
                    CacheHelper.remove(key: 'token').then((value) {
                      if (value) {
                        user = null;
                        token = null;
                        navigateAndReplace(context, const LoginScreen());
                      }
                    });
                  }),
                ],
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
