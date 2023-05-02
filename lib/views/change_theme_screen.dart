import 'package:flutter/material.dart';
import 'package:sal_sat/generated/locale_keys.g.dart';
import '/controllers/settings_controller.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import  'package:easy_localization/src/public_ext.dart';
class ChangeThemeScreen extends StatelessWidget {
  const ChangeThemeScreen({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/ChangeThemeScreen';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.Theme)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButton<ThemeMode>(
          value: controller.themeMode,
          onChanged: (themeMode) {
            controller.updateThemeMode(themeMode!);
          },
          items:  [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text(tr(LocaleKeys.System_Theme)),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text(tr(LocaleKeys.Light_Theme)),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text(tr(LocaleKeys.Dark_Theme)),
            )
          ],
        ),
      ),
    );
  }
}