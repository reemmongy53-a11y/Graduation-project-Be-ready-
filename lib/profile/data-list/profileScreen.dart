import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/data_file.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/profile/profile_cubit.dart';
import 'package:new_project/profile/profile_state.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final plateNumberController = TextEditingController();
  bool _isDialogShowing = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    plateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getProfile(),
      child: Builder(
        builder: (context) {
          return BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdateLoadingState) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                  const Center(child: CircularProgressIndicator()),
                );
              } else if (state is ProfileUpdateSuccessState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.data_updated),
                    backgroundColor: AppColor.green,
                  ),
                );
              } else if (state is ProfileErrorState) {
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
            child: CustomScaffold(
              icons: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColor.royalBlue,
              ),
              onIconPressed: () => Navigator.pop(context),
              body: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.royalBlue,
                      ),
                    );
                  }

                  final model = state is ProfileSuccessState
                      ? state.model
                      : state is ProfileUpdateSuccessState
                      ? state.model
                      : null;

                  if (model != null && nameController.text.isEmpty) {
                    nameController.text = model.name;
                    emailController.text = model.email;
                    passwordController.text = UserSession.password;
                    plateNumberController.text = model.plateNumber;
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DataFile(name: UserSession.name, email: ""),
                        const SizedBox(height: 8),
                        Divider(
                          thickness: 1,
                          color: dark
                              ? AppColor.movBlue.withValues(alpha: 0.2)
                              : AppColor.softGray.withValues(alpha: 0.5),
                          indent: 20,
                          endIndent: 20,
                        ),
                        const SizedBox(height: 12),

                        if (model != null) ...[
                          _InfoCard(
                            icon: Icons.work_outline,
                            label: 'Role',
                            value: model.role,
                            dark: dark,
                          ),
                          const SizedBox(height: 8),
                          _InfoCard(
                            icon: Icons.badge_outlined,
                            label: AppLocalizations.of(context)!.employee_number,
                            value: model.employeeNumber,
                            dark: dark,
                          ),
                          const SizedBox(height: 20),
                        ],

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.edit,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: dark ? AppColor.white : AppColor.navy,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppFormField(
                          hintText: AppLocalizations.of(context)!.name,
                          controller: nameController,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        AppFormField(
                          hintText: AppLocalizations.of(context)!.email,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 12),

                        if (model != null &&
                            model.plateNumber.isNotEmpty) ...[
                          AppFormField(
                            hintText: AppLocalizations.of(context)!.plate_number,
                            controller: plateNumberController,
                            icon: Icons.directions_car_outlined,
                          ),
                          const SizedBox(height: 12),
                        ],

                        AppFormField(
                          hintText: AppLocalizations.of(context)!.password,
                          controller: passwordController,
                          isPassword: true,
                          icon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 12),

                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 70,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.royalBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: state is ProfileUpdateLoadingState
                                    ? null
                                    : () {
                                  if (nameController.text
                                      .trim()
                                      .isEmpty ||
                                      emailController.text
                                          .trim()
                                          .isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(context)!
                                              .please_enter_email,
                                        ),
                                        backgroundColor: AppColor.red,
                                      ),
                                    );
                                    return;
                                  }
                                  context
                                      .read<ProfileCubit>()
                                      .updateProfile(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text
                                        .trim()
                                        .isEmpty
                                        ? null
                                        : passwordController.text.trim(),
                                    plateNumber: plateNumberController
                                        .text
                                        .trim()
                                        .isEmpty
                                        ? null
                                        : plateNumberController.text.trim(),
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.save_change,
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool dark;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: dark
            ? AppColor.darkBackground
            : AppColor.softBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.4)
              : AppColor.royalBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: dark
                  ? AppColor.royalBlue.withValues(alpha: 0.2)
                  : AppColor.royalBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColor.royalBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: dark ? AppColor.softGray : AppColor.gray,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: dark ? AppColor.white : AppColor.navy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}