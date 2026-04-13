import 'package:flutter/material.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';


class Complaint extends StatelessWidget {
  const Complaint({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      image: AppImage.Logo,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        offset: Offset(0, 8),
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
              AppFormField(
                hintText: AppLocalizations.of(context)!.name,
                initialValue: UserSession.name,
                readOnly: true,
              ),
              AppFormField(
                hintText: AppLocalizations.of(context)!.id,
                initialValue: UserSession.employeeId,
                readOnly: true,
              ),

              AppFormField(hintText: AppLocalizations.of(context)!.job_or_department),
              AppFormField(hintText: AppLocalizations.of(context)!.report_title),
              AppFormField(hintText: AppLocalizations.of(context)!.report_details),
              AppFormField(
                hintText: AppLocalizations.of(context)!.date_of_complaint,
                icon: Icons.calendar_month,
                keyboardType: TextInputType.datetime,
              ),

              ElevatedButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.submit,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}