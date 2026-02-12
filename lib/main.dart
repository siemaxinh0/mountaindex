import 'package:flutter/material.dart';
import 'models/models.dart';
import 'services/data_service.dart';

void main() {
  runApp(const MountainindexApp());
}

class MountainindexApp extends StatelessWidget {
  const MountainindexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mountainindex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ============ HOME SCREEN ============
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    StatsScreen(),
    JournalScreen(),
    PeaksScreen(),
    CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statystyki',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Dziennik',
          ),
          NavigationDestination(
            icon: Icon(Icons.terrain_outlined),
            selectedIcon: Icon(Icons.terrain),
            label: 'Szczyty',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Społeczność',
          ),
        ],
      ),
    );
  }
}

// ============ STATS SCREEN ============
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final DataService _dataService = DataService();
  UserStats? _stats;
  int _conqueredPeaks = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _dataService.getUserStats('user1');
    final peaks = await _dataService.getAllPeaks();
    setState(() {
      _stats = stats;
      _conqueredPeaks = peaks.where((p) => p.isConquered).length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mountainindex'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: theme.colorScheme.primary,
                              child: const Text('JK', style: TextStyle(color: Colors.white, fontSize: 20)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Witaj, Jan!', style: theme.textTheme.headlineSmall),
                                  Text('Zdobywca gór', style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats Grid
                    Text('Twoje Statystyki', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        _StatCard(
                          icon: Icons.terrain,
                          title: 'Zdobyte szczyty',
                          value: '${_stats?.totalPeaks ?? 0}',
                          color: theme.colorScheme.primary,
                        ),
                        _StatCard(
                          icon: Icons.trending_up,
                          title: 'Przewyższenie',
                          value: '${((_stats?.totalElevationGain ?? 0) / 1000).toStringAsFixed(1)} km',
                          color: theme.colorScheme.tertiary,
                        ),
                        _StatCard(
                          icon: Icons.flag,
                          title: 'Najwyższy',
                          value: '${_stats?.highestPeak ?? 0} m',
                          subtitle: _stats?.highestPeakName,
                          color: theme.colorScheme.secondary,
                        ),
                        _StatCard(
                          icon: Icons.hiking,
                          title: 'Wyprawy',
                          value: '${_stats?.totalExpeditions ?? 0}',
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Crown Progress
                    Text('Korona Gór Polski', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.workspace_premium, color: Colors.amber, size: 40),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Postęp: $_conqueredPeaks z 28', style: theme.textTheme.titleMedium),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: _conqueredPeaks / 28,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${(_conqueredPeaks / 28 * 100).round()}%', style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(value, style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            )),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            if (subtitle != null)
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              )),
          ],
        ),
      ),
    );
  }
}

