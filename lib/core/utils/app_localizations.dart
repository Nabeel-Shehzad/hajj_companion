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

  // AI Chat
  String get aiAssistant =>
      languageCode == 'ar' ? 'المساعد الذكي' : 'AI Assistant';
  String get aiChatHistory => languageCode == 'ar'
      ? 'سجل محادثات الذكاء الاصطناعي'
      : 'AI Chat History';
  String get newChat =>
      languageCode == 'ar' ? 'محادثة جديدة' : 'New Chat';
  String get noConversationsYet =>
      languageCode == 'ar' ? 'لا توجد محادثات بعد' : 'No conversations yet';
  String get startFirstChat =>
      languageCode == 'ar' ? 'ابدأ أول محادثة' : 'Start First Chat';
  String get startConversation =>
      languageCode == 'ar' ? 'ابدأ محادثة' : 'Start a conversation';
  String get askAboutHajjUmrah => languageCode == 'ar'
      ? 'اسأل عن الحج أو العمرة...'
      : 'Ask about Hajj or Umrah...';
  String get askMeAnything => languageCode == 'ar'
      ? 'اسألني أي شيء عن الحج والعمرة!'
      : 'Ask me anything about Hajj and Umrah!';
  String get thinking =>
      languageCode == 'ar' ? 'جاري التفكير...' : 'Thinking...';
  String get sampleQuestionsLabel =>
      languageCode == 'ar' ? 'أسئلة نموذجية:' : 'Sample Questions:';
  String get clearAllChats =>
      languageCode == 'ar' ? 'مسح جميع المحادثات' : 'Clear all chats';
  String get deleteChat =>
      languageCode == 'ar' ? 'حذف المحادثة' : 'Delete Chat';
  String get renameChat =>
      languageCode == 'ar' ? 'إعادة تسمية المحادثة' : 'Rename Chat';
  String get chatTitle =>
      languageCode == 'ar' ? 'عنوان المحادثة' : 'Chat Title';
  String get deleteConversationConfirm => languageCode == 'ar'
      ? 'هل أنت متأكد من حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.'
      : 'Are you sure you want to delete this conversation? This cannot be undone.';
  String get clearAllConfirm => languageCode == 'ar'
      ? 'هل أنت متأكد من حذف جميع المحادثات؟ لا يمكن التراجع عن هذا الإجراء.'
      : 'Are you sure you want to delete all conversations? This cannot be undone.';
  String get clearAll =>
      languageCode == 'ar' ? 'مسح الكل' : 'Clear All';
  String get todayAt =>
      languageCode == 'ar' ? 'اليوم في' : 'Today at';
  String get yesterday =>
      languageCode == 'ar' ? 'أمس' : 'Yesterday';
  String get daysAgoLabel =>
      languageCode == 'ar' ? 'أيام مضت' : 'days ago';
  String get rename =>
      languageCode == 'ar' ? 'إعادة التسمية' : 'Rename';

  // Ritual Selection
  String get ritualGuidanceSettings => languageCode == 'ar'
      ? 'إعدادات دليل المناسك'
      : 'Ritual Guidance Settings';
  String get performingRitualFor =>
      languageCode == 'ar' ? 'أداء المناسك لـ' : 'Performing Ritual For';
  String get forMyself =>
      languageCode == 'ar' ? 'لنفسي' : 'For Myself';
  String get onBehalfOfSomeone =>
      languageCode == 'ar' ? 'نيابة عن شخص آخر' : 'On Behalf of Someone';
  String get standardDuasDesc => languageCode == 'ar'
      ? 'الأدعية المعيارية للمناسك الشخصية'
      : 'Standard duas for personal rituals';
  String get modifiedDuasDesc => languageCode == 'ar'
      ? 'الأدعية المعدلة للمناسك بالنيابة'
      : 'Modified duas for proxy rituals';
  String get startGPSGuidance =>
      languageCode == 'ar' ? 'بدء التوجيه بالـ GPS' : 'Start GPS Guidance';
  String get locationAutoDetect => languageCode == 'ar'
      ? 'سيقوم التطبيق تلقائياً باكتشاف موقعك وتوفير الأدعية المناسبة'
      : 'The app will automatically detect your location and provide appropriate duas';
  String get locationAutoDetect2 => languageCode == 'ar'
      ? 'سيكتشف موقعك تلقائياً ويعرض الأدعية المناسبة عند المواقع المقدسة'
      : 'Your location will automatically detect nearby holy sites and display appropriate duas';

  // Location Tracking
  String get locationTrackingTitle =>
      languageCode == 'ar' ? 'تتبع الموقع' : 'Location Tracking';
  String get trackingActive =>
      languageCode == 'ar' ? 'التتبع نشط' : 'Tracking Active';
  String get trackingPaused =>
      languageCode == 'ar' ? 'التتبع متوقف مؤقتاً' : 'Tracking Paused';
  String get duasForLocation =>
      languageCode == 'ar' ? 'أدعية هذا الموقع' : 'Duas for This Location';
  String get gpsCoordinates =>
      languageCode == 'ar' ? 'إحداثيات GPS' : 'GPS Coordinates';
  String get accuracyLabel =>
      languageCode == 'ar' ? 'الدقة' : 'Accuracy';
  String get currentLocationTitle =>
      languageCode == 'ar' ? 'الموقع الحالي' : 'Current Location';
  String get enableLocationServices => languageCode == 'ar'
      ? 'الرجاء تفعيل خدمات الموقع لاستخدام التوجيه في المناسك.'
      : 'Please enable location services to use ritual guidance.';
  String get openSettings =>
      languageCode == 'ar' ? 'فتح الإعدادات' : 'Open Settings';
  String get stopAudio =>
      languageCode == 'ar' ? 'إيقاف' : 'Stop';
  String get playArabic =>
      languageCode == 'ar' ? 'عربي' : 'Arabic';
  String get playEnglish =>
      languageCode == 'ar' ? 'إنجليزي' : 'English';
  String get guidanceSettingsTitle =>
      languageCode == 'ar' ? 'إعدادات التوجيه' : 'Guidance Settings';
  String get locationPermissionMsg2 => languageCode == 'ar'
      ? 'هذا التطبيق يحتاج إلى إذن الموقع لتوفير التوجيه في المناسك. الرجاء تفعيل خدمات الموقع.'
      : 'This app needs location access to provide ritual guidance. Please enable location services.';
  String get goBack =>
      languageCode == 'ar' ? 'الرجوع' : 'Go Back';

  // Family Safety
  String get keepFamilySafe =>
      languageCode == 'ar' ? 'حافظ على سلامة عائلتك' : 'Keep Your Family Safe';
  String get familySafetyDesc => languageCode == 'ar'
      ? 'شارك موقعك مع أفراد عائلتك واحصل على تنبيه عند تجاوز الأطفال للمسافة الآمنة.'
      : 'Share your location with family members and get alerted if children exceed safe distances.';
  String get joinExistingGroup =>
      languageCode == 'ar' ? 'الانضمام إلى مجموعة موجودة' : 'Join Existing Group';
  String get viewFamilyLocations =>
      languageCode == 'ar' ? 'عرض مواقع العائلة' : 'View Family Locations';
  String get leaveGroup =>
      languageCode == 'ar' ? 'مغادرة المجموعة' : 'Leave Group';
  String get leaveGroupConfirm => languageCode == 'ar'
      ? 'هل أنت متأكد من مغادرة هذه المجموعة العائلية؟ ستحتاج إلى رمز انضمام للعودة.'
      : 'Are you sure you want to leave this family group? You will need a join code to rejoin.';
  String get joinCodeLabel =>
      languageCode == 'ar' ? 'رمز الانضمام' : 'Join Code';
  String get adminBadge =>
      languageCode == 'ar' ? 'مدير' : 'ADMIN';
  String get joinCodeCopied =>
      languageCode == 'ar' ? 'تم نسخ رمز الانضمام!' : 'Join code copied to clipboard!';
  String get showQrCode =>
      languageCode == 'ar' ? 'عرض رمز QR' : 'Show QR code';
  String get copyJoinCodeLabel =>
      languageCode == 'ar' ? 'نسخ رمز الانضمام' : 'Copy join code';
  String get leave =>
      languageCode == 'ar' ? 'مغادرة' : 'Leave';
}
