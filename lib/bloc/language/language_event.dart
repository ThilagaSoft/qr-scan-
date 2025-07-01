import 'package:map_pro/model/language_model.dart';

abstract class LanguageEvent {}

/// Event to load all available languages
class LoadLanguages extends LanguageEvent {}

/// Event to select a specific language
class SelectLanguage extends LanguageEvent {
  final LanguageModel selectedLanguage;

  SelectLanguage(this.selectedLanguage);
}
