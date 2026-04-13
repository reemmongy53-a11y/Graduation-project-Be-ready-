import 'package:flutter/material.dart';
import 'package:new_project/design/AppColor.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.image,
    required this.body,
    this.icons,
    this.route,
    this.onIconPressed,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final String? image;
  final Icon? icons;
  final Widget body;
  final String? route;
  final VoidCallback? onIconPressed;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: -10,
        title: image != null
            ? Image.asset(image!, width: screenWidth * 0.3)
            : null,
        actions: icons == null
            ? null
            : [
          IconButton(onPressed: onIconPressed, icon: icons!),
          const SizedBox(width: 10),
        ],
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation:
      floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
    );
  }
}
