import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/custom/validation.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/forgetPassword/forgot_password_cubit.dart';
import 'package:new_project/forgetPassword/forgot_password_state.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/routes.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isDialogShowing = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordLoadingState) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is ForgotPasswordSuccessState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                Navigator.pushNamed(
                  context,
                  AppRoutes.checkEmail.name,
                  arguments: emailController.text.trim(),
                );
              } else if (state is ForgotPasswordErrorState) {
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
                child: Padding(
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

                        // ✅ مساحة ديناميكية قبل المحتوى عشان يتوسط
                        SizedBox(height: screenHeight * 0.08),

                        // ✅ أيقونة كبيرة فوق
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColor.royalBlue.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_reset_outlined,
                              color: AppColor.royalBlue,
                              size: 40,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ✅ العنوان
                        Text(
                          AppLocalizations.of(context)!.forgot_password,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: dark ? AppColor.white : AppColor.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ✅ الوصف
                        Text(
                          AppLocalizations.of(context)!.please_enter_email,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: dark ? AppColor.softGray : AppColor.gray,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ✅ حقل الإيميل
                        AppFormField(
                          label: AppLocalizations.of(context)!.email,
                          controller: emailController,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (text) {
                            if (text?.trim().isEmpty == true)
                              return AppLocalizations.of(context)!.email_required;
                            if (!isValidEmail(text ?? ''))
                              return AppLocalizations.of(context)!.invalid_email;
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // ✅ زر Reset
                        BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                          builder: (context, state) {
                            return SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.royalBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: state is ForgotPasswordLoadingState
                                    ? null
                                    : () {
                                  if (formKey.currentState?.validate() == true) {
                                    context.read<ForgotPasswordCubit>().forgotPassword(
                                      email: emailController.text.trim(),
                                    );
                                  }
                                },
                                child: state is ForgotPasswordLoadingState
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                  AppLocalizations.of(context)!.reset_password,
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