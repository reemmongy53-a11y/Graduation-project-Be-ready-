import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Ui/employee/items.dart';
import 'package:new_project/Ui/employee/report.dart';
import 'package:new_project/attendance_report/attendance_cubit.dart';
import 'package:new_project/attendance_report/attendance_state.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/profile/data-list/data_list.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/routes.dart';
import 'package:new_project/custom/News%20summary/newsSummary.dart';
import 'package:new_project/custom/data_file.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:provider/provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String _formatDate(String raw) {
    try {
      final parsed = DateTime.parse(raw);
      return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }

  String _formatTime(String raw) {
    try {
      final parsed = DateTime.parse(raw);
      final hour = parsed.hour.toString().padLeft(2, '0');
      final minute = parsed.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    final name = UserSession.name.isNotEmpty ? UserSession.name : "User";
    final email = UserSession.email.isNotEmpty
        ? UserSession.email
        : "name@gmail.com";

    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>()..getReport(),
      child: CustomScaffold(
        image: AppImage.Logo,
        icons: Icon(Icons.menu, color: AppColor.royalBlue, size: 30),
        onIconPressed: () {
          showMenu(
            color: dark ? AppColor.darkBackground : AppColor.white,
            context: context,
            position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            items: [
              PopupMenuItem(
                enabled: false,
                child: SizedBox(width: 250, child: DataList()),
              ),
            ],
          );
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DataFile(name: name, email: email),
              const SizedBox(height: 20),

              BlocBuilder<AttendanceCubit, AttendanceState>(
                builder: (context, state) {
                  final summary = state is AttendanceSuccessState
                      ? state.model.summary
                      : null;
                  return Center(
                    child: NewsSummary(
                      image: AppImage.Att,
                      title: AppLocalizations.of(context)!.monthly_activity,
                      description: AppLocalizations.of(context)!.attendance,
                      date: summary?.presentDays.toString() ?? "0",
                      description2: AppLocalizations.of(context)!.absence,
                      date2: summary?.absentDays.toString() ?? "0",
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Item(
                          image: AppImage.CarLight,
                          title: AppLocalizations.of(context)!.vehicle_entry,
                          routeName: AppRoutes.vehicleReport.name,
                        ),
                        Item(
                          image: AppImage.qrLight,
                          title: AppLocalizations.of(context)!.qr,
                          routeName: AppRoutes.QR.name,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Item(
                          image: AppImage.Attendance,
                          title: AppLocalizations.of(
                            context,
                          )!.attendance_report,
                          routeName: AppRoutes.AttReport.name,
                        ),
                        Item(
                          image: AppImage.parking,
                          title: AppLocalizations.of(context)!.parking,
                          routeName: AppRoutes.parkingReport.name,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: dark ? AppColor.darkBackground : AppColor.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: dark
                        ? AppColor.movBlue.withValues(alpha: 0.4)
                        : AppColor.softBlue,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.activity,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: dark ? AppColor.white : AppColor.black,
                                ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.AttReport.name,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.blue.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.view_all,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.blue,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Divider(
                        color: dark
                            ? AppColor.movBlue.withValues(alpha: 0.2)
                            : AppColor.softBlue,
                        thickness: 0.8,
                        height: 1,
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<AttendanceCubit, AttendanceState>(
                        builder: (context, state) {
                          if (state is AttendanceLoadingState) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }

                          if (state is AttendanceErrorState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(
                                    color: AppColor.red,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

                          if (state is AttendanceSuccessState) {
                            final details = state.model.details;

                            if (details.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.no_activity,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: dark
                                          ? AppColor.softGray
                                          : AppColor.gray,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final recentEntries = details.entries
                                .take(3)
                                .toList();

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(recentEntries.length, (
                                i,
                              ) {
                                final entry = recentEntries[i];
                                final date = _formatDate(entry.key);
                                final value =
                                    entry.value as Map<String, dynamic>;
                                final status = value['status'] ?? '--';
                                final timeIn = _formatTime(
                                  value['checkIn'] ?? '--',
                                );
                                final timeOut = _formatTime(
                                  value['checkOut'] ?? '--',
                                );
                                final isAbsent =
                                    status ==
                                    AppLocalizations.of(context)!.absence;
                                final isLast = i == recentEntries.length - 1;

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isAbsent
                                                  ? AppColor.red
                                                  : Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 10),

                                          Expanded(
                                            child: Text(
                                              date,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: dark
                                                    ? AppColor.white
                                                    : AppColor.black,
                                              ),
                                            ),
                                          ),

                                          if (isAbsent)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColor.red.withValues(
                                                  alpha: 0.10,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.absence,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.red,
                                                ),
                                              ),
                                            )
                                          else
                                            Row(
                                              children: [
                                                _TimeBadge(
                                                  time: timeIn,
                                                  isIn: true,
                                                ),
                                                const SizedBox(width: 6),
                                                _TimeBadge(
                                                  time: timeOut,
                                                  isIn: false,
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),

                                    if (!isLast)
                                      Divider(
                                        color: dark
                                            ? AppColor.movBlue.withValues(
                                                alpha: 0.15,
                                              )
                                            : AppColor.softBlue,
                                        thickness: 0.6,
                                        height: 1,
                                      ),
                                  ],
                                );
                              }),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),

              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.complaint.name),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: dark ? AppColor.darkBackground : AppColor.softBlue,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: dark
                          ? AppColor.movBlue.withValues(alpha: 0.8)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(AppImage.complaint, width: 72, height: 72),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.submit_complaint,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: dark ? AppColor.white : null,
                                  ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.report_incident,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: dark ? AppColor.softGray : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: dark ? AppColor.movBlue : AppColor.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  const _TimeBadge({required this.time, required this.isIn});
  final String time;
  final bool isIn;

  @override
  Widget build(BuildContext context) {
    final bg = isIn
        ? Colors.green.withValues(alpha: 0.10)
        : AppColor.red.withValues(alpha: 0.10);
    final fg = isIn ? Colors.green[700]! : AppColor.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}
