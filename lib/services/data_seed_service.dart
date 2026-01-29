import 'package:drift/drift.dart' show Value;
import '../database/app_database.dart';

/// Seeds initial data for duas and geofence locations
class DataSeedService {
  final AppDatabase _database;

  // ⚠️ TEST MODE: Set to true for local testing, false for production
  static const bool isTestMode = true;

  // 🧪 TEST COORDINATES: Change these to your current location for testing
  // Use Google Maps to get your coordinates (right-click > "What's here?")
  static const double testBaseLat = 31.5204; // Example: Lahore, Pakistan
  static const double testBaseLng = 74.3587;
  
  DataSeedService(this._database);

  /// Initialize all ritual data (holy sites and duas)
  Future<void> seedInitialData() async {
    final existingLocations = await _database.getAllLocations();
    if (existingLocations.isEmpty) {
      await _seedHolySites();
      await _seedDuas();
    }
  }

  /// Seed holy site locations with GPS coordinates
  Future<void> _seedHolySites() async {
    final locations = isTestMode ? _getTestLocations() : _getProductionLocations();
    await _database.insertMultipleLocations(locations);
  }

  /// 🧪 TEST LOCATIONS: Small offsets around your current location
  List<GeofenceLocationsCompanion> _getTestLocations() {
    return [
      // Test Location 1 - Your current position (0m offset)
      GeofenceLocationsCompanion.insert(
        locationId: 'test_kaaba',
        nameEn: 'Test: Holy Kaaba',
        nameAr: 'الكعبة المشرفة (اختبار)',
        description: 'TEST MODE - Walk here to test',
        latitude: testBaseLat,
        longitude: testBaseLng,
        radiusMeters: 50.0,
        ritualName: 'general',
      ),

      // Test Location 2 - 50 meters north
      GeofenceLocationsCompanion.insert(
        locationId: 'test_tawaf',
        nameEn: 'Test: Tawaf Area',
        nameAr: 'منطقة الطواف (اختبار)',
        description: 'TEST MODE - Walk 50m north to trigger',
        latitude: testBaseLat + 0.00045, // ~50m north
        longitude: testBaseLng,
        radiusMeters: 40.0,
        ritualName: 'tawaf',
      ),

      // Test Location 3 - 50 meters east
      GeofenceLocationsCompanion.insert(
        locationId: 'test_maqam',
        nameEn: 'Test: Maqam Ibrahim',
        nameAr: 'مقام إبراهيم (اختبار)',
        description: 'TEST MODE - Walk 50m east to trigger',
        latitude: testBaseLat,
        longitude: testBaseLng + 0.00045, // ~50m east
        radiusMeters: 30.0,
        ritualName: 'tawaf',
      ),

      // Test Location 4 - 100 meters south
      GeofenceLocationsCompanion.insert(
        locationId: 'test_safa',
        nameEn: 'Test: Mount Safa',
        nameAr: 'الصفا (اختبار)',
        description: 'TEST MODE - Walk 100m south to trigger',
        latitude: testBaseLat - 0.0009, // ~100m south
        longitude: testBaseLng,
        radiusMeters: 40.0,
        ritualName: 'sai',
      ),

      // Test Location 5 - 100 meters west
      GeofenceLocationsCompanion.insert(
        locationId: 'test_marwah',
        nameEn: 'Test: Mount Marwah',
        nameAr: 'المروة (اختبار)',
        description: 'TEST MODE - Walk 100m west to trigger',
        latitude: testBaseLat,
        longitude: testBaseLng - 0.0009, // ~100m west
        radiusMeters: 40.0,
        ritualName: 'sai',
      ),
    ];
  }

