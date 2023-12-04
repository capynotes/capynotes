import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/viewmodel/auth/login/login_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.appbars_titles_login.tr(),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        bloc: context.read<LoginCubit>()..checkPrefs(),
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.router.replaceNamed("/note-generation");
          } else if (state is LoginError) {
            CustomSnackbars.displayErrorMotionToast(
                context, state.title, state.description, () {});
          }
        },
        builder: (context, state) {
          if (state is LoginFirstTime || state is LoginLoggedOut) {
            context.read<LoginCubit>().updatePrefRememberMe();
          }
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      controller: context.read<LoginCubit>().emailController,
                      label: LocaleKeys.text_fields_labels_email.tr(),
                      enabled: state is! LoginLoading,
                      customValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.validators_required.tr(
                              args: [LocaleKeys.text_fields_labels_email.tr()]);
                        } else if (!EmailValidator.validate(value)) {
                          return LocaleKeys.validators_invalid_email.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextFormField(
                        controller:
                            context.read<LoginCubit>().passwordController,
                        label: LocaleKeys.text_fields_labels_password.tr(),
                        isObscure: context.read<LoginCubit>().isObscure,
                        enabled: state is! LoginLoading,
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
                    CheckboxListTile(
                        value: (context.read<LoginCubit>().rememberMe),
                        onChanged: (value) {
                          context
                              .read<LoginCubit>()
                              .changeRememberMe(value ?? false);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(LocaleKeys.buttons_remember_me.tr())),
                    const SizedBox(height: 16.0),
                    (state is LoginLoading)
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login();
                              }
                            },
                            child: Text(LocaleKeys.buttons_login.tr()),
                          ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.labels_dont_have_an_account.tr()),
                        TextButton(
                          onPressed: () {
                            context.router.replaceNamed("/register");
                          },
                          child: Text(LocaleKeys.buttons_register.tr()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        context.router.push(const ForgotPasswordRoute());
                      },
                      child: Text(LocaleKeys.buttons_forgot_password.tr()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
