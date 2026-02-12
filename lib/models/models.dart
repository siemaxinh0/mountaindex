/// Model szczytu górskiego
class Peak {
  final String id;
  final String name;
  final int altitude;
  final String range;
  final String region;
  final String summerDifficulty;
  final String winterDifficulty;
  final String? imageUrl;
  final String? description;
  final List<String> crowns;

  Peak({
    required this.id,
    required this.name,
    required this.altitude,
    required this.range,
    this.region = '',
    this.summerDifficulty = 'łatwy',
    this.winterDifficulty = 'umiarkowany',
    this.imageUrl,
    this.description,
    this.crowns = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'altitude': altitude,
    'range': range,
    'region': region,
    'summerDifficulty': summerDifficulty,
    'winterDifficulty': winterDifficulty,
    'imageUrl': imageUrl,
    'description': description,
    'crowns': crowns,
  };

  factory Peak.fromJson(Map<String, dynamic> json) => Peak(
    id: json['id'] as String,
    name: json['name'] as String,
    altitude: json['altitude'] as int,
    range: json['range'] as String,
    region: json['region'] as String? ?? '',
    summerDifficulty: json['summerDifficulty'] as String? ?? 'łatwy',
    winterDifficulty: json['winterDifficulty'] as String? ?? 'umiarkowany',
    imageUrl: json['imageUrl'] as String?,
    description: json['description'] as String?,
    crowns: List<String>.from(json['crowns'] ?? []),
  );
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

  AppUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.stats,
  });
}

/// Model osiągnięcia
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool unlocked;
  final double progress;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    this.icon = '🏔️',
    this.unlocked = false,
    this.progress = 0.0,
  });
}
