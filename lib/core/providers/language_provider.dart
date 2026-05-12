import 'package:flutter/material.dart';
import 'package:hajj_companion/core/utils/app_localizations.dart';

/// Single source of truth for the app's language state.
/// Both main.dart and main_mobile.dart use this class so that
/// every screen finds the same type in the widget tree.
class LanguageProvider extends InheritedWidget {
  final String language;
  final AppLocalizations localizations;

  const LanguageProvider({
    super.key,
    required this.language,
    required this.localizations,
    required super.child,
  });

  static LanguageProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanguageProvider>();
  }

  @override
  bool updateShouldNotify(LanguageProvider oldWidget) {
    return language != oldWidget.language;
  }
}
