import '../models/models.dart';

/// Serwis danych - gotowy na integrację z Firebase/Firestore
/// Obecnie używa danych mockowych
class DataService {
  // Singleton pattern - przygotowanie pod Firebase
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // ============ MOCK DATA - Korona Gór Polski (28 szczytów) ============
  
  final List<Peak> _peaks = [
    // Tatry
    Peak(id: 'rysy', name: 'Rysy', region: 'Tatry', height: 2499, difficultySummer: 3.5, difficultyWinter: 5.0, isConquered: true, conquerDate: DateTime(2024, 7, 15)),
    // Beskid Żywiecki
    Peak(id: 'babia-gora', name: 'Babia Góra', region: 'Beskid Żywiecki', height: 1725, difficultySummer: 3.0, difficultyWinter: 4.0, isConquered: true, conquerDate: DateTime(2024, 8, 5)),
    Peak(id: 'pilsko', name: 'Pilsko', region: 'Beskid Żywiecki', height: 1557, difficultySummer: 2.5, difficultyWinter: 3.0),
    // Karkonosze
    Peak(id: 'sniezka', name: 'Śnieżka', region: 'Karkonosze', height: 1603, difficultySummer: 2.0, difficultyWinter: 3.0, isConquered: true, conquerDate: DateTime(2024, 5, 10)),
    // Bieszczady
    Peak(id: 'tarnica', name: 'Tarnica', region: 'Bieszczady', height: 1346, difficultySummer: 2.0, difficultyWinter: 2.5, isConquered: true, conquerDate: DateTime(2024, 9, 1)),
    // Gorce
    Peak(id: 'turbacz', name: 'Turbacz', region: 'Gorce', height: 1310, difficultySummer: 2.0, difficultyWinter: 2.5),
    // Masyw Śnieżnika
    Peak(id: 'snieznik', name: 'Śnieżnik', region: 'Masyw Śnieżnika', height: 1425, difficultySummer: 2.0, difficultyWinter: 3.0),
    // Góry Stołowe
    Peak(id: 'szczeliniec', name: 'Szczeliniec Wielki', region: 'Góry Stołowe', height: 919, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Góry Sowie
    Peak(id: 'wielka-sowa', name: 'Wielka Sowa', region: 'Góry Sowie', height: 1015, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Beskid Śląski
    Peak(id: 'skrzyczne', name: 'Skrzyczne', region: 'Beskid Śląski', height: 1257, difficultySummer: 2.0, difficultyWinter: 2.5),
    // Beskid Mały
    Peak(id: 'czupel', name: 'Czupel', region: 'Beskid Mały', height: 933, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Beskid Makowski
    Peak(id: 'lubon-wielki', name: 'Luboń Wielki', region: 'Beskid Makowski', height: 1022, difficultySummer: 2.0, difficultyWinter: 2.5),
    // Beskid Wyspowy
    Peak(id: 'mogielica', name: 'Mogielica', region: 'Beskid Wyspowy', height: 1170, difficultySummer: 2.0, difficultyWinter: 2.5),
    // Beskid Sądecki
    Peak(id: 'radziejowa', name: 'Radziejowa', region: 'Beskid Sądecki', height: 1262, difficultySummer: 2.5, difficultyWinter: 3.0),
    // Beskid Niski
    Peak(id: 'lackowa', name: 'Lackowa', region: 'Beskid Niski', height: 997, difficultySummer: 2.0, difficultyWinter: 2.5),
    // Pieniny
    Peak(id: 'wysoka', name: 'Wysoka (Pieniny)', region: 'Pieniny', height: 1050, difficultySummer: 2.5, difficultyWinter: 3.5),
    // Góry Bystrzyckie
    Peak(id: 'jagodna', name: 'Jagodna', region: 'Góry Bystrzyckie', height: 977, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Góry Orlickie
    Peak(id: 'orlica', name: 'Orlica', region: 'Góry Orlickie', height: 1084, difficultySummer: 2.0, difficultyWinter: 2.5),
    // Rudawy Janowickie
    Peak(id: 'skalnik', name: 'Skalnik', region: 'Rudawy Janowickie', height: 945, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Góry Kamienne
    Peak(id: 'waligora', name: 'Waligóra', region: 'Góry Kamienne', height: 936, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Góry Wałbrzyskie
    Peak(id: 'chelmiec', name: 'Chełmiec', region: 'Góry Wałbrzyskie', height: 851, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Góry Bardzkie
    Peak(id: 'klodzieka-gora', name: 'Kłodzka Góra', region: 'Góry Bardzkie', height: 765, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Góry Złote
    Peak(id: 'borowa', name: 'Borówkowa (Kowadło)', region: 'Góry Złote', height: 989, difficultySummer: 2.0, difficultyWinter: 2.5),
    // Góry Opawskie
    Peak(id: 'biskupia-kopa', name: 'Biskupia Kopa', region: 'Góry Opawskie', height: 890, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Góry Izerskie
    Peak(id: 'wysoka-kopa', name: 'Wysoka Kopa', region: 'Góry Izerskie', height: 1126, difficultySummer: 2.0, difficultyWinter: 3.0),
    // Góry Kaczawskie
    Peak(id: 'skopiec', name: 'Skopiec', region: 'Góry Kaczawskie', height: 724, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Pogórze Przemyskie
    Peak(id: 'kamien', name: 'Kamień (Pogórze Przemyskie)', region: 'Pogórze Przemyskie', height: 671, difficultySummer: 1.5, difficultyWinter: 2.0),
    // Góry Świętokrzyskie
    Peak(id: 'lysica', name: 'Łysica', region: 'Góry Świętokrzyskie', height: 612, difficultySummer: 1.5, difficultyWinter: 2.0),
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

  /// Pobierz szczyty z Korony Gór Polski (wszystkie 28 w liście)
  Future<List<Peak>> getKoronaPeaks() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_peaks);
  }

  /// Przełącz status zdobycia szczytu
  Future<void> togglePeakConquered(String peakId) async {
    final index = _peaks.indexWhere((p) => p.id == peakId);
    if (index != -1) {
      final peak = _peaks[index];
      _peaks[index] = peak.copyWith(
        isConquered: !peak.isConquered,
        conquerDate: !peak.isConquered ? DateTime.now() : null,
      );
    }
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
      p.region.toLowerCase().contains(q)
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
