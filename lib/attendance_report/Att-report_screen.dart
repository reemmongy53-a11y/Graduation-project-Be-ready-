import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/attendance_report/attendance_cubit.dart';
import 'package:new_project/attendance_report/attendance_state.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

/// مقارنة الـ status بشكل آمن بعيد عن اللغة
bool _isPresent(String raw) {
  final s = raw.toLowerCase().trim();
  return s.contains('present') || s.contains('حاضر');
}

bool _isLate(String raw) {
  final s = raw.toLowerCase().trim();
  return s.contains('late') || s.contains('متأخر');
}

bool _isAbsent(String raw) {
  final s = raw.toLowerCase().trim();
  return s.contains('absent') || s.contains('absence') || s.contains('غائب');
}

String _fmtTime(String raw) {
  if (raw.isEmpty) return '--';

  // Full ISO datetime  e.g. "2026-04-11T09:00:00"
  try {
    final parsed = DateTime.parse(raw);
    final h = parsed.hour.toString().padLeft(2, '0');
    final m = parsed.minute.toString().padLeft(2, '0');
    return '$h:$m';
  } catch (_) {}

  // Time-only string  e.g. "09:00:00" or "09:00"
  try {
    final parts = raw.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
  } catch (_) {}

  return raw;
}

String _calcTotal(String inRaw, String outRaw) {
  if (inRaw.isEmpty || outRaw.isEmpty) return '--';
  try {
    DateTime? inTime, outTime;
    try {
      inTime = DateTime.parse(inRaw);
      outTime = DateTime.parse(outRaw);
    } catch (_) {
      // Time-only strings
      inTime = DateTime.parse('1970-01-01T$inRaw');
      outTime = DateTime.parse('1970-01-01T$outRaw');
    }
    final diff = outTime!.difference(inTime!);
    if (diff.isNegative) return '--';
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return '${h}h ${m}m';
  } catch (_) {
    return '--';
  }
}

// ── Main Widget ───────────────────────────────────────────────────────────────

class AttReport extends StatefulWidget {
  const AttReport({super.key});

  @override
  State<AttReport> createState() => _AttReportState();
}

class _AttReportState extends State<AttReport> {
  int? selectedYear;
  int? selectedMonth;

  List<int> get years => List.generate(5, (i) => DateTime.now().year - i);
  List<int> get months => List.generate(12, (i) => i + 1);

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

