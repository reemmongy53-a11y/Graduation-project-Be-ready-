import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/custom/validation.dart';
import 'package:new_project/data_logIn/login_cubit.dart';
import 'package:new_project/data_logIn/login_state.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/routes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<LoginCubit, LoginState>(
            listener: (context, state) async {
              if (state is LoginLoadingState) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is LoginSuccessState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                UserSession.token = state.authResult.token;
                UserSession.name = state.authResult.user.name;
                UserSession.role = state.authResult.user.role;
                UserSession.email = state.authResult.user.email;
                UserSession.employeeId = state.authResult.user.id;
                await UserSession.save();

                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.mainScreen.name,
                );
              } else if (state is LoginErrorState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),

                      AppFormField(
                        controller: emailController,
                        label: AppLocalizations.of(context)!.email,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text?.trim().isEmpty == true)
                            return AppLocalizations.of(context)!.email_required;
                          if (!isValidEmail(text ?? '')) return AppLocalizations.of(context)!.invalid_email;
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      AppFormField(
                        controller: passwordController,
                        label: AppLocalizations.of(context)!.password,
                        icon: Icons.lock,
                        suffixIcon: Icons.visibility,
                        isPassword: true,
                        validator: (text) {
                          if (text?.trim().isEmpty == true)
                            return AppLocalizations.of(context)!.password_required;
                          if (!isValidPassword(text ?? ''))
                            return AppLocalizations.of(context)!.invalid_password;
                          return null;
                        },
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.forgotPassword.name);
                          },
                          child: Text(
                           AppLocalizations.of(context)!.forgot_password,
                            style: const TextStyle(color: AppColor.royalBlue),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is LoginLoadingState
                                ? null
                                : () => _login(context),
                            child: state is LoginLoadingState
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.log_in,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isFormValid() {
    return formKey.currentState?.validate() ?? false;
  }

  void _login(BuildContext context) async{
    if (!isFormValid()) return;

    context.read<LoginCubit>().login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
