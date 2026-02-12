import '../models/models.dart';

/// Serwis danych - gotowy na integrację z Firebase/Firestore
/// Obecnie używa danych mockowych
class DataService {
  // Singleton pattern - przygotowanie pod Firebase
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // ============ MOCK DATA - Polskie szczyty ============
  
  final List<Peak> _peaks = [
    Peak(
      id: 'rysy',
      name: 'Rysy',
      altitude: 2499,
      range: 'Tatry',
      region: 'Tatry Wysokie',
      summerDifficulty: 'trudny',
      winterDifficulty: 'bardzo trudny',
      description: 'Najwyższy szczyt Polski. Wejście od Morskiego Oka.',
      crowns: ['Korona Gór Polski', 'Korona Tatr'],
    ),
    Peak(
      id: 'giewont',
      name: 'Giewont',
      altitude: 1894,
      range: 'Tatry',
      region: 'Tatry Zachodnie',
      summerDifficulty: 'umiarkowany',
      winterDifficulty: 'trudny',
      description: 'Charakterystyczny szczyt z krzyżem na szczycie.',
      crowns: [],
    ),
    Peak(
      id: 'swinica',
      name: 'Świnica',
      altitude: 2301,
      range: 'Tatry',
      region: 'Tatry Wysokie',
      summerDifficulty: 'umiarkowany',
      winterDifficulty: 'trudny',
      description: 'Szczyt graniczny z pięknym widokiem na Dolinę Gąsienicową.',
      crowns: ['Korona Tatr'],
    ),
    Peak(
      id: 'kasprowy',
      name: 'Kasprowy Wierch',
      altitude: 1987,
      range: 'Tatry',
      region: 'Tatry Zachodnie',
      summerDifficulty: 'łatwy',
      winterDifficulty: 'umiarkowany',
      description: 'Popularny szczyt z kolejką linową.',
      crowns: [],
    ),
    Peak(
      id: 'babia-gora',
      name: 'Babia Góra',
      altitude: 1725,
      range: 'Beskid Żywiecki',
      region: 'Beskidy',
      summerDifficulty: 'umiarkowany',
      winterDifficulty: 'trudny',
      description: 'Królowa Beskidów - najwyższy szczyt Beskidów.',
      crowns: ['Korona Gór Polski'],
    ),
    Peak(
      id: 'sniezka',
      name: 'Śnieżka',
      altitude: 1603,
      range: 'Karkonosze',
      region: 'Sudety',
      summerDifficulty: 'łatwy',
      winterDifficulty: 'umiarkowany',
      description: 'Najwyższy szczyt Karkonoszy i Sudetów.',
      crowns: ['Korona Gór Polski'],
    ),
    Peak(
      id: 'tarnica',
      name: 'Tarnica',
      altitude: 1346,
      range: 'Bieszczady',
      region: 'Bieszczady',
      summerDifficulty: 'łatwy',
      winterDifficulty: 'umiarkowany',
      description: 'Najwyższy szczyt polskich Bieszczadów.',
      crowns: ['Korona Gór Polski'],
    ),
    Peak(
      id: 'turbacz',
      name: 'Turbacz',
      altitude: 1310,
      range: 'Gorce',
      region: 'Beskidy',
      summerDifficulty: 'łatwy',
      winterDifficulty: 'łatwy',
      description: 'Najwyższy szczyt Gorców ze schroniskiem.',
      crowns: ['Korona Gór Polski'],
    ),
    Peak(
      id: 'pilsko',
      name: 'Pilsko',
      altitude: 1557,
      range: 'Beskid Żywiecki',
      region: 'Beskidy',
      summerDifficulty: 'umiarkowany',
      winterDifficulty: 'umiarkowany',
      description: 'Drugi co do wysokości szczyt Beskidów.',
      crowns: ['Korona Gór Polski'],
    ),
    Peak(
      id: 'snieznik',
      name: 'Śnieżnik',
      altitude: 1425,
      range: 'Masyw Śnieżnika',
      region: 'Sudety',
      summerDifficulty: 'łatwy',
      winterDifficulty: 'umiarkowany',
      description: 'Najwyższy szczyt Masywu Śnieżnika.',
      crowns: ['Korona Gór Polski'],
    ),
  ];

  final List<Expedition> _expeditions = [
    Expedition(
      id: 'exp1',
      odataUId: 'user1',
      peakId: 'rysy',
      peakName: 'Rysy',
      peakAltitude: 2499,
      date: DateTime(2024, 7, 15),
      note: 'Fantastyczna pogoda! Widoki na Słowację niesamowite.',
      rating: 5,
      participants: ['Anna', 'Piotr'],
    ),
    Expedition(
      id: 'exp2',
      odataUId: 'user1',
      peakId: 'giewont',
      peakName: 'Giewont',
      peakAltitude: 1894,
      date: DateTime(2024, 6, 20),
      note: 'Tłoczno na szlaku, ale warto było.',
      rating: 4,
    ),
    Expedition(
      id: 'exp3',
      odataUId: 'user1',
      peakId: 'sniezka',
      peakName: 'Śnieżka',
      peakAltitude: 1603,
      date: DateTime(2024, 5, 10),
      note: 'Mgła na szczycie, ale klimatycznie.',
      rating: 3,
    ),
    Expedition(
      id: 'exp4',
      odataUId: 'user1',
      peakId: 'babia-gora',
      peakName: 'Babia Góra',
      peakAltitude: 1725,
      date: DateTime(2024, 8, 5),
      note: 'Perć Akademików - wymagająca ale spektakularna!',
      rating: 5,
      participants: ['Kasia'],
    ),
    Expedition(
      id: 'exp5',
      odataUId: 'user1',
      peakId: 'tarnica',
      peakName: 'Tarnica',
      peakAltitude: 1346,
      date: DateTime(2024, 9, 1),
      note: 'Bieszczady są magiczne. Połoniny zapierają dech.',
      rating: 5,
    ),
  ];

