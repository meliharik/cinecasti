class GetLanguage {
  static String getLanguage(String languageCode) {
    if (languageCode == 'tr') {
      return 'Türkçe';
    } else if (languageCode == 'en') {
      return 'English';
    } else if (languageCode == 'ru') {
      return 'Русский';
    } else if (languageCode == 'de') {
      return 'Deutsch';
    } else if (languageCode == 'fr') {
      return 'Français';
    } else if (languageCode == 'es') {
      return 'Español';
    } else if (languageCode == 'it') {
      return 'Italiano';
    } else if (languageCode == 'pt') {
      return 'Português';
    } else if (languageCode == 'zh') {
      return '中文';
    } else if (languageCode == 'ja') {
      return '日本語';
    } else if (languageCode == 'ko') {
      return '한국어';
    } else if (languageCode == 'hi') {
      return 'हिंदी';
    } else {
      return 'English';
    }
  }
}
