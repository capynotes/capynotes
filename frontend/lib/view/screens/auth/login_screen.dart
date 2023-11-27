import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/viewmodel/auth/login/login_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../navigation/app_router.dart';
import '../../../translations/locale_keys.g.dart';
import '../../widgets/custom_widgets/custom_text_form_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.appbars_titles_login.tr())),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.router.push(const NoteGenerationRoute());
          } else if (state is LoginError) {
            CustomSnackbars.displayErrorMotionToast(
                context, state.title, state.description, () {});
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFormField(
                  controller: context.read<LoginCubit>().emailController,
                  label: "Email",
                  enabled: !(state is LoginLoading),
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                    controller: context.read<LoginCubit>().passwordController,
                    label: "Password",
                    isObscure: context.read<LoginCubit>().isObscure,
                    enabled: !(state is LoginLoading),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () {
                          context.read<LoginCubit>().changeVisible();
                        },
                        icon: Icon(
                          context.read<LoginCubit>().isObscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    )),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.router.push(const ForgotPasswordRoute());
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                (state is LoginLoading)
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          context.read<LoginCubit>().login();
                        },
                        child: const Text('Login'),
                      ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        context.router.push(const RegisterRoute());
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
