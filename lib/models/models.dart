/// Model szczytu górskiego
class Peak {
  final String id;
  final String name;
  final String region;
  final String? country; // Kraj (np. 'Polska', 'Francja')
  final String? range;   // Pasmo górskie (np. 'Tatry', 'Alpy')
  final int height;
  final double difficultySummer;
  final double difficultyWinter;
  final List<String> achievementIds; // Do których osiągnięć należy
  bool isConquered;
  DateTime? conquerDate;

  Peak({
    required this.id,
    required this.name,
    required this.region,
    this.country,
    this.range,
    required this.height,
    this.difficultySummer = 2.0,
    this.difficultyWinter = 3.0,
    this.achievementIds = const [],
    this.isConquered = false,
    this.conquerDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'region': region,
    'country': country,
    'range': range,
    'height': height,
    'difficultySummer': difficultySummer,
    'difficultyWinter': difficultyWinter,
    'achievementIds': achievementIds,
    'isConquered': isConquered,
    'conquerDate': conquerDate?.toIso8601String(),
  };

  factory Peak.fromJson(Map<String, dynamic> json) => Peak(
    id: json['id'] as String,
    name: json['name'] as String,
    region: json['region'] as String? ?? '',
    country: json['country'] as String?,
    range: json['range'] as String?,
    height: json['height'] as int,
    difficultySummer: (json['difficultySummer'] as num?)?.toDouble() ?? 2.0,
    difficultyWinter: (json['difficultyWinter'] as num?)?.toDouble() ?? 3.0,
    achievementIds: List<String>.from(json['achievementIds'] ?? []),
    isConquered: json['isConquered'] as bool? ?? false,
    conquerDate: json['conquerDate'] != null 
        ? DateTime.parse(json['conquerDate'] as String) 
        : null,
  );

  /// Kopiuj Peak z możliwością zmiany pól
  Peak copyWith({
    String? id,
    String? name,
    String? region,
    String? country,
    String? range,
    int? height,
    double? difficultySummer,
    double? difficultyWinter,
    List<String>? achievementIds,
    bool? isConquered,
    DateTime? conquerDate,
  }) {
    return Peak(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      country: country ?? this.country,
      range: range ?? this.range,
      height: height ?? this.height,
      difficultySummer: difficultySummer ?? this.difficultySummer,
      difficultyWinter: difficultyWinter ?? this.difficultyWinter,
      achievementIds: achievementIds ?? this.achievementIds,
      isConquered: isConquered ?? this.isConquered,
      conquerDate: conquerDate ?? this.conquerDate,
    );
  }
}

/// Model wyprawy
class Expedition {
  final String id;
  final String odataUId;
  final String peakId;
  final String peakName;
  final int peakAltitude;
  final DateTime date;
  final String? note;
  final String? photoUrl;
  final List<String> participants;
  final int? rating;

  Expedition({
    required this.id,
    required this.odataUId,
    required this.peakId,
    required this.peakName,
    required this.peakAltitude,
    required this.date,
    this.note,
    this.photoUrl,
    this.participants = const [],
    this.rating,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'odataUId': odataUId,
    'peakId': peakId,
    'peakName': peakName,
    'peakAltitude': peakAltitude,
    'date': date.toIso8601String(),
    'note': note,
    'photoUrl': photoUrl,
    'participants': participants,
    'rating': rating,
  };

  factory Expedition.fromJson(Map<String, dynamic> json) => Expedition(
    id: json['id'] as String,
    odataUId: json['odataUId'] as String,
    peakId: json['peakId'] as String,
    peakName: json['peakName'] as String,
    peakAltitude: json['peakAltitude'] as int,
    date: DateTime.parse(json['date'] as String),
    note: json['note'] as String?,
    photoUrl: json['photoUrl'] as String?,
    participants: List<String>.from(json['participants'] ?? []),
    rating: json['rating'] as int?,
  );
}

/// Statystyki użytkownika
class UserStats {
  final int totalPeaks;
  final int totalElevationGain;
  final int totalExpeditions;
  final int highestPeak;
  final String? highestPeakName;

  UserStats({
    this.totalPeaks = 0,
    this.totalElevationGain = 0,
    this.totalExpeditions = 0,
    this.highestPeak = 0,
    this.highestPeakName,
  });

  Map<String, dynamic> toJson() => {
    'totalPeaks': totalPeaks,
    'totalElevationGain': totalElevationGain,
    'totalExpeditions': totalExpeditions,
    'highestPeak': highestPeak,
    'highestPeakName': highestPeakName,
  };

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
    totalPeaks: json['totalPeaks'] as int? ?? 0,
    totalElevationGain: json['totalElevationGain'] as int? ?? 0,
    totalExpeditions: json['totalExpeditions'] as int? ?? 0,
    highestPeak: json['highestPeak'] as int? ?? 0,
    highestPeakName: json['highestPeakName'] as String?,
  );
}

/// Model użytkownika
class AppUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final UserStats stats;
  final String? highestPeakName;
  final int? highestPeakHeight;
  final String? highestPeakRegion;
  final int conqueredPeaksCount;
  final List<String> friendIds;

  AppUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.stats,
    this.highestPeakName,
    this.highestPeakHeight,
    this.highestPeakRegion,
    this.conqueredPeaksCount = 0,
    this.friendIds = const [],
  });

  /// Oblicz rangę na podstawie liczby zdobytych szczytów
  String get rank {
    final peaks = stats.totalPeaks;
    if (peaks >= 20) return 'Legenda Gór';
    if (peaks >= 15) return 'Mistrz Wypraw';
    if (peaks >= 10) return 'Wytrawny Zdobywca';
    if (peaks >= 5) return 'Poszukiwacz Przygód';
    if (peaks >= 1) return 'Początkujący Turysta';
    return 'Nowicjusz';
  }

  /// Pobierz inicjały z imienia i nazwiska
  String get initials {
    return name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
  }
}

/// Model osiągnięcia
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int requiredPeaks;      // Ile szczytów trzeba zdobyć
  final int conqueredPeaks;     // Ile już zdobyto
  final bool unlocked;
  
  Achievement({
    required this.id,
    required this.name,
    required this.description,
    this.icon = '🏔️',
    this.requiredPeaks = 0,
    this.conqueredPeaks = 0,
    this.unlocked = false,
  });

  double get progress => requiredPeaks > 0 ? conqueredPeaks / requiredPeaks : 0.0;
}
