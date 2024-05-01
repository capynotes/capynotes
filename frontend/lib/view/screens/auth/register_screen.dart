import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:capynotes/viewmodel/auth/register/register_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../../../translations/locale_keys.g.dart';
import '../../widgets/custom_widgets/custom_dialogs.dart';
import '../../widgets/custom_widgets/custom_snackbars.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _confirmFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.appbars_titles_register.tr()),
        centerTitle: true,
      ),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            CustomDialogs.showSuccessDialog(context, state.title,
                state.description, LocaleKeys.buttons_lets_go.tr(), () {
              context.router.replaceNamed("/login");
            });
          } else if (state is RegisterError) {
            CustomSnackbars.displayErrorMotionToast(
                context, state.title, state.description, () {});
          } else if (state is RegisterConfirm) {
            showDialog(
                context: context,
                builder: (context) {
                  return Form(
                    key: _confirmFormKey,
                    child: AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextFormField(
                              label: "Confirm Code",
                              controller: context
                                  .read<RegisterCubit>()
                                  .confirmationCodeController),
                          SizedBox(
                            height: 16.0,
                          ),
                          CustomElevatedButton(
                              child: Text("Confirm"),
                              onPressed: () {
                                context
                                    .read<RegisterCubit>()
                                    .amplifyConfirmUser(
                                        username: context
                                            .read<RegisterCubit>()
                                            .emailController
                                            .text,
                                        confirmationCode: context
                                            .read<RegisterCubit>()
                                            .confirmationCodeController
                                            .text);
                              })
                        ],
                      ),
                    ),
                  );
                });
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: context.read<RegisterCubit>().nameController,
                      label: LocaleKeys.text_fields_labels_name.tr(),
                      enabled: state is! RegisterLoading,
                    ),
                    CustomTextFormField(
                      controller:
                          context.read<RegisterCubit>().surnameController,
                      label: LocaleKeys.text_fields_labels_surname.tr(),
                      enabled: state is! RegisterLoading,
                    ),
                    CustomTextFormField(
                      controller: context.read<RegisterCubit>().emailController,
                      label: LocaleKeys.text_fields_labels_email.tr(),
                      enabled: state is! RegisterLoading,
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
                    CustomTextFormField(
                      controller:
                          context.read<RegisterCubit>().passwordController,
                      label: LocaleKeys.text_fields_labels_password.tr(),
                      isObscure: true,
                      enabled: state is! RegisterLoading,
                      customValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.validators_required.tr(args: [
                            LocaleKeys.text_fields_labels_password.tr()
                          ]);
                        } else if (value.length < 6) {
                          return LocaleKeys.validators_password_length.tr();
                        }
                        // Check if password is alphanumeric
                        else if (!RegExp(
                                r"^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$")
                            .hasMatch(value)) {
                          return LocaleKeys.validators_password_alphanumeric
                              .tr();
                        } // Check if the verify password == password
                        else if (value !=
                            context
                                .read<RegisterCubit>()
                                .verifyPasswordController
                                .text) {
                          return LocaleKeys.validators_password_match.tr();
                        } else {
                          return null;
                        }
                      },
                    ),
                    CustomTextFormField(
                        controller: context
                            .read<RegisterCubit>()
                            .verifyPasswordController,
                        label:
                            LocaleKeys.text_fields_labels_verify_password.tr(),
                        isObscure: true,
                        enabled: state is! RegisterLoading,
                        customValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.validators_required.tr(args: [
                              LocaleKeys.text_fields_labels_verify_password.tr()
                            ]);
                          } else if (value.length < 6) {
                            return LocaleKeys.validators_password_length.tr();
                          }
                          // Check if password is alphanumeric
                          else if (!RegExp(
                                  r"^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$")
                              .hasMatch(value)) {
                            return LocaleKeys.validators_password_alphanumeric
                                .tr();
                          } else if (value !=
                              context
                                  .read<RegisterCubit>()
                                  .passwordController
                                  .text) {
                            return LocaleKeys.validators_password_match.tr();
                          } else {
                            return null;
                          }
                        }),
                    CheckboxListTile(
                        value: context.read<RegisterCubit>().agreeTerms,
                        onChanged: (value) {
                          context.read<RegisterCubit>().changeTerms();
                        },
                        visualDensity: VisualDensity.compact,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(LocaleKeys.buttons_agree_terms.tr()),
                        subtitle: (state is RegisterNoTerms)
                            ? Text(
                                LocaleKeys.validators_terms_privacy.tr(),
                                style: const TextStyle(color: Colors.red),
                              )
                            : null),
                    (state is RegisterLoading)
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (context.read<RegisterCubit>().agreeTerms) {
                                  context.read<RegisterCubit>().register();
                                } else {
                                  context.read<RegisterCubit>().emitNoTerms();
                                }
                              }
                            },
                            child: Text(LocaleKeys.buttons_register.tr()),
                          ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.labels_already_have_an_account.tr()),
                        TextButton(
                          onPressed: () {
                            context.router.replaceNamed("/login");
                          },
                          child: Text(LocaleKeys.buttons_login.tr()),
                        ),
                      ],
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
