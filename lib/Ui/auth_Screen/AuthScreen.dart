import 'package:flutter/material.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'LogIn Screen/LoginForm.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImage.Logo, width: 200, height: 150),
            Text(
              AppLocalizations.of(context)!.get_started,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.login_subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 30),
            Expanded(
              child: LoginForm(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}