  /// 🕋 PRODUCTION LOCATIONS: Actual Makkah coordinates
  List<GeofenceLocationsCompanion> _getProductionLocations() {
    return [
      // PRODUCTION: Kaaba - Center point
      GeofenceLocationsCompanion.insert(
        locationId: 'kaaba_center',
        nameEn: 'Holy Kaaba',
        nameAr: 'الكعبة المشرفة',
        description: 'The center of the Grand Mosque',
        latitude: 21.4225,
        longitude: 39.8262,
        radiusMeters: 30.0,
        ritualName: 'general',
      ),

      // PRODUCTION: Tawaf Area
      GeofenceLocationsCompanion.insert(
        locationId: 'tawaf_area',
        nameEn: 'Tawaf Area',
        nameAr: 'منطقة الطواف',
        description: 'Circumambulation area around the Kaaba',
        latitude: 21.4225,
        longitude: 39.8262,
        radiusMeters: 100.0,
        ritualName: 'tawaf',
      ),

      // PRODUCTION: Maqam Ibrahim
      GeofenceLocationsCompanion.insert(
        locationId: 'maqam_ibrahim',
        nameEn: 'Maqam Ibrahim',
        nameAr: 'مقام إبراهيم',
        description: 'Station of Abraham - Prayer location after Tawaf',
        latitude: 21.4226,
        longitude: 39.8264,
        radiusMeters: 20.0,
        ritualName: 'tawaf',
      ),

      // PRODUCTION: Zamzam Well
      GeofenceLocationsCompanion.insert(
        locationId: 'zamzam',
        nameEn: 'Zamzam Well',
        nameAr: 'بئر زمزم',
        description: 'The blessed well of Zamzam water',
        latitude: 21.4227,
        longitude: 39.8263,
        radiusMeters: 30.0,
        ritualName: 'general',
      ),

      // PRODUCTION: Safa - Start of Sa'i
      GeofenceLocationsCompanion.insert(
        locationId: 'safa',
        nameEn: 'Mount Safa',
        nameAr: 'الصفا',
        description: 'Starting point of Sa\'i between Safa and Marwah',
        latitude: 21.4228,
        longitude: 39.8265,
        radiusMeters: 25.0,
        ritualName: 'sai',
      ),

      // PRODUCTION: Marwah - End of Sa'i
      GeofenceLocationsCompanion.insert(
        locationId: 'marwah',
        nameEn: 'Mount Marwah',
        nameAr: 'المروة',
        description: 'Ending point of Sa\'i between Safa and Marwah',
        latitude: 21.4230,
        longitude: 39.8280,
        radiusMeters: 25.0,
        ritualName: 'sai',
      ),

      // PRODUCTION: Green Pillars (Sai Running Section)
      GeofenceLocationsCompanion.insert(
        locationId: 'green_pillars',
        nameEn: 'Green Pillars',
        nameAr: 'الميلين الأخضرين',
        description: 'Section where men should run during Sa\'i',
        latitude: 21.4229,
        longitude: 39.8272,
        radiusMeters: 15.0,
        ritualName: 'sai',
      ),

      // PRODUCTION: Multazam - Between Kaaba door and Black Stone
      GeofenceLocationsCompanion.insert(
        locationId: 'multazam',
        nameEn: 'Al-Multazam',
        nameAr: 'الملتزم',
        description: 'The area between the door of Kaaba and Black Stone',
        latitude: 21.4224,
        longitude: 39.8263,
        radiusMeters: 15.0,
        ritualName: 'tawaf',
      ),

      // PRODUCTION: Black Stone
      GeofenceLocationsCompanion.insert(
        locationId: 'black_stone',
        nameEn: 'The Black Stone',
        nameAr: 'الحجر الأسود',
        description: 'Sacred stone where Tawaf begins',
        latitude: 21.4223,
        longitude: 39.8261,
        radiusMeters: 10.0,
        ritualName: 'tawaf',
      ),

      // PRODUCTION: Hijr Ismail
      GeofenceLocationsCompanion.insert(
        locationId: 'hijr_ismail',
        nameEn: 'Hijr Ismail',
        nameAr: 'حجر إسماعيل',
        description: 'The semi-circular wall adjacent to the Kaaba',
        latitude: 21.4226,
        longitude: 39.8260,
        radiusMeters: 20.0,
        ritualName: 'tawaf',
      ),
    ];

    await _database.insertMultipleLocations(locations);
  }

