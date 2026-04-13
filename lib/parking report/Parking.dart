import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/parking%20report/ParkingCubit.dart';
import 'package:new_project/parking%20report/ParkingState.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

bool _isPresent(String raw) {
  final s = raw.toLowerCase().trim();
  return s.contains('present') || s.contains('حاضر');
}

bool _isLate(String raw) {
  final s = raw.toLowerCase().trim();
  return s.contains('late') || s.contains('متأخر');
}

String _fmtTime(String raw) {
  if (raw.isEmpty || raw == '--') return '--';
  try {
    final parsed = DateTime.parse(raw);
    final h = parsed.hour.toString().padLeft(2, '0');
    final m = parsed.minute.toString().padLeft(2, '0');
    return '$h:$m';
  } catch (_) {}
  try {
    final parts = raw.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
  } catch (_) {}
  return raw;
}

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {

  int? selectedYear;
  int? selectedMonth;


  void _shiftMonth(int delta) {
    setState(() {
      final now = DateTime.now();
      int m = (selectedMonth ?? now.month) + delta;
      int y = selectedYear ?? now.year;
      if (m > 12) {
        m = 1;
        y++;
      } else if (m < 1) {
        m = 12;
        y--;
      }
      selectedMonth = m;
      selectedYear = y;
    });
  }

  List<MapEntry<String, dynamic>> _filterDetails(Map<String, dynamic> data) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    return data.entries.where((entry) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) return false;
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (dateOnly.isAfter(todayOnly)) return false;
      final matchYear  = selectedYear  == null || date.year  == selectedYear;
      final matchMonth = selectedMonth == null || date.month == selectedMonth;
      return matchYear && matchMonth;
    }).toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }
  List<String> _monthNames(BuildContext context) => [
    AppLocalizations.of(context)!.jan,
    AppLocalizations.of(context)!.feb,
    AppLocalizations.of(context)!.mar,
    AppLocalizations.of(context)!.apr,
    AppLocalizations.of(context)!.may,
    AppLocalizations.of(context)!.jun,
    AppLocalizations.of(context)!.jul,
    AppLocalizations.of(context)!.aug,
    AppLocalizations.of(context)!.sep,
    AppLocalizations.of(context)!.oct,
    AppLocalizations.of(context)!.nov,
    AppLocalizations.of(context)!.dec,
  ];

  String _monthYearLabel(BuildContext context) {
    final now = DateTime.now();
    final m = selectedMonth ?? now.month;
    final y = selectedYear ?? now.year;
    return '${_monthNames(context)[m - 1]} $y';
  }

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocProvider(
      create: (context) => getIt<ParkingCubit>()..getParkingReport(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: dark ? AppColor.darkBackground : AppColor.primary,
            body: BlocBuilder<ParkingCubit, ParkingState>(
              builder: (context, state) {
                if (state is ParkingLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.royalBlue,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                if (state is ParkingErrorState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wifi_off_rounded,
                              color: AppColor.red,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColor.red,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () =>
                                context.read<ParkingCubit>().getParkingReport(),
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: Text(AppLocalizations.of(context)!.try_again),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColor.royalBlue,
                              backgroundColor:
                              AppColor.royalBlue.withValues(alpha: 0.08),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ParkingSuccessState) {
                  final rawDetails = state.model.details;
                  final filteredEntries = _filterDetails(
                    rawDetails.map((k, v) => MapEntry(k, v)),
                  );

                  return Column(
                    children: [
                      _buildHeader(context),
                      Expanded(
                        child: filteredEntries.isEmpty
                            ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_parking_rounded,
                                  size: 48,
                                  color: AppColor.gray.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppLocalizations.of(context)!.no_data,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: dark
                                        ? AppColor.softGray
                                        : AppColor.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          itemCount: filteredEntries.length,
                          itemBuilder: (context, index) {
                            final entry = filteredEntries[index];
                            final value =
                            Map<String, dynamic>.from(entry.value);
                            final rawIn =
                                (value['check_in'] ?? value['checkIn'])
                                    ?.toString() ??
                                    '';
                            final rawOut =
                                (value['check_out'] ?? value['checkOut'])
                                    ?.toString() ??
                                    '';
                            return _ParkingCard(
                              date: entry.key,
                              checkIn: _fmtTime(rawIn),
                              checkOut: _fmtTime(rawOut),
                              status: value['status']?.toString() ?? '--',
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1444C0), Color(0xFF4894FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  _NavBtn(icon: Icons.chevron_left, onTap: () => _shiftMonth(-1)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _monthYearLabel(context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _NavBtn(icon: Icons.chevron_right, onTap: () => _shiftMonth(1)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(height: 1, color: Colors.white.withValues(alpha: 0.15)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(Icons.local_parking_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.monthly,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _monthYearLabel(context),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.report,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}


class _ParkingCard extends StatelessWidget {
  final String date;
  final String checkIn;
  final String checkOut;
  final String status;

  const _ParkingCard({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });

  Color _statusColor() {
    if (_isPresent(status)) return AppColor.green;
    if (_isLate(status)) return Colors.orange;
    return AppColor.red;
  }

  IconData _statusIcon() {
    if (_isPresent(status)) return Icons.check_circle_rounded;
    if (_isLate(status)) return Icons.watch_later_rounded;
    return Icons.cancel_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    final statusColor = _statusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: dark ? AppColor.darkBackground : AppColor.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.5)
              : AppColor.softBlue.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: dark
            ? []
            : [
          BoxShadow(
            color: AppColor.softBlue.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.royalBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_parking_rounded,
                    color: AppColor.royalBlue,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    date,
                    style: TextStyle(
                      color: dark ? AppColor.white : AppColor.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _statusIcon(),
                        color: statusColor,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: dark
                ? AppColor.movBlue.withValues(alpha: 0.2)
                : AppColor.softBlue.withValues(alpha: 0.5),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: _TimeBox(
                    label: AppLocalizations.of(context)!.entry,
                    time: checkIn,
                    icon: Icons.login_rounded,
                    iconColor: AppColor.green,
                    dark: dark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TimeBox(
                    label: AppLocalizations.of(context)!.exit,
                    time: checkOut,
                    icon: Icons.logout_rounded,
                    iconColor: AppColor.red,
                    dark: dark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _TimeBox extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool dark;

  const _TimeBox({
    required this.label,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: dark
            ? AppColor.black.withValues(alpha: 0.4)
            : AppColor.royalBlue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.3)
              : AppColor.softBlue.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: dark ? AppColor.softGray : AppColor.gray,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: const TextStyle(
                  color: AppColor.royalBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}