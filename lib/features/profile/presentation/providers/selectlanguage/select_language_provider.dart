import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'select_language_notifier.dart';

/// Notifier Provider
final selectLanguageNotifierProvider =
    StateNotifierProvider<SelectLanguageNotifier, SelectLanguageState>(
      (ref) => SelectLanguageNotifier(),
    );
