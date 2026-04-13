import 'package:flutter/material.dart';
import 'package:new_project/Ui/Security%20screen/items.dart';
import 'package:new_project/Ui/statusService/gateService/Status.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/News%20summary/newsSummary.dart';
import 'package:new_project/custom/data_file.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/profile/data-list/data_list.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/routes.dart';
import 'package:provider/provider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return CustomScaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataFile(name: UserSession.name, email: ''),
              const SizedBox(height: 10),
              Center(
                child: NewsSummary(
                  lottie: AppImage.greenStatus,
                  title: AppLocalizations.of(context)!.gate_control,
                  description: AppLocalizations.of(context)!.on_site,
                  date: "42",
                  description2: AppLocalizations.of(context)!.vehicles,
                  date2: "7",
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.control,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
              ),
              Status(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  AppLocalizations.of(context)!.quick_actions,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Items(
                    image: AppImage.qrLight,
                    title: AppLocalizations.of(context)!.qr,
                    routeName: AppRoutes.QR.name,
                  ),
                  Items(
                    image: AppImage.Attendance,
                    title: AppLocalizations.of(context)!.attendance_report,
                    routeName: AppRoutes.AttReport.name,
                  ),
                  Items(
                    image: AppImage.complaint,
                    title: AppLocalizations.of(context)!.submit_complaint,
                    routeName: AppRoutes.complaint.name,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
