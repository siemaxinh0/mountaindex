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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _dataService.getUserStats('user1');
    setState(() {
      _stats = stats;
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
                                      Text('Postęp: 3 z 28', style: theme.textTheme.titleMedium),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: 3 / 28,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('11%', style: theme.textTheme.titleLarge?.copyWith(
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

// ============ PEAKS SCREEN ============
class PeaksScreen extends StatefulWidget {
  const PeaksScreen({super.key});

  @override
  State<PeaksScreen> createState() => _PeaksScreenState();
}

class _PeaksScreenState extends State<PeaksScreen> {
  final DataService _dataService = DataService();
  List<Peak> _peaks = [];
  Set<String> _climbedIds = {};
  bool _loading = true;
  String _filter = 'Wszystkie';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPeaks();
  }

  Future<void> _loadPeaks() async {
    final peaks = await _dataService.getAllPeaks();
    final climbedIds = await _dataService.getClimbedPeakIds('user1');
    setState(() {
      _peaks = peaks;
      _climbedIds = climbedIds;
      _loading = false;
    });
  }

  List<Peak> get _filteredPeaks {
    var result = _peaks;
    
    if (_filter == 'Korona Gór Polski') {
      result = result.where((p) => p.crowns.contains('Korona Gór Polski')).toList();
    } else if (_filter == 'Zdobyte') {
      result = result.where((p) => _climbedIds.contains(p.id)).toList();
    } else if (_filter == 'Do zdobycia') {
      result = result.where((p) => !_climbedIds.contains(p.id)).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) => 
        p.name.toLowerCase().contains(q) || 
        p.range.toLowerCase().contains(q)
      ).toList();
    }
    
    return result..sort((a, b) => b.altitude.compareTo(a.altitude));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baza Szczytów'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Szukaj szczytu...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                // Filters
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (final filter in ['Wszystkie', 'Korona Gór Polski', 'Zdobyte', 'Do zdobycia'])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: _filter == filter,
                            onSelected: (s) => setState(() => _filter = filter),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Peak list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPeaks.length,
                    itemBuilder: (context, index) {
                      final peak = _filteredPeaks[index];
                      final isClimbed = _climbedIds.contains(peak.id);
                      return _PeakCard(peak: peak, isClimbed: isClimbed);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _PeakCard extends StatelessWidget {
  final Peak peak;
  final bool isClimbed;

  const _PeakCard({required this.peak, required this.isClimbed});

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'łatwy': return Colors.green;
      case 'umiarkowany': return Colors.orange;
      case 'trudny': return Colors.red;
      case 'bardzo trudny': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isClimbed 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isClimbed ? Icons.check_circle : Icons.circle_outlined,
                  color: isClimbed ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(peak.name, style: theme.textTheme.titleMedium),
                        ),
                        if (peak.crowns.contains('Korona Gór Polski'))
                          const Icon(Icons.workspace_premium, color: Colors.amber, size: 20),
                      ],
                    ),
                    Text('${peak.altitude} m • ${peak.range}', 
                      style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.wb_sunny, size: 14, color: Colors.orange[300]),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(peak.summerDifficulty).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(peak.summerDifficulty, 
                            style: TextStyle(
                              fontSize: 11,
                              color: _getDifficultyColor(peak.summerDifficulty),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.ac_unit, size: 14, color: Colors.blue[300]),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(peak.winterDifficulty).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(peak.winterDifficulty, 
                            style: TextStyle(
                              fontSize: 11,
                              color: _getDifficultyColor(peak.winterDifficulty),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
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
              Row(
                children: [
                  Expanded(
                    child: Text(peak.name, style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  if (isClimbed)
                    Chip(
                      avatar: const Icon(Icons.check, size: 16),
                      label: const Text('Zdobyty'),
                      backgroundColor: Colors.green.withOpacity(0.1),
                    ),
                ],
              ),
              Text('${peak.altitude} m n.p.m. • ${peak.range}'),
              const SizedBox(height: 16),
              if (peak.description != null) ...[
                Text(peak.description!),
                const SizedBox(height: 16),
              ],
              const Text('Trudność:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(Icons.wb_sunny, color: Colors.orange),
                        const Text('Lato'),
                        Text(peak.summerDifficulty, 
                          style: TextStyle(color: _getDifficultyColor(peak.summerDifficulty)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(Icons.ac_unit, color: Colors.blue),
                        const Text('Zima'),
                        Text(peak.winterDifficulty, 
                          style: TextStyle(color: _getDifficultyColor(peak.winterDifficulty)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (peak.crowns.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: peak.crowns.map((c) => Chip(
                    avatar: const Icon(Icons.workspace_premium, size: 16, color: Colors.amber),
                    label: Text(c),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Planowanie wyprawy wkrótce!')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(isClimbed ? 'Zaplanuj ponownie' : 'Zaplanuj wyprawę'),
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
