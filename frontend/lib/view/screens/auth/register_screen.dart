import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:capynotes/viewmodel/auth/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/auth/register_model.dart';
import '../../../navigation/app_router.dart';
import '../../widgets/custom_widgets/custom_snackbars.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();
  bool _agreeTerms = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            context.router.push(const LoginRoute());
          } else if (state is RegisterError) {
            CustomSnackbars.displayErrorMotionToast(
                context, state.title, state.description, () {});
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      label: "Name",
                      enabled: state is! RegisterLoading,
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextFormField(
                      controller: _surnameController,
                      label: "Surname",
                      enabled: state is! RegisterLoading,
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextFormField(
                      controller: _emailController,
                      label: "Email",
                      enabled: state is! RegisterLoading,
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextFormField(
                      controller: _passwordController,
                      label: "Password",
                      isObscure: true,
                      enabled: state is! RegisterLoading,
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
                        } else if (value != _verifyPasswordController.text) {
                          return "Passwords do not match";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextFormField(
                        controller: _verifyPasswordController,
                        label: "Verify Password",
                        isObscure: true,
                        enabled: state is! RegisterLoading,
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
                          } else if (value != _passwordController.text) {
                            return "Passwords do not match";
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeTerms = value ?? false;
                            });
                          },
                        ),
                        const Text('I agree to the terms and conditions'),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    (state is RegisterLoading)
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().registerModel =
                                    RegisterModel(
                                  name: _nameController.text,
                                  surname: _surnameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                context.read<RegisterCubit>().register();
                              }
                            },
                            child: const Text('Register'),
                          ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            context.router.push(const LoginRoute());
                          },
                          child: const Text('Login'),
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
