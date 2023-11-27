import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:capynotes/viewmodel/auth/password/change_password/change_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            CustomSnackbars.displaySuccessMotionToast(
                context, state.title, state.description, () {});
          } else if (state is ChangePasswordError) {
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
                    controller: _currentPasswordController,
                    label: 'Current Password',
                    enabled: !(state is ChangePasswordLoading),
                    isObscure: true,
                  ),
                  CustomTextFormField(
                      controller: _newPasswordController,
                      label: 'New Password',
                      enabled: !(state is ChangePasswordLoading),
                      isObscure: true,
                      customValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        // Check if the verify password == password
                        else if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        // Check if password is alphanumeric
                        else if (!RegExp(
                                r"^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$")
                            .hasMatch(value)) {
                          return "Password must be alphanumeric";
                        } else if (value != _newPasswordController.text) {
                          return "Passwords do not match";
                        } else {
                          return null;
                        }
                      }),
                  CustomTextFormField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      enabled: !(state is ChangePasswordLoading),
                      isObscure: true,
                      customValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        // Check if the verify password == password
                        else if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        // Check if password is alphanumeric
                        else if (!RegExp(
                                r"^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$")
                            .hasMatch(value)) {
                          return "Password must be alphanumeric";
                        } else if (value != _confirmPasswordController.text) {
                          return "Passwords do not match";
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(height: 20.0),
                  (state is ChangePasswordLoading)
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                      .read<ChangePasswordCubit>()
                                      .changePasswordModel
                                      .oldPassword =
                                  _currentPasswordController.text;
                              context
                                  .read<ChangePasswordCubit>()
                                  .changePasswordModel
                                  .newPassword = _newPasswordController.text;
                              context
                                  .read<ChangePasswordCubit>()
                                  .changePassword();
                            }
                          },
                          child: const Text('Change Password'),
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
