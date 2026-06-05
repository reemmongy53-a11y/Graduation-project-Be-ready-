import 'package:flutter/material.dart';
import 'package:new_project/Ui/complaint/API%20Service.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';


// ✅ تحويل لـ StatefulWidget
class Complaint extends StatefulWidget {
  const Complaint({super.key});

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  // ✅ Controllers
  final _jobTitleController = TextEditingController();
  final _reportTitleController = TextEditingController();
  final _reportDetailsController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isLoading = false;
  final _service = ComplaintsService();

  @override
  void dispose() {
    _jobTitleController.dispose();
    _reportTitleController.dispose();
    _reportDetailsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // ✅ Submit function
  Future<void> _submit() async {
    if (_jobTitleController.text.trim().isEmpty ||
        _reportTitleController.text.trim().isEmpty ||
        _reportDetailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.please_enter_data)),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _service.submitComplaint(
      jobTitle: _jobTitleController.text.trim(),
      reportTitle: _reportTitleController.text.trim(),
      reportDetails: _reportDetailsController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.succsesful)),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${result['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print("employeeNumber = ${UserSession.employeeNumber}");
    print("employeeId = ${UserSession.employeeId}");

    return CustomScaffold(
      image: AppImage.Logo,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColor.movBlue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.movBlue.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.submit_complaint,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColor.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColor.movBlue.withOpacity(0.15)
                        : AppColor.movBlue.withOpacity(0.08),
                    border: Border.all(
                      color: isDark
                          ? AppColor.movBlue.withOpacity(0.5)
                          : AppColor.movBlue.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColor.movBlue,
                        child: Text(
                          _initials(UserSession.name ?? ''),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserSession.name?.isNotEmpty == true
                                  ? UserSession.name!
                                  : '—',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColor.movBlue.withOpacity(0.9)
                                    : AppColor.movBlue,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ID: ${UserSession.employeeNumber}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColor.movBlue.withOpacity(0.6)
                                    : AppColor.movBlue.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ✅ Fields مع Controllers
                AppFormField(
                  hintText: AppLocalizations.of(context)!.job_or_department,
                  controller: _jobTitleController,
                ),
                const SizedBox(height: 12),
                AppFormField(
                  hintText: AppLocalizations.of(context)!.report_title,
                  controller: _reportTitleController,
                ),
                const SizedBox(height: 12),
                AppFormField(
                  hintText: AppLocalizations.of(context)!.report_details,
                  controller: _reportDetailsController,
                  maxLines: null,
                  minLines: 3,
                ),
                const SizedBox(height: 12),
                AppFormField(
                  hintText: AppLocalizations.of(context)!.date_of_complaint,
                  controller: _dateController,
                  icon: Icons.calendar_month,
                  keyboardType: TextInputType.datetime,
                ),

                const SizedBox(height: 20),

                // ✅ زرار مع loading
                SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.movBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      AppLocalizations.of(context)!.submit,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}