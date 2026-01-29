class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(String language) {
    return AppLocalizations(language == 'Arabic' ? 'ar' : 'en');
  }

  // Common
  String get appTitle =>
      languageCode == 'ar' ? 'رفيق الحج والعمرة' : 'Hajj & Umrah Companion';
  String get save => languageCode == 'ar' ? 'حفظ' : 'Save';
  String get cancel => languageCode == 'ar' ? 'إلغاء' : 'Cancel';
  String get delete => languageCode == 'ar' ? 'حذف' : 'Delete';
  String get edit => languageCode == 'ar' ? 'تعديل' : 'Edit';
  String get share => languageCode == 'ar' ? 'مشاركة' : 'Share';
  String get back => languageCode == 'ar' ? 'رجوع' : 'Back';

  // Home Screen
  String get welcomeMessage => languageCode == 'ar'
      ? 'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ'
      : 'In the name of Allah, the Most Gracious, the Most Merciful';
  String get homeTitle => languageCode == 'ar'
      ? 'رفيق الحج والعمرة الذكي'
      : 'Smart Hajj & Umrah Companion';
  String get digitalPermit =>
      languageCode == 'ar' ? 'التصريح الرقمي' : 'Digital Permit';
  String get viewPermit => languageCode == 'ar' ? 'عرض التصريح' : 'View Permit';
  String get ritualGuide =>
      languageCode == 'ar' ? 'دليل المناسك' : 'Ritual Guide';
  String get locationTracking =>
      languageCode == 'ar' ? 'تتبع الموقع' : 'Location Tracking';
  String get familySafety =>
      languageCode == 'ar' ? 'سلامة العائلة' : 'Family Safety';
  String get settings => languageCode == 'ar' ? 'الإعدادات' : 'Settings';

  // Permit Entry
  String get enterPermitInfo => languageCode == 'ar'
      ? 'إدخال معلومات التصريح'
      : 'Enter Permit Information';
  String get permitType => languageCode == 'ar' ? 'نوع التصريح' : 'Permit Type';
  String get hajj => languageCode == 'ar' ? 'حج' : 'Hajj';
  String get umrah => languageCode == 'ar' ? 'عمرة' : 'Umrah';
  String get permitNumber =>
      languageCode == 'ar' ? 'رقم التصريح' : 'Permit Number';
  String get enterPermitNumber =>
      languageCode == 'ar' ? 'أدخل رقم التصريح' : 'Enter your permit number';
  String get fullName => languageCode == 'ar' ? 'الاسم الكامل' : 'Full Name';
  String get enterFullName =>
      languageCode == 'ar' ? 'أدخل اسمك الكامل' : 'Enter your full name';
  String get validityPeriod =>
      languageCode == 'ar' ? 'فترة الصلاحية' : 'Validity Period';
  String get startDate => languageCode == 'ar' ? 'تاريخ البداية' : 'Start Date';
  String get endDate => languageCode == 'ar' ? 'تاريخ النهاية' : 'End Date';
  String get selectStartDate =>
      languageCode == 'ar' ? 'اختر تاريخ البداية' : 'Select start date';
  String get selectEndDate =>
      languageCode == 'ar' ? 'اختر تاريخ النهاية' : 'Select end date';
  String get savePermitInfo =>
      languageCode == 'ar' ? 'حفظ معلومات التصريح' : 'Save Permit Information';
  String get saving => languageCode == 'ar' ? 'جاري الحفظ...' : 'Saving...';

  // Validation Messages
  String get pleaseEnterPermitNumber => languageCode == 'ar'
      ? 'الرجاء إدخال رقم التصريح'
      : 'Please enter permit number';
  String get pleaseEnterFullName => languageCode == 'ar'
      ? 'الرجاء إدخال الاسم الكامل'
      : 'Please enter your full name';
  String get pleaseSelectDates => languageCode == 'ar'
      ? 'الرجاء اختيار تاريخي البداية والنهاية'
      : 'Please select both start and end dates';
  String get permitSavedSuccess => languageCode == 'ar'
      ? 'تم حفظ التصريح بنجاح مع التشفير!'
      : 'Permit saved successfully with encryption!';
  String get errorSavingPermit =>
      languageCode == 'ar' ? 'خطأ في حفظ التصريح' : 'Error saving permit';

  // Permit Display
  String get digitalPermitTitle =>
      languageCode == 'ar' ? 'التصريح الرقمي' : 'Digital Permit';
  String get noPermitFound =>
      languageCode == 'ar' ? 'لم يتم العثور على تصريح' : 'No permit found';
  String get addPermit => languageCode == 'ar' ? 'إضافة تصريح' : 'Add Permit';
  String get hajjPermit => languageCode == 'ar' ? 'تصريح حج' : 'Hajj Permit';
  String get umrahPermit =>
      languageCode == 'ar' ? 'تصريح عمرة' : 'Umrah Permit';
  String get kingdomOfSaudiArabia => languageCode == 'ar'
      ? 'المملكة العربية السعودية'
      : 'Kingdom of Saudi Arabia';
  String get validFrom => languageCode == 'ar' ? 'صالح من' : 'Valid From';
  String get validUntil => languageCode == 'ar' ? 'صالح حتى' : 'Valid Until';
  String get validPermit =>
      languageCode == 'ar' ? 'تصريح صالح' : 'Valid Permit';
  String get showAtCheckpoints => languageCode == 'ar'
      ? 'اعرض هذه الشاشة لضباط الأمن عند نقاط التفتيش'
      : 'Show this screen to security officers at checkpoints';
  String get raiseWrist => languageCode == 'ar'
      ? 'ارفع معصمك لعرض تصريحك بسرعة'
      : 'Raise your wrist to quickly display your permit';
  String get deletePermit =>
      languageCode == 'ar' ? 'حذف التصريح' : 'Delete Permit';
  String get deletePermitConfirm => languageCode == 'ar'
      ? 'هل أنت متأكد من حذف هذا التصريح؟ لا يمكن التراجع عن هذا الإجراء.'
      : 'Are you sure you want to delete this permit? This action cannot be undone.';
  String get permitDeletedSuccess => languageCode == 'ar'
      ? 'تم حذف التصريح بنجاح'
      : 'Permit deleted successfully';
  String get errorDeletingPermit =>
      languageCode == 'ar' ? 'خطأ في حذف التصريح' : 'Error deleting permit';

  // Ritual Guidance
  String get ritualGuideTitle =>
      languageCode == 'ar' ? 'دليل المناسك' : 'Ritual Guide';
  String get selectRitualType =>
      languageCode == 'ar' ? 'اختر نوع المنسك' : 'Select Ritual Type';
  String get performingForSelf =>
      languageCode == 'ar' ? 'أداء المناسك لنفسي' : 'Performing for Myself';
  String get performingForOthers => languageCode == 'ar'
      ? 'أداء المناسك نيابة عن شخص آخر'
      : 'Performing on Behalf of Someone Else';
  String get currentLocation =>
      languageCode == 'ar' ? 'الموقع الحالي' : 'Current Location';
  String get waitingForGPS =>
      languageCode == 'ar' ? 'في انتظار إشارة GPS...' : 'Waiting for GPS...';
  String get nearbyRitualSites =>
      languageCode == 'ar' ? 'المواقع المقدسة القريبة' : 'Nearby Ritual Sites';
  String get noRitualSitesNearby => languageCode == 'ar'
      ? 'لا توجد مواقع مقدسة قريبة'
      : 'No ritual sites nearby';

  // Family Safety
  String get familySafetyTitle =>
      languageCode == 'ar' ? 'سلامة العائلة' : 'Family Safety';
  String get createFamilyGroup =>
      languageCode == 'ar' ? 'إنشاء مجموعة عائلية' : 'Create Family Group';
  String get addFamilyMember =>
      languageCode == 'ar' ? 'إضافة فرد للعائلة' : 'Add Family Member';
  String get familyMembers =>
      languageCode == 'ar' ? 'أفراد العائلة' : 'Family Members';
  String get childMonitoring =>
      languageCode == 'ar' ? 'مراقبة الأطفال' : 'Child Monitoring';
  String get safeDistance =>
      languageCode == 'ar' ? 'المسافة الآمنة' : 'Safe Distance';
  String get distanceAlert =>
      languageCode == 'ar' ? 'تنبيه المسافة' : 'Distance Alert';
  String get meters => languageCode == 'ar' ? 'متر' : 'meters';
  String get viewOnMap =>
      languageCode == 'ar' ? 'عرض على الخريطة' : 'View on Map';

  // Permissions
  String get permissionRequired =>
      languageCode == 'ar' ? 'الإذن مطلوب' : 'Permission Required';
  String get locationPermissionMessage => languageCode == 'ar'
      ? 'هذا التطبيق يحتاج إلى إذن الموقع لتتبع المناسك وسلامة العائلة'
      : 'This app needs location permission for ritual tracking and family safety';
  String get grantPermission =>
      languageCode == 'ar' ? 'منح الإذن' : 'Grant Permission';

  // Settings
  String get settingsTitle => languageCode == 'ar' ? 'الإعدادات' : 'Settings';
  String get languageSettings =>
      languageCode == 'ar' ? 'إعدادات اللغة' : 'Language Settings';
  String get language => languageCode == 'ar' ? 'اللغة' : 'Language';
  String get selectLanguage =>
      languageCode == 'ar' ? 'اختر اللغة' : 'Select Language';
  String get english => languageCode == 'ar' ? 'English' : 'English';
  String get arabic => languageCode == 'ar' ? 'العربية' : 'Arabic - العربية';
  String get guidanceSettings =>
      languageCode == 'ar' ? 'إعدادات التوجيه' : 'Guidance Settings';
  String get audioGuidance =>
      languageCode == 'ar' ? 'التوجيه الصوتي' : 'Audio Guidance';
  String get playDuas => languageCode == 'ar'
      ? 'تشغيل الأدعية عبر سماعات الأذن'
      : 'Play duas through earphones';
  String get audioVolume =>
      languageCode == 'ar' ? 'مستوى الصوت' : 'Audio Volume';
  String get hapticFeedback =>
      languageCode == 'ar' ? 'الاهتزاز التنبيهي' : 'Haptic Feedback';
  String get vibrationAlerts => languageCode == 'ar'
      ? 'تنبيهات الاهتزاز للمواقع'
      : 'Vibration alerts for locations';
  String get locationSettings =>
      languageCode == 'ar' ? 'إعدادات الموقع' : 'Location Settings';
  String get locationServices =>
      languageCode == 'ar' ? 'خدمات الموقع' : 'Location Services';
  String get enableGPS =>
      languageCode == 'ar' ? 'تفعيل تتبع GPS' : 'Enable GPS tracking';
  String get gestureSettings =>
      languageCode == 'ar' ? 'إعدادات الإيماءات' : 'Gesture Settings';
  String get wristRaiseGesture =>
      languageCode == 'ar' ? 'إيماءة رفع المعصم' : 'Wrist-Raise Gesture';
  String get autoDisplayPermit => languageCode == 'ar'
      ? 'عرض التصريح تلقائياً عند رفع المعصم'
      : 'Auto-display permit on wrist raise';
  String get about => languageCode == 'ar' ? 'حول' : 'About';
  String get appVersion =>
      languageCode == 'ar' ? 'إصدار التطبيق' : 'App Version';
  String get privacyPolicy =>
      languageCode == 'ar' ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get helpSupport =>
      languageCode == 'ar' ? 'المساعدة والدعم' : 'Help & Support';
}