  List<MapEntry<String, dynamic>> _filterDetails(Map<String, dynamic> data) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    return data.entries.where((entry) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) return false;
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (dateOnly.isAfter(todayOnly)) return false;
      final matchYear = selectedYear == null || date.year == selectedYear;
      final matchMonth = selectedMonth == null || date.month == selectedMonth;
      return matchYear && matchMonth;
    }).toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  /// ✅ المقارنة بـ English strings ثابتة — مش localized
  Map<String, int> _calcSummary(Map<String, dynamic> details) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    int present = 0, late = 0, absent = 0;
    for (final entry in details.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) continue;
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (dateOnly.isAfter(todayOnly)) continue;
      if (selectedYear != null && date.year != selectedYear) continue;
      if (selectedMonth != null && date.month != selectedMonth) continue;
      final value = Map<String, dynamic>.from(entry.value);
      final s = value['status']?.toString() ?? '';
      if (_isLate(s)) {
        late++;
      } else if (_isAbsent(s)) {
        absent++;
      } else if (_isPresent(s)) {
        present++;
      }
    }
    return {'present': present, 'late': late, 'absent': absent};
  }

  Map<int, List<MapEntry<String, dynamic>>> _groupByWeek(
      List<MapEntry<String, dynamic>> entries) {
    final Map<int, List<MapEntry<String, dynamic>>> weeks = {};
    for (final entry in entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) continue;
      final weekNum = _isoWeekNumber(date);
      weeks.putIfAbsent(weekNum, () => []).add(entry);
    }
    return weeks;
  }

  int _isoWeekNumber(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  String _monthYearLabel(BuildContext context) {
    final now = DateTime.now();
    final m = selectedMonth ?? now.month;
    final y = selectedYear ?? now.year;
    return '${_monthNames(context)[m - 1]} $y';
  }

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

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>()..getReport(),
      child: Scaffold(
        backgroundColor: dark ? AppColor.darkBackground : AppColor.primary,
        body: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AttendanceErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: AppColor.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AttendanceCubit>().getReport(),
                      child: Text(AppLocalizations.of(context)!.try_again),
                    ),
                  ],
                ),
              );
            }

            if (state is AttendanceSuccessState) {
              final details = state.model.details;
              final filteredDetails = _filterDetails(details);
              final weekGroups = _groupByWeek(filteredDetails);
              final calcSummary = _calcSummary(details);
              final presentDays = calcSummary['present']!;
              final lateDays = calcSummary['late']!;
              final absentDays = calcSummary['absent']!;
              final totalDays = presentDays + lateDays + absentDays;
              final bool noDataYet = totalDays == 0 && filteredDetails.isEmpty;

              return Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: noDataYet
                          ? _buildNoReportYet(context, dark)
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryGrid(
                            context,
                            dark,
                            presentDays,
                            lateDays,
                            absentDays,
                            totalDays,
                          ),
                          const SizedBox(height: 16),
                          _buildProgressCard(
                            context,
                            dark,
                            presentDays,
                            lateDays,
                            absentDays,
                            totalDays,
                          ),
                          const SizedBox(height: 20),
                          if (filteredDetails.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_attendance_details_available,
                                  style: TextStyle(
                                    color: dark
                                        ? AppColor.softGray
                                        : AppColor.gray,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...weekGroups.entries
                                .toList()
                                .asMap()
                                .entries
                                .map((indexedEntry) {
                              final weekIndex = indexedEntry.key + 1;
                              final weekEntries =
                                  indexedEntry.value.value;
                              int lateCnt = 0,
                                  absentCnt = 0,
                                  presentCnt = 0;
                              for (final e in weekEntries) {
                                final s =
                                    Map<String, dynamic>.from(e.value)[
                                    'status']
                                        ?.toString() ??
                                        '';
                                // ✅ مقارنة آمنة
                                if (_isLate(s)) {
                                  lateCnt++;
                                } else if (_isAbsent(s)) {
                                  absentCnt++;
                                } else {
                                  presentCnt++;
                                }
                              }
                              return _WeekSection(
                                weekNumber: weekIndex,
                                lateCnt: lateCnt,
                                absentCnt: absentCnt,
                                presentCnt: presentCnt,
                                entries: weekEntries,
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1444C0), Color(0xFF4894FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D61E7).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  _NavBtn(
                      icon: Icons.chevron_left,
                      onTap: () => _shiftMonth(-1)),
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
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _NavBtn(
                      icon: Icons.chevron_right,
                      onTap: () => _shiftMonth(1)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
                height: 1, color: Colors.white.withValues(alpha: 0.15)),
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
                    child: const Icon(Icons.person_rounded,
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
                            letterSpacing: 0.2,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
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

  Widget _buildNoReportYet(BuildContext context, bool dark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColor.movBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_today_rounded,
                  color: AppColor.movBlue, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.no_report,
              style: TextStyle(
                color: dark ? AppColor.white : AppColor.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.no_attendance_details_available,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dark ? AppColor.softGray : AppColor.gray,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context, bool dark, int presentDays,
      int lateDays, int absentDays, int totalDays) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        _StatCard(
          label: AppLocalizations.of(context)!.days_of_attendance,
          value: '$presentDays',
          icon: Icons.check_circle_rounded,
          iconBg: AppColor.royalBlue.withValues(alpha: 0.12),
          iconColor: AppColor.royalBlue,
          valueColor: AppColor.royalBlue,
          borderColor: AppColor.softBlue,
        ),
        _StatCard(
          label: AppLocalizations.of(context)!.late_days,
          value: '$lateDays',
          icon: Icons.access_time_rounded,
          iconBg: Colors.orange.withValues(alpha: 0.12),
          iconColor: Colors.orange,
          valueColor: Colors.orange,
          borderColor: Colors.orange.withValues(alpha: 0.3),
        ),
        _StatCard(
          label: AppLocalizations.of(context)!.days_of_absence,
          value: '$absentDays',
          icon: Icons.cancel_rounded,
          iconBg: const Color(0xFF9C59D1).withValues(alpha: 0.12),
          iconColor: const Color(0xFF9C59D1),
          valueColor: const Color(0xFF9C59D1),
          borderColor: const Color(0xFF9C59D1).withValues(alpha: 0.25),
        ),
        _StatCard(
          label: AppLocalizations.of(context)!.total_day,
          value: '$totalDays',
          icon: Icons.calendar_month_rounded,
          iconBg: AppColor.gray.withValues(alpha: 0.1),
          iconColor: AppColor.gray,
          valueColor: dark ? AppColor.white : AppColor.black,
          borderColor: AppColor.softBlue,
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, bool dark, int present,
      int late, int absent, int totalDays) {
    final presentRatio = totalDays == 0 ? 0.0 : present / totalDays;
    final lateRatio = totalDays == 0 ? 0.0 : late / totalDays;
    final absentRatio = totalDays == 0 ? 0.0 : absent / totalDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? AppColor.darkBackground : AppColor.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.25)
              : AppColor.softBlue,
          width: 1.5,
        ),
        boxShadow: dark
            ? []
            : [
          BoxShadow(
            color: AppColor.softBlue.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.monthly,
                style: TextStyle(
                  color: dark ? AppColor.white : AppColor.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '$totalDays ${AppLocalizations.of(context)!.day}',
                style: const TextStyle(color: AppColor.gray, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Flexible(
                    flex: (presentRatio * 1000).toInt(),
                    child: Container(color: AppColor.royalBlue),
                  ),
                  Flexible(
                    flex: (lateRatio * 1000).toInt(),
                    child: Container(color: Colors.orange),
                  ),
                  Flexible(
                    flex: (absentRatio * 1000).toInt(),
                    child: Container(color: const Color(0xFF9C59D1)),
                  ),
                  if (totalDays == 0)
                    Expanded(child: Container(color: AppColor.softBlue)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LegendDot(
                  color: AppColor.royalBlue,
                  label: AppLocalizations.of(context)!.present),
              const SizedBox(width: 16),
              _LegendDot(
                  color: Colors.orange,
                  label: AppLocalizations.of(context)!.late),
              const SizedBox(width: 16),
              _LegendDot(
                  color: Color(0xFF9C59D1),
                  label: AppLocalizations.of(context)!.absent),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color valueColor;
  final Color borderColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.valueColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? AppColor.darkBackground : AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: dark
            ? []
            : [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dark ? AppColor.softGray : AppColor.gray,
                    fontSize: 10,
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

class _WeekSection extends StatelessWidget {
  final int weekNumber;
  final int lateCnt;
  final int absentCnt;
  final int presentCnt;
  final List<MapEntry<String, dynamic>> entries;

  const _WeekSection({
    required this.weekNumber,
    required this.lateCnt,
    required this.absentCnt,
    required this.presentCnt,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    Color badgeColor;
    String badgeLabel;
    if (absentCnt > 0) {
      badgeColor = const Color(0xFF9C59D1);
      badgeLabel = AppLocalizations.of(context)!.absent;
    } else if (lateCnt > 0) {
      badgeColor = Colors.orange;
      badgeLabel = AppLocalizations.of(context)!.late;
    } else {
      badgeColor = AppColor.green;
      badgeLabel = AppLocalizations.of(context)!.present;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppLocalizations.of(context)!.week} $weekNumber',
              style: TextStyle(
                color: dark ? AppColor.white : AppColor.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(10),
                border:
                Border.all(color: badgeColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                badgeLabel,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...entries.map((entry) {
          final value = Map<String, dynamic>.from(entry.value);
          final date = DateTime.tryParse(entry.key);

          // ✅ بنجرب check_in و checkIn عشان نضمن الاتنين
          final rawIn =
              (value['check_in'] ?? value['checkIn'])?.toString() ?? '';
          final rawOut =
              (value['check_out'] ?? value['checkOut'])?.toString() ?? '';

          return _DayCard(
            date: date,
            timeIn: _fmtTime(rawIn),
            timeOut: _fmtTime(rawOut),
            status: value['status']?.toString() ?? '--',
            totalTime: _calcTotal(rawIn, rawOut),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final DateTime? date;
  final String timeIn;
  final String timeOut;
  final String status;
  final String totalTime;

  const _DayCard({
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.status,
    required this.totalTime,
  });

  // ✅ مقارنة آمنة بعيدة عن اللغة
  Color _statusColor() {
    if (_isLate(status)) return Colors.orange;
    if (_isAbsent(status)) return const Color(0xFF9C59D1);
    return AppColor.royalBlue;
  }

  List<String> _dayNames(BuildContext context) => [
    '',
    AppLocalizations.of(context)!.day_mon,
    AppLocalizations.of(context)!.day_tue,
    AppLocalizations.of(context)!.day_wed,
    AppLocalizations.of(context)!.day_thu,
    AppLocalizations.of(context)!.day_fri,
    AppLocalizations.of(context)!.day_sat,
    AppLocalizations.of(context)!.day_sun,
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    final dayNum = date != null ? date!.day.toString().padLeft(2, '0') : '--';
    final dayName = date != null ? _dayNames(context)[date!.weekday] : '';
    final color = _statusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: dark ? AppColor.darkBackground : AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.2)
              : AppColor.softBlue,
          width: 1.2,
        ),
        boxShadow: dark
            ? []
            : [
          BoxShadow(
            color: AppColor.softBlue.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 50,
            decoration: BoxDecoration(
              color: dark
                  ? AppColor.movBlue.withValues(alpha: 0.12)
                  : AppColor.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNum,
                  style: TextStyle(
                    color: dark ? AppColor.white : AppColor.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  dayName,
                  style:
                  const TextStyle(color: AppColor.gray, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TimeColumn(
              dotColor: AppColor.green,
              label: AppLocalizations.of(context)!.check_in,
              time: timeIn,
              dark: dark,
            ),
          ),
          Expanded(
            child: _TimeColumn(
              dotColor: AppColor.red,
              label: AppLocalizations.of(context)!.check_out,
              time: timeOut,
              dark: dark,
            ),
          ),
          Expanded(
            child: _TimeColumn(
              dotColor: Colors.transparent,
              label: AppLocalizations.of(context)!.total,
              time: totalTime,
              dark: dark,
              showDot: false,
              icon: Icons.timer_outlined,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String time;
  final bool dark;
  final bool showDot;
  final IconData? icon;

  const _TimeColumn({
    required this.dotColor,
    required this.label,
    required this.time,
    required this.dark,
    this.showDot = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDot)
          Container(
            width: 8,
            height: 8,
            decoration:
            BoxDecoration(color: dotColor, shape: BoxShape.circle),
          )
        else if (icon != null)
          Icon(icon, color: AppColor.gray, size: 16),
        const SizedBox(height: 3),
        Text(
          time,
          style: TextStyle(
            color: dark ? AppColor.white : AppColor.black,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColor.gray, fontSize: 10),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: dark ? AppColor.softGray : AppColor.gray,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}