// ============ JOURNAL SCREEN ============
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final DataService _dataService = DataService();
  List<Expedition> _expeditions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExpeditions();
  }

  Future<void> _loadExpeditions() async {
    final expeditions = await _dataService.getUserExpeditions('user1');
    setState(() {
      _expeditions = expeditions;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dziennik Wypraw'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dodawanie wypraw wkrótce!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nowa wyprawa'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _expeditions.isEmpty
              ? const Center(child: Text('Brak wypraw'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _expeditions.length,
                  itemBuilder: (context, index) {
                    final exp = _expeditions[index];
                    return _ExpeditionCard(expedition: exp);
                  },
                ),
    );
  }
}

class _ExpeditionCard extends StatelessWidget {
  final Expedition expedition;

  const _ExpeditionCard({required this.expedition});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = '${expedition.date.day}.${expedition.date.month}.${expedition.date.year}';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Photo placeholder
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.terrain, color: theme.colorScheme.primary),
                    Text('${expedition.peakAltitude}m', 
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expedition.peakName, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(dateStr, style: theme.textTheme.bodySmall),
                        if (expedition.participants.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.people, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('+${expedition.participants.length}', 
                            style: theme.textTheme.bodySmall),
                        ],
                      ],
                    ),
                    if (expedition.note != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        expedition.note!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Rating
              if (expedition.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    Text('${expedition.rating}', style: theme.textTheme.titleMedium),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(expedition.peakName, style: Theme.of(context).textTheme.headlineSmall),
              Text('${expedition.peakAltitude} m n.p.m.'),
              const SizedBox(height: 16),
              if (expedition.note != null) ...[
                const Text('Notatka:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(expedition.note!),
                const SizedBox(height: 12),
              ],
              if (expedition.participants.isNotEmpty) ...[
                const Text('Uczestnicy:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(expedition.participants.join(', ')),
              ],
              const SizedBox(height: 20),
              // Photo placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Dodaj zdjęcie', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ PEAKS SCREEN (Baza Szczytów) ============
class PeaksScreen extends StatefulWidget {
  const PeaksScreen({super.key});

  @override
  State<PeaksScreen> createState() => _PeaksScreenState();
}

class _PeaksScreenState extends State<PeaksScreen> {
  final DataService _dataService = DataService();
  List<Peak> _peaks = [];
  bool _loading = true;
  String _searchQuery = '';
  String _seasonFilter = 'Lato'; // 'Lato' lub 'Zima'
  String _statusFilter = 'Wszystkie'; // 'Wszystkie', 'Zdobyte', 'Do zdobycia'

  @override
  void initState() {
    super.initState();
    _loadPeaks();
  }

  Future<void> _loadPeaks() async {
    final peaks = await _dataService.getAllPeaks();
    setState(() {
      _peaks = peaks;
      _loading = false;
    });
  }

  List<Peak> get _filteredPeaks {
    var result = List<Peak>.from(_peaks);
    
    // Filtruj po statusie zdobycia
    if (_statusFilter == 'Zdobyte') {
      result = result.where((p) => p.isConquered).toList();
    } else if (_statusFilter == 'Do zdobycia') {
      result = result.where((p) => !p.isConquered).toList();
    }
    
    // Filtruj po nazwie/regionie
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) => 
        p.name.toLowerCase().contains(q) || 
        p.region.toLowerCase().contains(q)
      ).toList();
    }
    
    // Sortuj po wysokości (malejąco)
    return result..sort((a, b) => b.height.compareTo(a.height));
  }

  void _toggleConquered(Peak peak) async {
    await _dataService.togglePeakConquered(peak.id);
    await _loadPeaks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baza Szczytów'),
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              avatar: Icon(Icons.workspace_premium, color: Colors.amber[700], size: 18),
              label: Text(
                '${_peaks.where((p) => p.isConquered).length}/28',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: theme.colorScheme.secondaryContainer,
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ===== WYSZUKIWARKA =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Szukaj szczytu lub regionu...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setState(() => _searchQuery = ''),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),

                // ===== PRZEŁĄCZNIK LATO/ZIMA =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'Lato',
                              label: Text('Lato'),
                              icon: Icon(Icons.wb_sunny),
                            ),
                            ButtonSegment(
                              value: 'Zima',
                              label: Text('Zima'),
                              icon: Icon(Icons.ac_unit),
                            ),
                          ],
                          selected: {_seasonFilter},
                          onSelectionChanged: (s) => setState(() => _seasonFilter = s.first),
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== FILTRY STATUSU =====
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (final filter in ['Wszystkie', 'Zdobyte', 'Do zdobycia'])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: _statusFilter == filter,
                            onSelected: (s) => setState(() => _statusFilter = filter),
                            showCheckmark: false,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ===== LISTA SZCZYTÓW =====
                Expanded(
                  child: _filteredPeaks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text('Brak wyników', style: theme.textTheme.titleMedium),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredPeaks.length,
                          itemBuilder: (context, index) {
                            final peak = _filteredPeaks[index];
                            return _PeakCard(
                              peak: peak,
                              showSummer: _seasonFilter == 'Lato',
                              onToggleConquered: () => _toggleConquered(peak),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// ===== WIDGET GWIAZDEK TRUDNOŚCI =====
class _DifficultyStars extends StatelessWidget {
  final double difficulty;
  final Color color;
  final double size;

  const _DifficultyStars({
    required this.difficulty,
    this.color = Colors.amber,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        if (difficulty >= starValue) {
          // Pełna gwiazdka
          return Icon(Icons.star, color: color, size: size);
        } else if (difficulty >= starValue - 0.5) {
          // Połówka gwiazdki
          return Icon(Icons.star_half, color: color, size: size);
        } else {
          // Pusta gwiazdka
          return Icon(Icons.star_border, color: color.withOpacity(0.4), size: size);
        }
      }),
    );
  }
}

// ===== KARTA SZCZYTU =====
class _PeakCard extends StatelessWidget {
  final Peak peak;
  final bool showSummer;
  final VoidCallback onToggleConquered;

  const _PeakCard({
    required this.peak,
    required this.showSummer,
    required this.onToggleConquered,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final difficulty = showSummer ? peak.difficultySummer : peak.difficultyWinter;
    final difficultyColor = showSummer ? Colors.orange : Colors.blue;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Górna część - nazwa i checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ikona zdobycia
                  GestureDetector(
                    onTap: onToggleConquered,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: peak.isConquered 
                            ? Colors.green.withOpacity(0.15) 
                            : Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: peak.isConquered ? Colors.green : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        peak.isConquered ? Icons.check : Icons.add,
                        color: peak.isConquered ? Colors.green : Colors.grey[500],
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  
                  // Nazwa i region
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          peak.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          peak.region,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Wysokość
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${peak.height} m',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Dolna część - trudność
              Row(
                children: [
                  Icon(
                    showSummer ? Icons.wb_sunny : Icons.ac_unit,
                    size: 18,
                    color: difficultyColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    showSummer ? 'Trudność lato:' : 'Trudność zima:',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  _DifficultyStars(
                    difficulty: difficulty,
                    color: difficultyColor,
                    size: 18,
                  ),
                  const Spacer(),
                  if (peak.isConquered && peak.conquerDate != null)
                    Text(
                      '${peak.conquerDate!.day}.${peak.conquerDate!.month}.${peak.conquerDate!.year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Uchwyt
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Nagłówek
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          peak.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          peak.region,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${peak.height}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          'm n.p.m.',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Status zdobycia
              if (peak.isConquered)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Szczyt zdobyty!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            if (peak.conquerDate != null)
                              Text(
                                'Data: ${peak.conquerDate!.day}.${peak.conquerDate!.month}.${peak.conquerDate!.year}',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Trudność
              Text(
                'Trudność szlaku',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // Lato
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wb_sunny, color: Colors.orange[700]),
                              const SizedBox(width: 8),
                              Text(
                                'Lato',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _DifficultyStars(
                            difficulty: peak.difficultySummer,
                            color: Colors.orange,
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${peak.difficultySummer}/5.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Zima
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.ac_unit, color: Colors.blue[700]),
                              const SizedBox(width: 8),
                              Text(
                                'Zima',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _DifficultyStars(
                            difficulty: peak.difficultyWinter,
                            color: Colors.blue,
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${peak.difficultyWinter}/5.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Przycisk akcji
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    onToggleConquered();
                    Navigator.pop(context);
                  },
                  icon: Icon(peak.isConquered ? Icons.close : Icons.check),
                  label: Text(peak.isConquered ? 'Oznacz jako niezdobyty' : 'Oznacz jako zdobyty'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: peak.isConquered ? Colors.red[400] : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ COMMUNITY SCREEN ============
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  final DataService _dataService = DataService();
  late TabController _tabController;
  List<AppUser> _friends = [];
  List<Achievement> _achievements = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final friends = await _dataService.getFriends();
    final achievements = await _dataService.getAchievements();
    setState(() {
      _friends = friends;
      _achievements = achievements;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Społeczność'),
        backgroundColor: theme.colorScheme.primaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Znajomi'),
            Tab(text: 'Osiągnięcia'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsTab(),
                _buildAchievementsTab(),
              ],
            ),
    );
  }

  Widget _buildFriendsTab() {
    if (_friends.isEmpty) {
      return const Center(child: Text('Brak znajomych'));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        final friend = _friends[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(friend.name[0]),
            ),
            title: Text(friend.name),
            subtitle: Text('${friend.stats.totalPeaks} szczytów • ${friend.stats.highestPeak}m najwyższy'),
            trailing: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wiadomości wkrótce!')),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: achievement.unlocked 
                        ? Colors.amber.withOpacity(0.2) 
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(achievement.icon, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(achievement.name, 
                              style: Theme.of(context).textTheme.titleMedium),
                          ),
                          if (achievement.unlocked)
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        ],
                      ),
                      Text(achievement.description, 
                        style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: achievement.progress,
                          minHeight: 6,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      Text('${(achievement.progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
