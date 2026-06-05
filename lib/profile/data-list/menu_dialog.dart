import 'package:flutter/material.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/profile/data-list/data_list.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/providers/languageProvider.dart';
import 'package:provider/provider.dart';

void showMenuDialog(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  final dark = themeProvider.isDarkMode;

  showDialog(
    context: context,
    barrierColor: Colors.black26,
    builder: (_) => MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: Builder(
        builder: (ctx) {
          // ✅ بيسمع للتغييرات ويحدث اللون بدون ما يتقفل
          final isDark = Provider.of<ThemeProvider>(ctx).isDarkMode;
          return Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 70, right: 10),
              child: Material(
                color: isDark ? AppColor.darkBackground : AppColor.white,
                borderRadius: BorderRadius.circular(20),
                elevation: 8,
                child: SizedBox(
                  width: 270,
                  height: 300,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: DataList(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}