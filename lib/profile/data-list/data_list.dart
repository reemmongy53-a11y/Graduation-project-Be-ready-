import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/logOut/logout_cubit.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/providers/languageProvider.dart';
import 'package:new_project/routes.dart';
import 'package:provider/provider.dart';

enum Themes { light, dark }

class DataList extends StatelessWidget {
  const DataList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final dark = provider.isDarkMode;
    final selectedTheme = provider.isDarkMode ? Themes.dark : Themes.light;

    return BlocProvider(
      create: (_) => getIt<LogoutCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<LogoutCubit, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.authScreen.name);
              }
            },
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(AppImage.person),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserSession.name.isEmpty ? "Your Name" : UserSession.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          UserSession.email.isEmpty ? "email@gmail.com" : UserSession.email,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(
                  thickness: 1,
                  color: dark
                      ? AppColor.movBlue.withValues(alpha: 0.3)
                      : AppColor.softGray.withValues(alpha: 0.5),
                ),

                _ListItem(
                  icon: Icons.person_outline,
                  title: AppLocalizations.of(context)!.my_profile,
                  // ✅ trailing بعرض ثابت
                  trailing: SizedBox(
                    width: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.profile.name),
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: dark ? AppColor.softGray : AppColor.gray,
                      ),
                    ),
                  ),
                ),

                _ExpandableItem(
                  icon: Icons.settings_outlined,
                  title: AppLocalizations.of(context)!.settings,
                  children: [
                    _DropdownRow<Themes>(
                      label: AppLocalizations.of(context)!.theme,
                      value: selectedTheme,
                      items: Themes.values,
                      onChanged: (item) {
                        if (item == null) return;
                        provider.changeTheme(
                          item == Themes.light ? ThemeMode.light : ThemeMode.dark,
                        );
                      },
                    ),
                    _DropdownRow<Locale>(
                      label: AppLocalizations.of(context)!.language,
                      value: languageProvider.getSelectedLocale(),
                      items: languageProvider.getSupportedLocales(),
                      onChanged: (locale) {
                        if (locale == null) return;
                        languageProvider.changeLocale(locale);
                      },
                    ),
                  ],
                ),

                _ExpandableItem(
                  icon: Icons.notifications_outlined,
                  title: AppLocalizations.of(context)!.notification,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NotificationButton(
                            label: AppLocalizations.of(context)!.allow,
                            isSelected: true),
                        _NotificationButton(
                            label: AppLocalizations.of(context)!.mute,
                            isSelected: false),
                      ],
                    ),
                  ],
                ),

                Divider(
                  thickness: 1,
                  color: dark
                      ? AppColor.movBlue.withValues(alpha: 0.3)
                      : AppColor.softGray.withValues(alpha: 0.5),
                ),

                _ListItem(
                  icon: Icons.logout,
                  title: AppLocalizations.of(context)!.logout,
                  color: AppColor.red,
                  trailing: const SizedBox(width: 32), // ✅ نفس العرض
                  onTap: () => context.read<LogoutCubit>().logout(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final Color? color;
  final VoidCallback? onTap;

  const _ListItem({
    required this.icon,
    required this.title,
    required this.trailing,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color ?? (dark ? AppColor.softGray : AppColor.gray),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color ?? (dark ? AppColor.white : AppColor.black),
                  ),
                ),
              ],
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _ExpandableItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _ExpandableItem({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  State<_ExpandableItem> createState() => _ExpandableItemState();
}

class _ExpandableItemState extends State<_ExpandableItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.icon,
                        color: dark ? AppColor.softGray : AppColor.gray),
                    const SizedBox(width: 8),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: dark ? AppColor.white : AppColor.black,
                      ),
                    ),
                  ],
                ),
                // ✅ نفس العرض الثابت
                SizedBox(
                  width: 32,
                  child: Icon(
                    isExpanded ? Icons.close : Icons.arrow_forward_ios,
                    size: 16,
                    color: dark ? AppColor.softGray : AppColor.gray,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: dark ? AppColor.navy : AppColor.primary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: dark
                    ? AppColor.movBlue.withValues(alpha: 0.4)
                    : AppColor.softBlue,
                width: 1,
              ),
            ),
            child: Column(children: widget.children),
          ),
      ],
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: dark ? AppColor.white : AppColor.black,
          ),
        ),
        DropdownButton<T>(
          value: value,
          underline: const SizedBox(),
          dropdownColor: dark ? AppColor.navy : AppColor.primary,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: dark ? AppColor.softGray : AppColor.gray,
          ),
          style: TextStyle(
            color: dark ? AppColor.white : AppColor.black,
            fontSize: 14,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.toString().split('.').last),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _NotificationButton extends StatefulWidget {
  final String label;
  final bool isSelected;

  const _NotificationButton({
    required this.label,
    required this.isSelected,
  });

  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<_NotificationButton> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: () => setState(() => isSelected = !isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.royalBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dark ? AppColor.movBlue : AppColor.royalBlue,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: isSelected
                ? AppColor.white
                : dark
                ? AppColor.softGray
                : AppColor.royalBlue,
          ),
        ),
      ),
    );
  }
}