  final List<AppUser> _friends = [
    AppUser(
      id: 'friend1',
      name: 'Anna Nowak',
      stats: UserStats(totalPeaks: 15, totalElevationGain: 18500, highestPeak: 2499),
    ),
    AppUser(
      id: 'friend2',
      name: 'Piotr Kowalski',
      stats: UserStats(totalPeaks: 8, totalElevationGain: 9200, highestPeak: 1894),
    ),
    AppUser(
      id: 'friend3',
      name: 'Kasia Wiśniewska',
      stats: UserStats(totalPeaks: 22, totalElevationGain: 28000, highestPeak: 2499),
    ),
  ];

  final List<Achievement> _achievements = [
    Achievement(
      id: 'first_peak',
      name: 'Pierwszy Szczyt',
      description: 'Zdobądź swój pierwszy szczyt',
      icon: '⛰️',
      unlocked: true,
      progress: 1.0,
    ),
    Achievement(
      id: 'korona_5',
      name: 'Korona w Drodze',
      description: 'Zdobądź 5 szczytów Korony Gór Polski',
      icon: '👑',
      unlocked: false,
      progress: 0.6,
    ),
    Achievement(
      id: 'tatry_master',
      name: 'Władca Tatr',
      description: 'Zdobądź 10 szczytów w Tatrach',
      icon: '🏔️',
      unlocked: false,
      progress: 0.2,
    ),
    Achievement(
      id: 'elevation_10k',
      name: 'Zdobywca 10km',
      description: 'Zdobądź łącznie 10000m przewyższenia',
      icon: '📈',
      unlocked: false,
      progress: 0.85,
    ),
    Achievement(
      id: 'winter_warrior',
      name: 'Zimowy Wojownik',
      description: 'Zdobądź szczyt zimą',
      icon: '❄️',
      unlocked: false,
      progress: 0.0,
    ),
  ];

  // ============ API Methods ============

  /// Pobierz wszystkie szczyty
  Future<List<Peak>> getAllPeaks() async {
    // Symulacja opóźnienia sieciowego
    await Future.delayed(const Duration(milliseconds: 100));
    return _peaks;
  }

  /// Pobierz szczyty z Korony Gór Polski
  Future<List<Peak>> getKoronaPeaks() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _peaks.where((p) => p.crowns.contains('Korona Gór Polski')).toList();
  }

  /// Pobierz wyprawy użytkownika
  Future<List<Expedition>> getUserExpeditions(String odataUId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _expeditions.where((e) => e.odataUId == odataUId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Pobierz statystyki użytkownika
  Future<UserStats> getUserStats(String odataUId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final userExp = _expeditions.where((e) => e.odataUId == odataUId).toList();
    
    if (userExp.isEmpty) {
      return UserStats();
    }

    final peakIds = userExp.map((e) => e.peakId).toSet();
    final totalElevation = userExp.fold<int>(0, (sum, e) => sum + e.peakAltitude);
    final highest = userExp.reduce((a, b) => a.peakAltitude > b.peakAltitude ? a : b);

    return UserStats(
      totalPeaks: peakIds.length,
      totalElevationGain: totalElevation,
      totalExpeditions: userExp.length,
      highestPeak: highest.peakAltitude,
      highestPeakName: highest.peakName,
    );
  }

  /// Pobierz zdobyte ID szczytów
  Future<Set<String>> getClimbedPeakIds(String odataUId) async {
    final exp = await getUserExpeditions(odataUId);
    return exp.map((e) => e.peakId).toSet();
  }

  /// Pobierz znajomych
  Future<List<AppUser>> getFriends() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _friends;
  }

  /// Pobierz osiągnięcia
  Future<List<Achievement>> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _achievements;
  }

  /// Wyszukaj szczyty
  Future<List<Peak>> searchPeaks(String query) async {
    if (query.isEmpty) return _peaks;
    final q = query.toLowerCase();
    return _peaks.where((p) =>
      p.name.toLowerCase().contains(q) ||
      p.range.toLowerCase().contains(q)
    ).toList();
  }

  // ============ Firebase Integration Points ============
  // Te metody będą zastąpione wywołaniami Firebase w przyszłości:
  //
  // Future<void> signIn(String email, String password) async {
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(...);
  // }
  //
  // Future<void> saveExpedition(Expedition exp) async {
  //   await FirebaseFirestore.instance.collection('expeditions').add(exp.toJson());
  // }
}
