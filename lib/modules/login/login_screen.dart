import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/login_cubit.dart';
import 'package:shop_app/modules/login/cubit/login_state.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/components/global_components.dart';
import 'package:shop_app/shared/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passowrdController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.save(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                token = state.loginModel.data!.token;
                toast(
                  context,
                  state.loginModel.message.toString(),
                );
                navigateAndReplace(
                  context,
                  const ShopLayout(),
                );
              });
            } else {
              toast(
                context,
                state.loginModel.message.toString(),
                color: Colors.red,
              );
            }
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Login now to browse our hot offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      customTextField(
                        label: 'Email',
                        prefix: const Icon(Icons.email),
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Email Address';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      customTextField(
                        isPassword: LoginCubit.get(context).isPassword,
                        label: 'Password',
                        prefix: const Icon(Icons.lock),
                        suffix: IconButton(
                          onPressed: () {
                            LoginCubit.get(context).passwordVisibility();
                          },
                          icon: ConditionalBuilder(
                            condition: LoginCubit.get(context).isPassword,
                            builder: (context) =>
                                const Icon(Icons.visibility_off),
                            fallback: (context) => const Icon(Icons.visibility),
                          ),
                        ),
                        controller: passowrdController,
                        type: TextInputType.text,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (context) => customButton(
                          context,
                          text: 'LOGIN',
                          action: () {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passowrdController.text,
                              );
                            }
                          },
                        ),
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          TextButton(
                            child: const Text('REGISTER'),
                            onPressed: () {
                              navigateAndReplace(
                                context,
                                const RegisterScreen(),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
