import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/forgetPassword/verify_otp_cubit.dart';
import 'package:new_project/forgetPassword/verify_otp_state.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/routes.dart';
import 'package:provider/provider.dart';

class CheckEmail extends StatefulWidget {
  const CheckEmail({super.key});

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  final List<TextEditingController> otpControllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());
  bool _isDialogShowing = false;

  String get otp => otpControllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var c in otpControllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => getIt<VerifyOtpCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<VerifyOtpCubit, VerifyOtpState>(
            listener: (context, state) {
              if (state is VerifyOtpLoading) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is VerifyOtpSuccess) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                Navigator.pushNamed(
                  context,
                  AppRoutes.newPassword.name,
                  arguments: {'token': state.token},
                );
              } else if (state is VerifyOtpResendSuccess) {
                // ✅ أضفنا الـ state الجديد
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.resend_email),
                    backgroundColor: AppColor.green,
                  ),
                );
              } else if (state is VerifyOtpError) {
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
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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

                      SizedBox(height: screenHeight * 0.06),

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
                            Icons.mark_email_unread_outlined,
                            color: AppColor.royalBlue,
                            size: 40,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ✅ العنوان
                      Text(
                        AppLocalizations.of(context)!.check_email,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: dark ? AppColor.white : AppColor.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ✅ الوصف
                      Text(
                        AppLocalizations.of(context)!.send_code,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: dark ? AppColor.softGray : AppColor.gray,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ✅ خانات OTP
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final boxSize = (constraints.maxWidth - (4 * 12)) / 5;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (index) {
                              return Container(
                                width: boxSize,
                                height: boxSize,
                                decoration: BoxDecoration(
                                  color: dark
                                      ? AppColor.darkBackground
                                      : AppColor.primary,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: dark
                                        ? AppColor.movBlue.withValues(alpha: 0.4)
                                        : AppColor.softGray,
                                  ),
                                ),
                                child: TextField(
                                  controller: otpControllers[index],
                                  focusNode: focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: dark ? AppColor.white : AppColor.black, // ✅ بيتغير مع الثيم
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 4) {
                                      focusNodes[index + 1].requestFocus();
                                    }
                                    if (value.isEmpty && index > 0) {
                                      focusNodes[index - 1].requestFocus();
                                    }
                                  },
                                ),
                              );
                            }),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // ✅ زر Verify
                      BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
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
                              onPressed: state is VerifyOtpLoading
                                  ? null
                                  : () {
                                if (otp.length < 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(context)!.enter_code),
                                      backgroundColor: AppColor.red,
                                    ),
                                  );
                                  return;
                                }
                                context.read<VerifyOtpCubit>().verifyOtp(
                                  email: email,
                                  otp: otp,
                                );
                              },
                              child: state is VerifyOtpLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                AppLocalizations.of(context)!.verify_code,
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

                      // ✅ Resend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.havent_got_email,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: dark ? AppColor.softGray : AppColor.gray,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<VerifyOtpCubit>().resendOtp(email: email);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.resend_email,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColor.royalBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
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
}