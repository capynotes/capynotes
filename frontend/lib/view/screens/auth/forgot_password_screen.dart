import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/viewmodel/auth/password/forgot_password/forgot_password_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../translations/locale_keys.g.dart';
import '../../widgets/custom_widgets/custom_text_form_field.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.appbars_titles_forgot_password.tr()),
      ),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            CustomSnackbars.displaySuccessMotionToast(
                context, state.title, state.description, () {});
          } else if (state is ForgotPasswordError) {
            CustomSnackbars.displayErrorMotionToast(
                context, state.title, state.description, () {});
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _emailController,
                    label: LocaleKeys.text_fields_labels_email.tr(),
                    enabled: state is! ForgotPasswordLoading,
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
                  const SizedBox(height: 20.0),
                  (state is ForgotPasswordLoading)
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<ForgotPasswordCubit>()
                                  .forgotPassword(
                                    _emailController.text,
                                  );
                            }
                          },
                          child: Text(LocaleKeys.buttons_reset_password.tr()),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
