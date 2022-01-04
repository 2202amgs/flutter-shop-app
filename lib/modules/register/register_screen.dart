import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/register/cubit/register_cubit.dart';
import 'package:shop_app/modules/register/cubit/register_state.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/components/global_components.dart';
import 'package:shop_app/shared/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (BuildContext context, state) {
          if (state is RegisterSuccessState) {
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
        builder: (BuildContext context, state) => Scaffold(
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
                        'REGISTER',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Register now to browse our hot offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      customTextField(
                        label: 'Name',
                        prefix: const Icon(Icons.person_outline),
                        controller: nameController,
                        type: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Name';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      customTextField(
                        label: 'Email',
                        prefix: const Icon(Icons.email_outlined),
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Email Address';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      customTextField(
                        isPassword: RegisterCubit.get(context).isPassword,
                        label: 'Password',
                        prefix: const Icon(Icons.lock_outline),
                        suffix: IconButton(
                          onPressed: () {
                            RegisterCubit.get(context).passwordVisibility();
                          },
                          icon: RegisterCubit.get(context).isPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        controller: passwordController,
                        type: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      customTextField(
                        label: 'Phone',
                        prefix: const Icon(Icons.phone_android_outlined),
                        controller: phoneController,
                        type: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Phone Number';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => customButton(
                          context,
                          text: 'REGISTER',
                          action: () {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                        ),
                        fallback: (context) => const Center(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Alredy have an account?'),
                          TextButton(
                            child: const Text('LOGIN'),
                            onPressed: () {
                              navigateAndReplace(
                                context,
                                const LoginScreen(),
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
