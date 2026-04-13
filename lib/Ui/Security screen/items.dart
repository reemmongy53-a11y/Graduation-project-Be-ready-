import 'package:flutter/material.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

class Items extends StatelessWidget {
  const Items({super.key, required this.image, required this.title, required this.routeName});
  final String image;
  final String title;
  final routeName;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;


        final itemWidth = (MediaQuery.of(context).size.width - 56) / 3;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, routeName),
            child: Container(
              width: itemWidth,
              height: itemWidth,
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBackground : AppColor.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark
                    ? Border.all(
                  color: AppColor.movBlue.withValues(alpha: 0.8),
                  width: 1.5,
                )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    width: itemWidth * 0.50,
                    height: itemWidth * 0.50,
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColor.white : AppColor.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );}
  }