  /// Seed duas for different locations and ritual types
  Future<void> _seedDuas() async {
    final duas = [
      // Tawaf - Starting (Black Stone)
      DuasCompanion.insert(
        locationId: 'black_stone',
        ritualType: 'self',
        arabicText: 'بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ',
        englishTranslation: 'In the name of Allah, and Allah is the Greatest',
        transliteration: const Value('Bismillahi Wallahu Akbar'),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'black_stone',
        ritualType: 'proxy',
        arabicText:
            'بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ اللَّهُمَّ إيمَانًا بِكَ وَتَصْدِيقًا بِكِتَابِكَ',
        englishTranslation:
            'In the name of Allah, and Allah is the Greatest. O Allah, out of faith in You and believing in Your Book',
        transliteration: const Value(
          'Bismillahi Wallahu Akbar, Allahumma Imanan Bika Wa Tasdiqan Bikitabik',
        ),
        displayOrder: const Value(1),
      ),

      // During Tawaf - General
      DuasCompanion.insert(
        locationId: 'tawaf_area',
        ritualType: 'self',
        arabicText:
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        englishTranslation:
            'Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire',
        transliteration: const Value(
          'Rabbana Atina Fid-Dunya Hasanatan Wa Fil-Akhirati Hasanatan Wa Qina Adhaban-Nar',
        ),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'tawaf_area',
        ritualType: 'proxy',
        arabicText:
            'رَبَّنَا آتِهِ فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً',
        englishTranslation:
            'Our Lord, give them good in this world and good in the Hereafter',
        transliteration: const Value(
          'Rabbana Atihi Fid-Dunya Hasanatan Wa Fil-Akhirati Hasanatan',
        ),
        displayOrder: const Value(1),
      ),

      // Maqam Ibrahim - After Tawaf
      DuasCompanion.insert(
        locationId: 'maqam_ibrahim',
        ritualType: 'self',
        arabicText:
            'وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّى - رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِن ذُرِّيَّتِي',
        englishTranslation:
            'And take the standing place of Abraham as a place of prayer - My Lord, make me an establisher of prayer, and from my descendants',
        transliteration: const Value(
          'Wattakhidhu Min Maqami Ibrahima Musalla - Rabbi Ijalni Muqimas-Salati Wa Min Dhurriyati',
        ),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'maqam_ibrahim',
        ritualType: 'proxy',
        arabicText: 'رَبِّ اجْعَلْهُ مُقِيمَ الصَّلَاةِ',
        englishTranslation: 'My Lord, make them an establisher of prayer',
        transliteration: const Value('Rabbi Ijaalhu Muqimas-Salah'),
        displayOrder: const Value(1),
      ),

      // Zamzam Water
      DuasCompanion.insert(
        locationId: 'zamzam',
        ritualType: 'self',
        arabicText:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا وَاسِعًا وَشِفَاءً مِنْ كُلِّ دَاءٍ',
        englishTranslation:
            'O Allah, I ask You for beneficial knowledge, abundant provision, and healing from every disease',
        transliteration: const Value(
          'Allahumma Inni As\'aluka Ilman Nafi\'an Wa Rizqan Wasi\'an Wa Shifa\'an Min Kulli Da\'',
        ),
        displayOrder: const Value(1),
      ),

      // Safa - Starting Sa'i
      DuasCompanion.insert(
        locationId: 'safa',
        ritualType: 'self',
        arabicText:
            'إِنَّ الصَّفَا وَالْمَرْوَةَ مِن شَعَائِرِ اللَّهِ - أَبْدَأُ بِمَا بَدَأَ اللَّهُ بِهِ',
        englishTranslation:
            'Indeed, Safa and Marwah are among the symbols of Allah - I begin with what Allah began with',
        transliteration: const Value(
          'Innas-Safa Wal-Marwata Min Sha\'a\'irillah - Abda\'u Bima Bada\'allahu Bihi',
        ),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'safa',
        ritualType: 'self',
        arabicText:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        englishTranslation:
            'There is no deity except Allah, alone without partner. To Him belongs dominion and praise, and He is over all things competent',
        transliteration: const Value(
          'La Ilaha Illallahu Wahdahu La Sharika Lah, Lahul-Mulku Wa Lahul-Hamd Wa Huwa Ala Kulli Shay\'in Qadir',
        ),
        displayOrder: const Value(2),
      ),

      // Marwah - Ending Sa'i
      DuasCompanion.insert(
        locationId: 'marwah',
        ritualType: 'self',
        arabicText:
            'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ',
        englishTranslation:
            'Our Lord, accept this from us. Indeed, You are the Hearing, the Knowing',
        transliteration: const Value(
          'Rabbana Taqabbal Minna Innaka Antas-Samiul-Alim',
        ),
        displayOrder: const Value(1),
      ),

      // Multazam - Supplication spot
      DuasCompanion.insert(
        locationId: 'multazam',
        ritualType: 'self',
        arabicText:
            'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الشَّكِّ وَالشِّرْكِ وَالنِّفَاقِ',
        englishTranslation:
            'O Allah, I seek refuge in You from doubt, polytheism, and hypocrisy',
        transliteration: const Value(
          'Allahumma Inni A\'udhu Bika Minash-Shakki Wash-Shirki Wan-Nifaq',
        ),
        displayOrder: const Value(1),
      ),

      // Kaaba Center - General
      DuasCompanion.insert(
        locationId: 'kaaba_center',
        ritualType: 'self',
        arabicText:
            'اللَّهُمَّ زِدْ هَذَا الْبَيْتَ تَشْرِيفًا وَتَعْظِيمًا وَتَكْرِيمًا وَمَهَابَةً',
        englishTranslation:
            'O Allah, increase this House in honor, esteem, nobility, and reverence',
        transliteration: const Value(
          'Allahumma Zid Hadhal-Baita Tashrīfan Wa Ta\'ziman Wa Takriman Wa Mahabah',
        ),
        displayOrder: const Value(1),
      ),
    ];

    await _database.insertMultipleDuas(duas);
  }
}
