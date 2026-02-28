import 'package:drift/drift.dart' show Value;
import '../database/app_database.dart';

/// Seeds initial data for duas and geofence locations
class DataSeedService {
  final AppDatabase _database;

  DataSeedService(this._database);

  /// Initialize all ritual data (holy sites and duas)
  Future<void> seedInitialData() async {
    final existingLocations = await _database.getAllLocations();
    if (existingLocations.isEmpty) {
      await _seedHolySites();
      await _seedDuas();
    }
  }

  /// Force re-seed data (clears existing and re-seeds)
  /// Use this when GPS coordinates have been updated
  Future<void> reseedData() async {
    // Clear existing data
    await _database.clearAllLocations();
    await _database.clearAllDuas();

    // Re-seed with updated coordinates
    await _seedHolySites();
    await _seedDuas();
  }

  /// Seed holy site locations with GPS coordinates
  Future<void> _seedHolySites() async {
    final locations = [
      // Kaaba - Center point (REAL COORDINATES)
      GeofenceLocationsCompanion.insert(
        locationId: 'kaaba_center',
        nameEn: 'Holy Kaaba',
        nameAr: 'الكعبة المشرفة',
        description: 'The center of the Grand Mosque',
        latitude: 21.4220759,
        longitude: 39.8275312,
        radiusMeters: 30.0,
        ritualName: 'general',
      ),

      // Tawaf Area - All close locations use this central point
      GeofenceLocationsCompanion.insert(
        locationId: 'tawaf_area',
        nameEn: 'Tawaf Area',
        nameAr: 'منطقة الطواف',
        description: 'Circumambulation area around the Kaaba',
        latitude: 21.422523,
        longitude: 39.826368,
        radiusMeters: 100.0,
        ritualName: 'tawaf',
      ),

      // Maqam Ibrahim - Near Tawaf area
      GeofenceLocationsCompanion.insert(
        locationId: 'maqam_ibrahim',
        nameEn: 'Maqam Ibrahim',
        nameAr: 'مقام إبراهيم',
        description: 'Station of Abraham - Prayer location after Tawaf',
        latitude: 21.422523,
        longitude: 39.826368,
        radiusMeters: 20.0,
        ritualName: 'tawaf',
      ),

      // Zamzam Well (REAL COORDINATES)
      GeofenceLocationsCompanion.insert(
        locationId: 'zamzam',
        nameEn: 'Zamzam Well',
        nameAr: 'بئر زمزم',
        description: 'The blessed well of Zamzam water',
        latitude: 21.4225737,
        longitude: 39.8239522,
        radiusMeters: 30.0,
        ritualName: 'general',
      ),

      // Safa - Start of Sa'i (REAL COORDINATES)
      GeofenceLocationsCompanion.insert(
        locationId: 'safa',
        nameEn: 'Mount Safa',
        nameAr: 'الصفا',
        description: 'Starting point of Sa\'i between Safa and Marwah',
        latitude: 21.4219111,
        longitude: 39.8274322,
        radiusMeters: 25.0,
        ritualName: 'sai',
      ),

      // Marwah - End of Sa'i (REAL COORDINATES)
      GeofenceLocationsCompanion.insert(
        locationId: 'marwah',
        nameEn: 'Mount Marwah',
        nameAr: 'المروة',
        description: 'Ending point of Sa\'i between Safa and Marwah',
        latitude: 21.4252671,
        longitude: 39.8271871,
        radiusMeters: 25.0,
        ritualName: 'sai',
      ),

      // Green Pillars (Calculated midpoint between Safa and Marwah)
      GeofenceLocationsCompanion.insert(
        locationId: 'green_pillars',
        nameEn: 'Green Pillars',
        nameAr: 'الميلين الأخضرين',
        description: 'Section where men should run during Sa\'i',
        latitude: 21.4235891,
        longitude: 39.8273096,
        radiusMeters: 15.0,
        ritualName: 'sai',
      ),

      // Multazam - Near Tawaf area
      GeofenceLocationsCompanion.insert(
        locationId: 'multazam',
        nameEn: 'Al-Multazam',
        nameAr: 'الملتزم',
        description: 'The area between the door of Kaaba and Black Stone',
        latitude: 21.422523,
        longitude: 39.826368,
        radiusMeters: 15.0,
        ritualName: 'tawaf',
      ),

      // Black Stone - Near Tawaf area
      GeofenceLocationsCompanion.insert(
        locationId: 'black_stone',
        nameEn: 'The Black Stone',
        nameAr: 'الحجر الأسود',
        description: 'Sacred stone where Tawaf begins',
        latitude: 21.422523,
        longitude: 39.826368,
        radiusMeters: 10.0,
        ritualName: 'tawaf',
      ),

      // Hijr Ismail - Near Tawaf area
      GeofenceLocationsCompanion.insert(
        locationId: 'hijr_ismail',
        nameEn: 'Hijr Ismail',
        nameAr: 'حجر إسماعيل',
        description: 'The semi-circular wall adjacent to the Kaaba',
        latitude: 21.422523,
        longitude: 39.826368,
        radiusMeters: 20.0,
        ritualName: 'tawaf',
      ),

      // ===== HAJJ-SPECIFIC LOCATIONS =====

      // Mount Arafat - Most important day of Hajj
      GeofenceLocationsCompanion.insert(
        locationId: 'arafat',
        nameEn: 'Mount Arafat',
        nameAr: 'جبل عرفات',
        description: 'Plain of Arafat - Standing on the 9th of Dhul Hijjah',
        latitude: 21.3548849,
        longitude: 39.984116,
        radiusMeters: 156.40,
        ritualName: 'hajj',
      ),

      // Muzdalifah - Night stay and pebble collection
      GeofenceLocationsCompanion.insert(
        locationId: 'muzdalifah',
        nameEn: 'Muzdalifah',
        nameAr: 'مزدلفة',
        description:
            'Area between Arafat and Mina - Collect pebbles and spend the night',
        latitude: 21.411029,
        longitude: 39.909017,
        radiusMeters: 2000.0, // ~12.25 km² area
        ritualName: 'hajj',
      ),

      // Mina - Tent city during Hajj
      GeofenceLocationsCompanion.insert(
        locationId: 'mina',
        nameEn: 'Mina',
        nameAr: 'منى',
        description: 'Valley of tents - Stay during days of Hajj',
        latitude: 21.407998368,
        longitude: 39.889329776,
        radiusMeters: 2500.0, // ~20 km² area
        ritualName: 'hajj',
      ),

      // Jamarat Bridge - Stone throwing area
      GeofenceLocationsCompanion.insert(
        locationId: 'jamarat_bridge',
        nameEn: 'Jamarat Bridge',
        nameAr: 'جسر الجمرات',
        description: 'Multi-level bridge for Rami al-Jamarat ritual',
        latitude: 21.4215891,
        longitude: 39.8696411,
        radiusMeters: 293.88,
        ritualName: 'hajj',
      ),

      // Small Jamarat (Jamrat al-Ula)
      GeofenceLocationsCompanion.insert(
        locationId: 'jamarat_ula',
        nameEn: 'Small Jamarat',
        nameAr: 'الجمرة الصغرى',
        description: 'First pillar - Jamrat al-Ula',
        latitude: 21.4202789,
        longitude: 39.8726206,
        radiusMeters: 81.91,
        ritualName: 'hajj',
      ),

      // Large Jamarat (Jamrat al-Aqaba)
      GeofenceLocationsCompanion.insert(
        locationId: 'jamarat_aqaba',
        nameEn: 'Large Jamarat',
        nameAr: 'جمرة العقبة',
        description: 'Third pillar - Jamrat al-Aqaba',
        latitude: 21.4223547,
        longitude: 39.8676574,
        radiusMeters: 62.06,
        ritualName: 'hajj',
      ),

      // Cave of Hira
      GeofenceLocationsCompanion.insert(
        locationId: 'cave_hira',
        nameEn: 'Cave of Hira',
        nameAr: 'غار حراء',
        description: 'Cave where Prophet Muhammad received first revelation',
        latitude: 21.4577043,
        longitude: 39.8584322,
        radiusMeters: 30.14,
        ritualName: 'general',
      ),

      // Jabal al-Nour (Mountain of Light)
      GeofenceLocationsCompanion.insert(
        locationId: 'jabal_nour',
        nameEn: 'Jabal al-Nour',
        nameAr: 'جبل النور',
        description: 'Mountain of Light - Contains Cave of Hira',
        latitude: 21.4577043,
        longitude: 39.8584322,
        radiusMeters: 150.56,
        ritualName: 'general',
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

      // ===== HAJJ-SPECIFIC DUAS =====

      // Mount Arafat - Day of Arafat
      DuasCompanion.insert(
        locationId: 'arafat',
        ritualType: 'self',
        arabicText:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        englishTranslation:
            'There is no deity except Allah, alone without partner. To Him belongs dominion and praise, and He is over all things competent',
        transliteration: const Value(
          'La Ilaha Illallahu Wahdahu La Sharika Lah, Lahul-Mulku Wa Lahul-Hamd Wa Huwa Ala Kulli Shay\'in Qadir',
        ),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'arafat',
        ritualType: 'self',
        arabicText:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنَ الْخَيْرِ كُلِّهِ عَاجِلِهِ وَآجِلِهِ',
        englishTranslation:
            'O Allah, I ask You for all good, immediate and distant',
        transliteration: const Value(
          'Allahumma Inni As\'aluka Minal-Khairi Kullihi Ajilihi Wa Ajilihi',
        ),
        displayOrder: const Value(2),
      ),
      DuasCompanion.insert(
        locationId: 'arafat',
        ritualType: 'proxy',
        arabicText:
            'اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ',
        englishTranslation:
            'O Allah, forgive them, have mercy on them, grant them wellbeing, and pardon them',
        transliteration: const Value(
          'Allahumma Ighfir Lahu Warhamhu Wa Aafihi Wa\'fu Anhu',
        ),
        displayOrder: const Value(1),
      ),

      // Muzdalifah - Night prayers
      DuasCompanion.insert(
        locationId: 'muzdalifah',
        ritualType: 'self',
        arabicText:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى',
        englishTranslation:
            'O Allah, I ask You for guidance, piety, chastity, and contentment',
        transliteration: const Value(
          'Allahumma Inni As\'alukal-Huda Wat-Tuqa Wal-Afafa Wal-Ghina',
        ),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'muzdalifah',
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

      // Mina - Days of Tashreeq
      DuasCompanion.insert(
        locationId: 'mina',
        ritualType: 'self',
        arabicText:
            'اللَّهُمَّ اجْعَلْهُ حَجًّا مَبْرُورًا وَذَنْبًا مَغْفُورًا وَسَعْيًا مَشْكُورًا',
        englishTranslation:
            'O Allah, make this an accepted Hajj, a forgiven sin, and an appreciated effort',
        transliteration: const Value(
          'Allahumma Ij\'alhu Hajjan Mabruran Wa Dhanban Maghfuran Wa Sa\'yan Mashkuran',
        ),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'mina',
        ritualType: 'proxy',
        arabicText: 'اللَّهُمَّ تَقَبَّلْ مِنْهُ وَاجْعَلْهُ حَجًّا مَبْرُورًا',
        englishTranslation:
            'O Allah, accept from them and make it an accepted Hajj',
        transliteration: const Value(
          'Allahumma Taqabbal Minhu Waj\'alhu Hajjan Mabruran',
        ),
        displayOrder: const Value(1),
      ),

      // Jamarat - Stone throwing
      DuasCompanion.insert(
        locationId: 'jamarat_ula',
        ritualType: 'self',
        arabicText: 'اللَّهُ أَكْبَرُ',
        englishTranslation: 'Allah is the Greatest',
        transliteration: const Value('Allahu Akbar'),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'jamarat_ula',
        ritualType: 'self',
        arabicText:
            'اللَّهُمَّ اجْعَلْهُ حَجًّا مَبْرُورًا وَذَنْبًا مَغْفُورًا',
        englishTranslation:
            'O Allah, make this an accepted Hajj and a forgiven sin',
        transliteration: const Value(
          'Allahumma Ij\'alhu Hajjan Mabruran Wa Dhanban Maghfuran',
        ),
        displayOrder: const Value(2),
      ),

      // Large Jamarat
      DuasCompanion.insert(
        locationId: 'jamarat_aqaba',
        ritualType: 'self',
        arabicText: 'بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ رَغْمًا لِلشَّيْطَانِ',
        englishTranslation:
            'In the name of Allah, Allah is Greatest, in defiance of Satan',
        transliteration: const Value(
          'Bismillahi Wallahu Akbar Raghman Lish-Shaytan',
        ),
        displayOrder: const Value(1),
      ),

      // Cave of Hira
      DuasCompanion.insert(
        locationId: 'cave_hira',
        ritualType: 'self',
        arabicText: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
        englishTranslation:
            'O Allah, send blessings upon Muhammad and the family of Muhammad',
        transliteration: const Value(
          'Allahumma Salli Ala Muhammadin Wa Ala Ali Muhammad',
        ),
        displayOrder: const Value(1),
      ),
      DuasCompanion.insert(
        locationId: 'cave_hira',
        ritualType: 'self',
        arabicText: 'اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
        englishTranslation:
            'Read in the name of your Lord who created (First revelation)',
        transliteration: const Value('Iqra Bismi Rabbikal-Ladhi Khalaq'),
        displayOrder: const Value(2),
      ),

      // Jabal al-Nour
      DuasCompanion.insert(
        locationId: 'jabal_nour',
        ritualType: 'self',
        arabicText: 'سُبْحَانَ الَّذِي أَسْرَى بِعَبْدِهِ لَيْلًا',
        englishTranslation: 'Glory be to He who took His servant by night',
        transliteration: const Value('Subhanal-Ladhi Asra Bi\'abdihi Layla'),
        displayOrder: const Value(1),
      ),
    ];

    await _database.insertMultipleDuas(duas);
  }
}
