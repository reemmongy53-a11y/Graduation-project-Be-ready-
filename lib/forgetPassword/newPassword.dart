import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/custom/validation.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/forgetPassword/reset_password_cubit.dart';
import 'package:new_project/forgetPassword/reset_password_state.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/routes.dart';
import 'package:provider/provider.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isDialogShowing = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    final screenHeight = MediaQuery.of(context).size.height;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>? ?? {};
    final token = args['token'] ?? '';

    return BlocProvider(
      create: (_) => getIt<ResetPasswordCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordLoadingState) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is ResetPasswordSuccessState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.green,
                  ),
                );
                Navigator.pushReplacementNamed(context, AppRoutes.authScreen.name);
              } else if (state is ResetPasswordErrorState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.red,
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: dark ? AppColor.darkBackground : AppColor.primary,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),

                        // ✅ زر الرجوع
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: dark
                                ? AppColor.softGray.withValues(alpha: 0.2)
                                : AppColor.softGray,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: dark ? AppColor.white : AppColor.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.08),

                        // ✅ أيقونة كبيرة
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColor.royalBlue.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              color: AppColor.royalBlue,
                              size: 40,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ✅ العنوان
                        Text(
                          AppLocalizations.of(context)!.new_password,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: dark ? AppColor.white : AppColor.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ✅ الوصف
                        Text(
                          AppLocalizations.of(context)!.create_new_password,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: dark ? AppColor.softGray : AppColor.gray,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ✅ حقل الباسورد
                        AppFormField(
                          label: AppLocalizations.of(context)!.new_password_field,
                          controller: passwordController,
                          isPassword: true,
                          icon: Icons.lock_outline,
                          validator: (text) {
                            if (text?.trim().isEmpty == true)
                              return AppLocalizations.of(context)!.password_required;
                            if (!isValidPassword(text ?? ''))
                              return AppLocalizations.of(context)!.invalid_password;
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // ✅ حقل تأكيد الباسورد
                        AppFormField(
                          label: AppLocalizations.of(context)!.confirm_password,
                          controller: confirmPasswordController,
                          isPassword: true,
                          icon: Icons.lock_outline,
                          validator: (text) {
                            if (text?.trim().isEmpty == true)
                              return AppLocalizations.of(context)!.please_confirm_password;
                            if (text != passwordController.text)
                              return AppLocalizations.of(context)!.passwords_dont_match;
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // ✅ زر Update
                        BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                          builder: (context, state) {
                            return SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.royalBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: state is ResetPasswordLoadingState
                                    ? null
                                    : () {
                                  if (formKey.currentState?.validate() == true) {
                                    context.read<ResetPasswordCubit>().resetPassword(
                                      token: token,
                                      newPassword: passwordController.text.trim(),
                                    );
                                  }
                                },
                                child: state is ResetPasswordLoadingState
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                  AppLocalizations.of(context)!.update_password,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}