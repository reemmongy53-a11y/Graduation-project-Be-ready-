import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/vehicle/vehicle_cubit.dart';
import 'package:new_project/vehicle/vehicle_model.dart';
import 'package:new_project/vehicle/vehicle_state.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';

class VehicleEntry extends StatefulWidget {
  const VehicleEntry({super.key});

  @override
  State<VehicleEntry> createState() => _VehicleEntryState();
}

class _VehicleEntryState extends State<VehicleEntry> {
  final plateController = TextEditingController();
  bool _isDialogShowing = false;

  @override
  void dispose() {
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;

        return BlocProvider(
          create: (_) => getIt<VehicleCubit>(),
          child: Builder(
            builder: (context) {
              return BlocListener<VehicleCubit, VehicleState>(
                listener: (context, state) {
                  if (state is VehicleLoadingState) {
                    _isDialogShowing = true;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is VehicleSuccessState) {
                    if (_isDialogShowing) {
                      _isDialogShowing = false;
                      Navigator.pop(context);
                    }
                    plateController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(' ${state.model.plateNumber}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is VehicleErrorState) {
                    if (_isDialogShowing) {
                      _isDialogShowing = false;
                      Navigator.pop(context);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(' ${state.message}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: CustomScaffold(
                  image: AppImage.Logo,
                  icons: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.royalBlue,
                    size: 30,
                  ),
                  onIconPressed: () => Navigator.pop(context),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColor.navy : AppColor.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: AppColor.royalBlue,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .vehicle_registration,
                                    style: TextStyle(
                                      color: AppColor.royalBlue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .register_vehicle,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColor.softGray
                                          : Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              color: AppColor.royalBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${AppLocalizations.of(context)!.Employee_ID}:  ${UserSession.employeeNumber}',
                                style: TextStyle(
                                  color: AppColor.royalBlue,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        AppFormField(
                          label: AppLocalizations.of(context)!.plate_number,
                          hintText: AppLocalizations.of(context)!.e_g,
                          controller: plateController,
                        ),

                        const SizedBox(height: 24),

                        // ✅ Register Button
                        BlocBuilder<VehicleCubit, VehicleState>(
                          builder: (context, state) {
                            final isLoading = state is VehicleLoadingState;
                            return ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                if (plateController.text
                                    .trim()
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppLocalizations.of(context)!
                                            .please_enter_number,
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                context.read<VehicleCubit>().registerVehicle(
                                  plateNumber: plateController.text.trim(),

                                );
                              },
                              icon: isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Icon(
                                  Icons.app_registration_rounded),
                              label: Text(
                                AppLocalizations.of(context)!.register_car,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.royalBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}