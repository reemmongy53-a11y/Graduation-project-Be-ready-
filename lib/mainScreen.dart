import 'package:flutter/material.dart';
import 'package:new_project/Ui/Security%20screen/security_screen.dart';
import 'package:new_project/Ui/employee/employeeScreen.dart';
import 'package:new_project/attendance_report/Att-report_screen.dart';
import 'package:new_project/Ui/complaint.dart';
import 'package:new_project/data_qr/qr-Screen.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/profile/data-list/data_list.dart';
import 'package:new_project/profile/data-list/profileScreen.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final bool _isSecurity;
  late final List<Widget> _screens;
  late final int _homeIndex;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _isSecurity = UserSession.role == 'security';

    if (_isSecurity) {
      _screens = [
        const ProfileScreen(),
        const Qr(),
        const SecurityScreen(),
        const AttReport(),
        const Complaint(),
      ];
    } else {
      _screens = [
        const ProfileScreen(),
        const Qr(),
        const EmployeeScreen(),
        const AttReport(),
        const Complaint(),
      ];
    }

    _homeIndex = 2;
    _currentIndex = _homeIndex;
  }

  void _showMenu(BuildContext context, bool dark) {
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
  }

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    final loc = AppLocalizations.of(context)!;

    final bool showMenuIcon = !_isSecurity && _currentIndex == _homeIndex;

    final items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: loc.my_profile,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.qr_code_outlined),
        activeIcon: const Icon(Icons.qr_code),
        label: loc.qr,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: loc.home,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.bar_chart_outlined),
        activeIcon: const Icon(Icons.bar_chart),
        label: loc.report,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.chat_bubble_outline),
        activeIcon: const Icon(Icons.chat_bubble),
        label: loc.complaint,
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_currentIndex != _homeIndex) {
          setState(() => _currentIndex = _homeIndex);
        }
      },
      child: Scaffold(

        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppColor.royalBlue,
          unselectedItemColor: Colors.grey,
          backgroundColor: dark ? AppColor.darkBackground : AppColor.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: items,
        ),
      ),
    );
  }
}