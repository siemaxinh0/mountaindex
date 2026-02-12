import '../models/models.dart';

/// Serwis danych - gotowy na integrację z Firebase/Firestore
/// Obecnie używa danych mockowych
class DataService {
  // Singleton pattern - przygotowanie pod Firebase
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // ============ MOCK DATA - Wszystkie szczyty ============
  
  final List<Peak> _peaks = [
    // ==================== KORONA GÓR POLSKI (28 szczytów) ====================
    // Tatry
    Peak(id: 'rysy', name: 'Rysy', region: 'Tatry Wysokie', countries: ['Polska', 'Słowacja'], range: 'Tatry', height: 2499, difficultySummer: 3.5, difficultyWinter: 5.0, achievementIds: ['korona_polski', 'korona_tatr'], isConquered: true, conquerDate: DateTime(2024, 7, 15)),
    // Beskid Żywiecki
    Peak(id: 'babia-gora', name: 'Babia Góra', region: 'Beskid Żywiecki', countries: ['Polska'], range: 'Beskidy', height: 1725, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_polski'], isConquered: true, conquerDate: DateTime(2024, 8, 5)),
    Peak(id: 'pilsko', name: 'Pilsko', region: 'Beskid Żywiecki', countries: ['Polska', 'Słowacja'], range: 'Beskidy', height: 1557, difficultySummer: 2.5, difficultyWinter: 3.0, achievementIds: ['korona_polski']),
    // Karkonosze
    Peak(id: 'sniezka', name: 'Śnieżka', region: 'Karkonosze', countries: ['Polska', 'Czechy'], range: 'Sudety', height: 1603, difficultySummer: 2.0, difficultyWinter: 3.0, achievementIds: ['korona_polski', 'korona_europy'], isConquered: true, conquerDate: DateTime(2024, 5, 10)),
    // Bieszczady
    Peak(id: 'tarnica', name: 'Tarnica', region: 'Bieszczady', countries: ['Polska'], range: 'Bieszczady', height: 1346, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_polski'], isConquered: true, conquerDate: DateTime(2024, 9, 1)),
    // Gorce
    Peak(id: 'turbacz', name: 'Turbacz', region: 'Gorce', countries: ['Polska'], range: 'Gorce', height: 1310, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_polski']),
    // Masyw Śnieżnika
    Peak(id: 'snieznik', name: 'Śnieżnik', region: 'Masyw Śnieżnika', countries: ['Polska', 'Czechy'], range: 'Sudety', height: 1425, difficultySummer: 2.0, difficultyWinter: 3.0, achievementIds: ['korona_polski']),
    // Góry Stołowe
    Peak(id: 'szczeliniec', name: 'Szczeliniec Wielki', region: 'Góry Stołowe', countries: ['Polska'], range: 'Sudety', height: 919, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Góry Sowie
    Peak(id: 'wielka-sowa', name: 'Wielka Sowa', region: 'Góry Sowie', countries: ['Polska'], range: 'Sudety', height: 1015, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Beskid Śląski
    Peak(id: 'skrzyczne', name: 'Skrzyczne', region: 'Beskid Śląski', countries: ['Polska'], range: 'Beskidy', height: 1257, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_polski']),
    // Beskid Mały
    Peak(id: 'czupel', name: 'Czupel', region: 'Beskid Mały', countries: ['Polska'], range: 'Beskidy', height: 933, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Beskid Makowski
    Peak(id: 'lubon-wielki', name: 'Luboń Wielki', region: 'Beskid Makowski', countries: ['Polska'], range: 'Beskidy', height: 1022, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_polski']),
    // Beskid Wyspowy
    Peak(id: 'mogielica', name: 'Mogielica', region: 'Beskid Wyspowy', countries: ['Polska'], range: 'Beskidy', height: 1170, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_polski']),
    // Beskid Sądecki
    Peak(id: 'radziejowa', name: 'Radziejowa', region: 'Beskid Sądecki', countries: ['Polska'], range: 'Beskidy', height: 1262, difficultySummer: 2.5, difficultyWinter: 3.0, achievementIds: ['korona_polski']),
    // Beskid Niski
    Peak(id: 'lackowa', name: 'Lackowa', region: 'Beskid Niski', countries: ['Polska'], range: 'Beskidy', height: 997, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_polski']),
    // Pieniny
    Peak(id: 'wysoka', name: 'Wysoka (Pieniny)', region: 'Pieniny', countries: ['Polska', 'Słowacja'], range: 'Pieniny', height: 1050, difficultySummer: 2.5, difficultyWinter: 3.5, achievementIds: ['korona_polski']),
    // Góry Bystrzyckie
    Peak(id: 'jagodna', name: 'Jagodna', region: 'Góry Bystrzyckie', countries: ['Polska'], range: 'Sudety', height: 977, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Góry Orlickie
    Peak(id: 'orlica', name: 'Orlica', region: 'Góry Orlickie', countries: ['Polska', 'Czechy'], range: 'Sudety', height: 1084, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_polski']),
    // Rudawy Janowickie
    Peak(id: 'skalnik', name: 'Skalnik', region: 'Rudawy Janowickie', countries: ['Polska'], range: 'Sudety', height: 945, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Góry Kamienne
    Peak(id: 'waligora', name: 'Waligóra', region: 'Góry Kamienne', countries: ['Polska'], range: 'Sudety', height: 936, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Góry Wałbrzyskie
    Peak(id: 'chelmiec', name: 'Chełmiec', region: 'Góry Wałbrzyskie', countries: ['Polska'], range: 'Sudety', height: 851, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Góry Bardzkie
    Peak(id: 'klodzieka-gora', name: 'Kłodzka Góra', region: 'Góry Bardzkie', countries: ['Polska'], range: 'Sudety', height: 765, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Góry Złote
    Peak(id: 'borowa', name: 'Borówkowa (Kowadło)', region: 'Góry Złote', countries: ['Polska'], range: 'Sudety', height: 989, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_polski']),
    // Góry Opawskie
    Peak(id: 'biskupia-kopa', name: 'Biskupia Kopa', region: 'Góry Opawskie', countries: ['Polska', 'Czechy'], range: 'Sudety', height: 890, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Góry Izerskie
    Peak(id: 'wysoka-kopa', name: 'Wysoka Kopa', region: 'Góry Izerskie', countries: ['Polska'], range: 'Sudety', height: 1126, difficultySummer: 2.0, difficultyWinter: 3.0, achievementIds: ['korona_polski']),
    // Góry Kaczawskie
    Peak(id: 'skopiec', name: 'Skopiec', region: 'Góry Kaczawskie', countries: ['Polska'], range: 'Sudety', height: 724, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Pogórze Przemyskie
    Peak(id: 'kamien', name: 'Kamień (Pogórze Przemyskie)', region: 'Pogórze Przemyskie', countries: ['Polska'], range: 'Pogórze', height: 671, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),
    // Góry Świętokrzyskie
    Peak(id: 'lysica', name: 'Łysica', region: 'Góry Świętokrzyskie', countries: ['Polska'], range: 'Góry Świętokrzyskie', height: 612, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_polski']),

    // ==================== KORONA TATR (główne szczyty Tatr) ====================
    Peak(id: 'gerlach', name: 'Gerlach', region: 'Tatry Wysokie', countries: ['Słowacja'], range: 'Tatry', height: 2655, difficultySummer: 4.5, difficultyWinter: 5.0, achievementIds: ['korona_tatr', 'korona_europy']),
    Peak(id: 'lomnica', name: 'Łomnica', region: 'Tatry Wysokie', countries: ['Słowacja'], range: 'Tatry', height: 2634, difficultySummer: 4.0, difficultyWinter: 5.0, achievementIds: ['korona_tatr']),
    Peak(id: 'lodowy', name: 'Lodowy Szczyt', region: 'Tatry Wysokie', countries: ['Słowacja'], range: 'Tatry', height: 2627, difficultySummer: 4.5, difficultyWinter: 5.0, achievementIds: ['korona_tatr']),
    Peak(id: 'durny', name: 'Durny Szczyt', region: 'Tatry Wysokie', countries: ['Słowacja'], range: 'Tatry', height: 2621, difficultySummer: 4.0, difficultyWinter: 5.0, achievementIds: ['korona_tatr']),
    Peak(id: 'swinica', name: 'Świnica', region: 'Tatry Wysokie', countries: ['Polska', 'Słowacja'], range: 'Tatry', height: 2301, difficultySummer: 3.5, difficultyWinter: 4.5, achievementIds: ['korona_tatr']),
    Peak(id: 'koscielec', name: 'Kościelec', region: 'Tatry Wysokie', countries: ['Polska'], range: 'Tatry', height: 2155, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_tatr']),
    Peak(id: 'giewont', name: 'Giewont', region: 'Tatry Zachodnie', countries: ['Polska'], range: 'Tatry', height: 1894, difficultySummer: 2.5, difficultyWinter: 4.0, achievementIds: ['korona_tatr']),
    Peak(id: 'kasprowy', name: 'Kasprowy Wierch', region: 'Tatry Zachodnie', countries: ['Polska', 'Słowacja'], range: 'Tatry', height: 1987, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_tatr']),
    Peak(id: 'krivan', name: 'Kriváň', region: 'Tatry Wysokie', countries: ['Słowacja'], range: 'Tatry', height: 2494, difficultySummer: 3.5, difficultyWinter: 4.5, achievementIds: ['korona_tatr']),
    Peak(id: 'slawkowski', name: 'Sławkowski Szczyt', region: 'Tatry Wysokie', countries: ['Słowacja'], range: 'Tatry', height: 2452, difficultySummer: 4.0, difficultyWinter: 5.0, achievementIds: ['korona_tatr']),
    Peak(id: 'czerwone-wierchy', name: 'Czerwone Wierchy', region: 'Tatry Zachodnie', countries: ['Polska'], range: 'Tatry', height: 2122, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_tatr']),
    Peak(id: 'orla-perc', name: 'Granaty', region: 'Tatry Wysokie', countries: ['Polska'], range: 'Tatry', height: 2239, difficultySummer: 4.5, difficultyWinter: 5.0, achievementIds: ['korona_tatr']),

    // ==================== KORONA EUROPY (najwyższe szczyty państw) ====================
    // Francja - Mont Blanc
    Peak(id: 'mont-blanc', name: 'Mont Blanc', region: 'Alpy', countries: ['Francja', 'Włochy'], range: 'Alpy', height: 4808, difficultySummer: 4.5, difficultyWinter: 5.0, achievementIds: ['korona_europy']),
    // Szwajcaria - Dufourspitze
    Peak(id: 'dufourspitze', name: 'Dufourspitze', region: 'Alpy Pennińskie', countries: ['Szwajcaria'], range: 'Alpy', height: 4634, difficultySummer: 4.5, difficultyWinter: 5.0, achievementIds: ['korona_europy']),
    // Włochy - Gran Paradiso
    Peak(id: 'gran-paradiso', name: 'Gran Paradiso', region: 'Alpy Graickie', countries: ['Włochy'], range: 'Alpy', height: 4061, difficultySummer: 4.0, difficultyWinter: 5.0, achievementIds: ['korona_europy']),
    // Austria - Grossglockner
    Peak(id: 'grossglockner', name: 'Grossglockner', region: 'Alpy Wschodnie', countries: ['Austria'], range: 'Alpy', height: 3798, difficultySummer: 4.0, difficultyWinter: 5.0, achievementIds: ['korona_europy']),
    // Hiszpania - Mulhacén
    Peak(id: 'mulhacen', name: 'Mulhacén', region: 'Sierra Nevada', countries: ['Hiszpania'], range: 'Sierra Nevada', height: 3479, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_europy']),
    // Niemcy - Zugspitze
    Peak(id: 'zugspitze', name: 'Zugspitze', region: 'Alpy Bawarskie', countries: ['Niemcy', 'Austria'], range: 'Alpy', height: 2962, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_europy']),
    // Grecja - Olimp (Mytikas)
    Peak(id: 'olimp', name: 'Olimp (Mytikas)', region: 'Góry Salonickie', countries: ['Grecja'], range: 'Olimp', height: 2917, difficultySummer: 3.5, difficultyWinter: 4.5, achievementIds: ['korona_europy']),
    // Bułgaria - Musała
    Peak(id: 'musala', name: 'Musała', region: 'Riła', countries: ['Bułgaria'], range: 'Riła', height: 2925, difficultySummer: 2.5, difficultyWinter: 3.5, achievementIds: ['korona_europy']),
    // Słowenia - Triglav
    Peak(id: 'triglav', name: 'Triglav', region: 'Alpy Julijskie', countries: ['Słowenia'], range: 'Alpy', height: 2864, difficultySummer: 4.0, difficultyWinter: 5.0, achievementIds: ['korona_europy']),
    // Rumunia - Moldoveanu
    Peak(id: 'moldoveanu', name: 'Moldoveanu', region: 'Karpaty Południowe', countries: ['Rumunia'], range: 'Karpaty', height: 2544, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_europy']),
    // Norwegia - Galdhøpiggen
    Peak(id: 'galdhopiggen', name: 'Galdhøpiggen', region: 'Jotunheimen', countries: ['Norwegia'], range: 'Góry Skandynawskie', height: 2469, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_europy']),
    // Szwecja - Kebnekaise
    Peak(id: 'kebnekaise', name: 'Kebnekaise', region: 'Laponia', countries: ['Szwecja'], range: 'Góry Skandynawskie', height: 2097, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_europy']),
    // Finlandia - Halti
    Peak(id: 'halti', name: 'Halti', region: 'Laponia', countries: ['Finlandia', 'Norwegia'], range: 'Góry Skandynawskie', height: 1324, difficultySummer: 2.0, difficultyWinter: 3.0, achievementIds: ['korona_europy']),
    // Islandia - Hvannadalshnjúkur
    Peak(id: 'hvannadalshnjukur', name: 'Hvannadalshnjúkur', region: 'Vatnajökull', countries: ['Islandia'], range: 'Lodowce Islandii', height: 2110, difficultySummer: 4.0, difficultyWinter: 5.0, achievementIds: ['korona_europy']),
    // Wielka Brytania - Ben Nevis
    Peak(id: 'ben-nevis', name: 'Ben Nevis', region: 'Szkocja', countries: ['Wielka Brytania'], range: 'Highlands', height: 1345, difficultySummer: 2.5, difficultyWinter: 3.5, achievementIds: ['korona_europy']),
    // Irlandia - Carrauntoohil
    Peak(id: 'carrauntoohil', name: 'Carrauntoohil', region: 'Kerry', countries: ['Irlandia'], range: 'MacGillycuddy Reeks', height: 1038, difficultySummer: 2.5, difficultyWinter: 3.0, achievementIds: ['korona_europy']),
    // Węgry - Kékes
    Peak(id: 'kekes', name: 'Kékes', region: 'Mátra', countries: ['Węgry'], range: 'Mátra', height: 1014, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_europy']),
    // Ukraina - Hoverla
    Peak(id: 'hoverla', name: 'Howerla', region: 'Czarnohora', countries: ['Ukraina'], range: 'Karpaty', height: 2061, difficultySummer: 2.5, difficultyWinter: 3.5, achievementIds: ['korona_europy']),
    // Portugalia - Torre
    Peak(id: 'torre', name: 'Torre', region: 'Serra da Estrela', countries: ['Portugalia'], range: 'Serra da Estrela', height: 1993, difficultySummer: 1.5, difficultyWinter: 2.5, achievementIds: ['korona_europy']),
    // Belgia - Signal de Botrange
    Peak(id: 'botrange', name: 'Signal de Botrange', region: 'Ardeny', countries: ['Belgia'], range: 'Ardeny', height: 694, difficultySummer: 1.0, difficultyWinter: 1.5, achievementIds: ['korona_europy']),
    // Holandia - Vaalserberg
    Peak(id: 'vaalserberg', name: 'Vaalserberg', region: 'Limburgia', countries: ['Holandia', 'Belgia', 'Niemcy'], range: 'Ardeny', height: 322, difficultySummer: 1.0, difficultyWinter: 1.0, achievementIds: ['korona_europy']),
    // Luksemburg - Buurgplaatz
    Peak(id: 'buurgplaatz', name: 'Buurgplaatz', region: 'Oesling', countries: ['Luksemburg'], range: 'Ardeny', height: 559, difficultySummer: 1.0, difficultyWinter: 1.5, achievementIds: ['korona_europy']),
    // Andora - Coma Pedrosa
    Peak(id: 'coma-pedrosa', name: 'Coma Pedrosa', region: 'Pireneje', countries: ['Andora'], range: 'Pireneje', height: 2943, difficultySummer: 3.5, difficultyWinter: 4.5, achievementIds: ['korona_europy']),
    // Czarnogóra - Zla Kolata
    Peak(id: 'zla-kolata', name: 'Zla Kolata', region: 'Prokletije', countries: ['Czarnogóra', 'Albania'], range: 'Prokletije', height: 2534, difficultySummer: 4.0, difficultyWinter: 5.0, achievementIds: ['korona_europy']),
    // Albania/Macedonia - Korab (szczyt graniczny)
    Peak(id: 'korab', name: 'Korab', region: 'Korab', countries: ['Albania', 'Macedonia Północna'], range: 'Korab', height: 2764, difficultySummer: 3.5, difficultyWinter: 4.5, achievementIds: ['korona_europy']),
    // Serbia/Kosowo - Đeravica (szczyt graniczny)
    Peak(id: 'deravica', name: 'Đeravica', region: 'Prokletije', countries: ['Serbia', 'Kosowo'], range: 'Prokletije', height: 2656, difficultySummer: 3.5, difficultyWinter: 4.5, achievementIds: ['korona_europy']),
    // Bośnia - Maglić
    Peak(id: 'maglic', name: 'Maglić', region: 'Góry Dynarskie', countries: ['Bośnia i Hercegowina', 'Czarnogóra'], range: 'Góry Dynarskie', height: 2386, difficultySummer: 3.5, difficultyWinter: 4.5, achievementIds: ['korona_europy']),
    // Chorwacja - Dinara
    Peak(id: 'dinara', name: 'Dinara', region: 'Góry Dynarskie', countries: ['Chorwacja', 'Bośnia i Hercegowina'], range: 'Góry Dynarskie', height: 1831, difficultySummer: 3.0, difficultyWinter: 4.0, achievementIds: ['korona_europy']),
    // Liechtenstein - Grauspitz
    Peak(id: 'grauspitz', name: 'Grauspitz', region: 'Alpy', countries: ['Liechtenstein'], range: 'Alpy', height: 2599, difficultySummer: 3.5, difficultyWinter: 4.5, achievementIds: ['korona_europy']),
    // Monako - Mont Agel
    Peak(id: 'mont-agel', name: 'Mont Agel', region: 'Riwiera', countries: ['Monako', 'Francja'], range: 'Alpy Nadmorskie', height: 1148, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_europy']),
    // San Marino - Monte Titano
    Peak(id: 'monte-titano', name: 'Monte Titano', region: 'Apeniny', countries: ['San Marino'], range: 'Apeniny', height: 739, difficultySummer: 1.5, difficultyWinter: 2.0, achievementIds: ['korona_europy']),
    // Watykan - Wzgórze Watykańskie
    Peak(id: 'watykan', name: 'Wzgórze Watykańskie', region: 'Rzym', countries: ['Watykan'], range: 'Wzgórza Rzymskie', height: 75, difficultySummer: 1.0, difficultyWinter: 1.0, achievementIds: ['korona_europy']),
    // Malta - Ta Dmejrek
    Peak(id: 'ta-dmejrek', name: 'Ta\' Dmejrek', region: 'Dingli', countries: ['Malta'], range: 'brak', height: 253, difficultySummer: 1.0, difficultyWinter: 1.0, achievementIds: ['korona_europy']),
    // Cypr - Olimp (Cypr)
    Peak(id: 'olimp-cypr', name: 'Olimp (Cypr)', region: 'Troodos', countries: ['Cypr'], range: 'Troodos', height: 1952, difficultySummer: 2.0, difficultyWinter: 2.5, achievementIds: ['korona_europy']),
    // Estonia - Suur Munamägi
    Peak(id: 'suur-munamagi', name: 'Suur Munamägi', region: 'Haanja', countries: ['Estonia'], range: 'brak', height: 318, difficultySummer: 1.0, difficultyWinter: 1.0, achievementIds: ['korona_europy']),
    // Łotwa - Gaiziņkalns
    Peak(id: 'gaizinkalns', name: 'Gaiziņkalns', region: 'Vidzeme', countries: ['Łotwa'], range: 'brak', height: 312, difficultySummer: 1.0, difficultyWinter: 1.0, achievementIds: ['korona_europy']),
    // Litwa - Aukštojas
    Peak(id: 'aukstojas', name: 'Aukštojas', region: 'Aukštaitija', countries: ['Litwa'], range: 'brak', height: 294, difficultySummer: 1.0, difficultyWinter: 1.0, achievementIds: ['korona_europy']),
    // Białoruś - Dziarżynskaja Hara
    Peak(id: 'dziarzynska', name: 'Dziarżynskaja Hara', region: 'Mińsk', countries: ['Białoruś'], range: 'brak', height: 345, difficultySummer: 1.0, difficultyWinter: 1.5, achievementIds: ['korona_europy']),
    // Mołdawia - Bălănești
    Peak(id: 'balanesti', name: 'Bălănești', region: 'Codrii', countries: ['Mołdawia'], range: 'brak', height: 430, difficultySummer: 1.0, difficultyWinter: 1.5, achievementIds: ['korona_europy']),
    // Dania - Møllehøj
    Peak(id: 'mollehoj', name: 'Møllehøj', region: 'Jutlandia', countries: ['Dania'], range: 'brak', height: 171, difficultySummer: 1.0, difficultyWinter: 1.0, achievementIds: ['korona_europy']),
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

  // ============ MOCK DATA - Użytkownicy ============
  
  // ID zalogowanego użytkownika
  static const String currentUserId = 'user1';

  // Wszyscy użytkownicy w systemie
  final Map<String, AppUser> _users = {
    'user1': AppUser(
      id: 'user1',
      name: 'Jan Kowalski',
      stats: UserStats(
        totalPeaks: 5,
        totalElevationGain: 8173,
        totalExpeditions: 5,
        highestPeak: 2499,
        highestPeakName: 'Rysy',
      ),
      highestPeakName: 'Rysy',
      highestPeakHeight: 2499,
      highestPeakRegion: 'Tatry',
      conqueredPeaksCount: 4,
      friendIds: ['friend1', 'friend2', 'friend3'],
    ),
    'friend1': AppUser(
      id: 'friend1',
      name: 'Anna Nowak',
      stats: UserStats(
        totalPeaks: 15,
        totalElevationGain: 18500,
        totalExpeditions: 20,
        highestPeak: 2499,
        highestPeakName: 'Rysy',
      ),
      highestPeakName: 'Rysy',
      highestPeakHeight: 2499,
      highestPeakRegion: 'Tatry',
      conqueredPeaksCount: 15,
      friendIds: ['user1', 'friend2', 'friend4'],
    ),
    'friend2': AppUser(
      id: 'friend2',
      name: 'Piotr Kowalski',
      stats: UserStats(
        totalPeaks: 8,
        totalElevationGain: 9200,
        totalExpeditions: 12,
        highestPeak: 1894,
        highestPeakName: 'Giewont',
      ),
      highestPeakName: 'Giewont',
      highestPeakHeight: 1894,
      highestPeakRegion: 'Tatry',
      conqueredPeaksCount: 8,
      friendIds: ['user1', 'friend1', 'friend3'],
    ),
    'friend3': AppUser(
      id: 'friend3',
      name: 'Kasia Wiśniewska',
      stats: UserStats(
        totalPeaks: 22,
        totalElevationGain: 28000,
        totalExpeditions: 35,
        highestPeak: 2499,
        highestPeakName: 'Rysy',
      ),
      highestPeakName: 'Rysy',
      highestPeakHeight: 2499,
      highestPeakRegion: 'Tatry',
      conqueredPeaksCount: 22,
      friendIds: ['user1', 'friend2', 'friend4', 'friend5'],
    ),
    'friend4': AppUser(
      id: 'friend4',
      name: 'Marek Zieliński',
      stats: UserStats(
        totalPeaks: 12,
        totalElevationGain: 14500,
        totalExpeditions: 18,
        highestPeak: 2301,
        highestPeakName: 'Świnica',
      ),
      highestPeakName: 'Świnica',
      highestPeakHeight: 2301,
      highestPeakRegion: 'Tatry',
      conqueredPeaksCount: 12,
      friendIds: ['friend1', 'friend3'],
    ),
    'friend5': AppUser(
      id: 'friend5',
      name: 'Ewa Nowicka',
      stats: UserStats(
        totalPeaks: 6,
        totalElevationGain: 7800,
        totalExpeditions: 10,
        highestPeak: 1725,
        highestPeakName: 'Babia Góra',
      ),
      highestPeakName: 'Babia Góra',
      highestPeakHeight: 1725,
      highestPeakRegion: 'Beskid Żywiecki',
      conqueredPeaksCount: 6,
      friendIds: ['friend3'],
    ),
  };

  // ============ MOCK DATA - Osiągnięcia (z dynamicznym postępem) ============

  // Definicje osiągnięć - postęp będzie obliczany dynamicznie
  static const Map<String, Map<String, dynamic>> _achievementDefinitions = {
    'korona_polski': {
      'name': 'Korona Gór Polski',
      'description': 'Zdobądź wszystkie 28 szczytów Korony Gór Polski',
      'icon': '👑',
    },
    'korona_tatr': {
      'name': 'Korona Tatr',
      'description': 'Zdobądź główne szczyty Tatr',
      'icon': '🏔️',
    },
    'korona_europy': {
      'name': 'Korona Europy',
      'description': 'Zdobądź najwyższe szczyty każdego kraju europejskiego',
      'icon': '🌍',
    },
    // Osiągnięcia za przewyższenie
    'elevation_1k': {
      'name': 'Pierwsze 1000 m',
      'description': 'Zdobądź łącznie 1000 metrów przewyższenia',
      'icon': '📈',
      'type': 'elevation',
      'target': 1000,
    },
    'elevation_5k': {
      'name': 'Połowa dnia na stoku',
      'description': 'Zdobądź łącznie 5000 metrów przewyższenia',
      'icon': '⛰️',
      'type': 'elevation',
      'target': 5000,
    },
    'elevation_10k': {
      'name': 'Adept przewyższeń',
      'description': 'Zdobądź łącznie 10 000 metrów przewyższenia',
      'icon': '🦅',
      'type': 'elevation',
      'target': 10000,
    },
    'elevation_25k': {
      'name': 'Mistrz wznoszenia',
      'description': 'Zdobądź łącznie 25 000 metrów przewyższenia',
      'icon': '🚀',
      'type': 'elevation',
      'target': 25000,
    },
    'elevation_50k': {
      'name': 'Zdobywca nieba',
      'description': 'Zdobądź łącznie 50 000 metrów przewyższenia',
      'icon': '🌟',
      'type': 'elevation',
      'target': 50000,
    },
    // Osiągnięcia za liczbę wypraw
    'expeditions_5': {
      'name': 'Początkujący podróżnik',
      'description': 'Ukończ 5 wypraw',
      'icon': '🥾',
      'type': 'expeditions',
      'target': 5,
    },
    'expeditions_10': {
      'name': 'Doświadczony wędrowiec',
      'description': 'Ukończ 10 wypraw',
      'icon': '🎒',
      'type': 'expeditions',
      'target': 10,
    },
    'expeditions_25': {
      'name': 'Zaprawiony górołaz',
      'description': 'Ukończ 25 wypraw',
      'icon': '🧗',
      'type': 'expeditions',
      'target': 25,
    },
    'expeditions_50': {
      'name': 'Weteran wypraw',
      'description': 'Ukończ 50 wypraw',
      'icon': '🏅',
      'type': 'expeditions',
      'target': 50,
    },
    // Osiągnięcia za liczbę zdobytych szczytów
    'peaks_5': {
      'name': 'Pierwszy krok',
      'description': 'Zdobądź 5 różnych szczytów',
      'icon': '🔰',
      'type': 'peaks',
      'target': 5,
    },
    'peaks_10': {
      'name': 'Kolekcjoner szczytów',
      'description': 'Zdobądź 10 różnych szczytów',
      'icon': '📍',
      'type': 'peaks',
      'target': 10,
    },
    'peaks_25': {
      'name': 'Odkrywca gór',
      'description': 'Zdobądź 25 różnych szczytów',
      'icon': '🗺️',
      'type': 'peaks',
      'target': 25,
    },
    'peaks_50': {
      'name': 'Mistrz szczytów',
      'description': 'Zdobądź 50 różnych szczytów',
      'icon': '🏆',
      'type': 'peaks',
      'target': 50,
    },
  };

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

  /// Pobierz aktualnie zalogowanego użytkownika
  Future<AppUser> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _users[currentUserId]!;
  }

  /// Pobierz użytkownika po ID
  Future<AppUser?> getUserById(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _users[userId];
  }

  /// Sprawdź czy użytkownik jest zalogowanym użytkownikiem
  bool isCurrentUser(String userId) {
    return userId == currentUserId;
  }

  /// Pobierz znajomych zalogowanego użytkownika
  Future<List<AppUser>> getFriends() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final currentUser = _users[currentUserId]!;
    return currentUser.friendIds
        .map((id) => _users[id])
        .whereType<AppUser>()
        .toList();
  }

  /// Pobierz znajomych konkretnego użytkownika
  Future<List<AppUser>> getFriendsForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final user = _users[userId];
    if (user == null) return [];
    return user.friendIds
        .map((id) => _users[id])
        .whereType<AppUser>()
        .toList();
  }

  /// Pobierz osiągnięcia z dynamicznym postępem
  Future<List<Achievement>> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Get user stats for elevation/expeditions/peaks achievements
    final userStats = await getUserStats(currentUserId);
    final climbedPeaks = await getClimbedPeakIds(currentUserId);
    
    final achievements = <Achievement>[];
    
    for (final entry in _achievementDefinitions.entries) {
      final id = entry.key;
      final def = entry.value;
      final type = def['type'] as String?;
      
      if (type == 'elevation') {
        // Elevation-based achievement
        final target = def['target'] as int;
        final current = userStats.totalElevationGain;
        achievements.add(Achievement(
          id: id,
          name: def['name'] as String,
          description: def['description'] as String,
          icon: def['icon'] as String,
          requiredPeaks: target,
          conqueredPeaks: current.clamp(0, target),
          unlocked: current >= target,
        ));
      } else if (type == 'expeditions') {
        // Expeditions count achievement
        final target = def['target'] as int;
        final current = userStats.totalExpeditions;
        achievements.add(Achievement(
          id: id,
          name: def['name'] as String,
          description: def['description'] as String,
          icon: def['icon'] as String,
          requiredPeaks: target,
          conqueredPeaks: current.clamp(0, target),
          unlocked: current >= target,
        ));
      } else if (type == 'peaks') {
        // Unique peaks count achievement
        final target = def['target'] as int;
        final current = climbedPeaks.length;
        achievements.add(Achievement(
          id: id,
          name: def['name'] as String,
          description: def['description'] as String,
          icon: def['icon'] as String,
          requiredPeaks: target,
          conqueredPeaks: current.clamp(0, target),
          unlocked: current >= target,
        ));
      } else {
        // Peak collection achievement (Korona Polski, etc.)
        final peaksForAchievement = _peaks.where(
          (p) => p.achievementIds.contains(id)
        ).toList();
        
        final conqueredCount = peaksForAchievement.where((p) => p.isConquered).length;
        final totalCount = peaksForAchievement.length;
        
        achievements.add(Achievement(
          id: id,
          name: def['name'] as String,
          description: def['description'] as String,
          icon: def['icon'] as String,
          requiredPeaks: totalCount,
          conqueredPeaks: conqueredCount,
          unlocked: conqueredCount >= totalCount && totalCount > 0,
        ));
      }
    }
    
    return achievements;
  }

  /// Pobierz szczegóły osiągnięcia (szczyty)
  Future<List<Peak>> getPeaksForAchievement(String achievementId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _peaks.where((p) => p.achievementIds.contains(achievementId)).toList()
      ..sort((a, b) => b.height.compareTo(a.height));
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

  /// Wyszukaj szczyty z filtrami
  Future<List<Peak>> searchPeaksFiltered({
    String? query,
    String? country,
    String? range,
    String? achievementId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    var results = _peaks.toList();
    
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.region.toLowerCase().contains(q)
      ).toList();
    }
    
    if (country != null && country.isNotEmpty) {
      results = results.where((p) => p.countries.contains(country)).toList();
    }
    
    if (range != null && range.isNotEmpty) {
      results = results.where((p) => p.range == range).toList();
    }
    
    if (achievementId != null && achievementId.isNotEmpty) {
      results = results.where((p) => p.achievementIds.contains(achievementId)).toList();
    }
    
    return results..sort((a, b) => b.height.compareTo(a.height));
  }

  /// Pobierz listę dostępnych krajów
  Future<List<String>> getAvailableCountries() async {
    final countries = _peaks
        .expand((p) => p.countries)
        .toSet()
        .toList()
      ..sort();
    return countries;
  }

  /// Pobierz listę dostępnych pasm
  Future<List<String>> getAvailableRanges() async {
    final ranges = _peaks
        .map((p) => p.range)
        .whereType<String>()
        .where((r) => r != 'brak')
        .toSet()
        .toList()
      ..sort();
    return ranges;
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
