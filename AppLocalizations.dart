import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Government Schemes',
      'search': 'Search schemes...',
      'all': 'All',
      'agriculture': 'Agriculture',
      'education': 'Education',
      'health': 'Health',
      'housing': 'Housing',
      'socialWelfare': 'Social Welfare',
      'readMore': 'Read More',
      'schemeDetails': 'Scheme Details',
      'description': 'Description',
      'eligibility': 'Eligibility Criteria',
      'requiredDocs': 'Required Documents',
      'applyNow': 'Apply Now',
      'noSchemes': 'No schemes found',
      'loading': 'Loading...',
      'retry': 'Retry',
      'error': 'Failed to load schemes. Please try again.',
      'linkError': 'Could not open the application link',
      'linkNotAvailable': 'Application link not available',
    },
    'mr': {
      'title': 'सरकारी योजना',
      'search': 'योजना शोधा...',
      'all': 'सर्व',
      'agriculture': 'शेती',
      'education': 'शिक्षण',
      'health': 'आरोग्य',
      'housing': 'गृहनिर्माण',
      'socialWelfare': 'समाज कल्याण',
      'readMore': 'अधिक वाचा',
      'schemeDetails': 'योजना तपशील',
      'description': 'वर्णन',
      'eligibility': 'पात्रता निकष',
      'requiredDocs': 'आवश्यक कागदपत्रे',
      'applyNow': 'आता अर्ज करा',
      'noSchemes': 'कोणतीही योजना सापडली नाही',
      'loading': 'लोड होत आहे...',
      'retry': 'पुन्हा प्रयत्न करा',
      'error': 'योजना लोड करण्यात अयशस्वी. कृपया पुन्हा प्रयत्न करा.',
      'linkError': 'अर्ज लिंक उघडू शकत नाही',
      'linkNotAvailable': 'अर्ज लिंक उपलब्ध नाही',
    },
    'hi': {
      'title': 'सरकारी योजनाएँ',
      'search': 'योजनाएँ खोजें...',
      'all': 'सभी',
      'agriculture': 'कृषि',
      'education': 'शिक्षा',
      'health': 'स्वास्थ्य',
      'housing': 'आवास',
      'socialWelfare': 'समाज कल्याण',
      'readMore': 'और पढ़ें',
      'schemeDetails': 'योजना विवरण',
      'description': 'विवरण',
      'eligibility': 'पात्रता मानदंड',
      'requiredDocs': 'आवश्यक दस्तावेज',
      'applyNow': 'अभी आवेदन करें',
      'noSchemes': 'कोई योजना नहीं मिली',
      'loading': 'लोड हो रहा है...',
      'retry': 'पुनः प्रयास करें',
      'error': 'योजनाओं को लोड करने में विफल। कृपया पुनः प्रयास करें।',
      'linkError': 'आवेदन लिंक नहीं खोल सका',
      'linkNotAvailable': 'आवेदन लिंक उपलब्ध नहीं है',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String get title => translate('title');
  String get search => translate('search');
  String get all => translate('all');
  String get agriculture => translate('agriculture');
  String get education => translate('education');
  String get health => translate('health');
  String get housing => translate('housing');
  String get socialWelfare => translate('socialWelfare');
  String get readMore => translate('readMore');
  String get schemeDetails => translate('schemeDetails');
  String get description => translate('description');
  String get eligibility => translate('eligibility');
  String get requiredDocs => translate('requiredDocs');
  String get applyNow => translate('applyNow');
  String get noSchemes => translate('noSchemes');
  String get loading => translate('loading');
  String get retry => translate('retry');
  String get error => translate('error');
  String get linkError => translate('linkError');
  String get linkNotAvailable => translate('linkNotAvailable');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'mr', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
