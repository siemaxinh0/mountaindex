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
  AppUser? _currentUser;
  Peak? _highestConqueredPeak;
  List<Achievement> _achievements = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final currentUser = await _dataService.getCurrentUser();
    final peaks = await _dataService.getAllPeaks();
    final achievements = await _dataService.getAchievements();
    final conqueredPeaks = peaks.where((p) => p.isConquered).toList();
    
    // Znajdź najwyższy zdobyty szczyt
    Peak? highest;
    if (conqueredPeaks.isNotEmpty) {
      highest = conqueredPeaks.reduce((a, b) => a.height > b.height ? a : b);
    }
    
    setState(() {
      _currentUser = currentUser;
      _highestConqueredPeak = highest;
      _achievements = achievements;
      _loading = false;
    });
  }

  void _navigateToProfile() {
    if (_currentUser == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(user: _currentUser!),
      ),
    );
  }

  void _navigateToAchievementDetails(Achievement achievement) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementDetailScreen(achievement: achievement),
      ),
    );
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
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // ===== KLIKALNY BANER POWITALNY =====
                  _WelcomeBanner(
                    user: _currentUser!,
                    onTap: _navigateToProfile,
                  ),
                  const SizedBox(height: 24),

                  // ===== NAGŁÓWEK STATYSTYK =====
                  Text('Twoje Statystyki', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  
                  // ===== LISTA STATYSTYK =====
                  _StatListTile(
                    icon: Icons.terrain,
                    iconColor: theme.colorScheme.primary,
                    title: 'Zdobyte szczyty',
                    value: '${_currentUser?.stats.totalPeaks ?? 0}',
                    subtitle: 'z Twojej listy',
                  ),
                  _StatListTile(
                    icon: Icons.trending_up,
                    iconColor: theme.colorScheme.tertiary,
                    title: 'Łączne przewyższenie',
                    value: '${((_currentUser?.stats.totalElevationGain ?? 0) / 1000).toStringAsFixed(1)} km',
                    subtitle: 'suma wszystkich wejść',
                  ),
                  _StatListTile(
                    icon: Icons.flag,
                    iconColor: Colors.amber[700]!,
                    title: 'Najwyższy zdobyty',
                    value: _highestConqueredPeak != null 
                        ? '${_highestConqueredPeak!.height} m' 
                        : '—',
                    subtitle: _highestConqueredPeak?.name ?? 'brak zdobyć',
                  ),
                  _StatListTile(
                    icon: Icons.hiking,
                    iconColor: Colors.orange,
                    title: 'Łączne wyprawy',
                    value: '${_currentUser?.stats.totalExpeditions ?? 0}',
                    subtitle: 'wszystkie wyjścia w góry',
                  ),
                  
                  const SizedBox(height: 24),

                  // ===== OSIĄGNIĘCIA =====
                  Text('Osiągnięcia', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ..._achievements.map((achievement) => _AchievementCard(
                    achievement: achievement,
                    onTap: () => _navigateToAchievementDetails(achievement),
                  )),
                ],
              ),
            ),
    );
  }
}

// ===== KLIKALNY BANER POWITALNY =====
class _WelcomeBanner extends StatelessWidget {
  final AppUser user;
  final VoidCallback onTap;

  const _WelcomeBanner({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      color: theme.colorScheme.primaryContainer,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Hero(
                tag: 'profile_avatar',
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Witaj, ${user.name.split(' ').first}!', style: theme.textTheme.headlineSmall),
                    Text(user.rank, style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                    )),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== WIERSZ STATYSTYKI =====
class _StatListTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String? subtitle;

  const _StatListTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Ikona w kółku
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                // Nazwa i podtytuł
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleSmall),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                // Wartość
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== KARTA POSTĘPU KORONY =====
class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback onTap;

  const _AchievementCard({
    required this.achievement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (achievement.progress * 100).round();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: achievement.unlocked 
                          ? Colors.amber.withOpacity(0.15) 
                          : Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        achievement.icon, 
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${achievement.conqueredPeaks} z ${achievement.requiredPeaks} szczytów',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: achievement.unlocked 
                          ? Colors.green.withOpacity(0.15)
                          : theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      achievement.unlocked ? '✓' : '$percentage%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: achievement.unlocked 
                            ? Colors.green 
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: achievement.progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    achievement.unlocked ? Colors.green : theme.colorScheme.primary,
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

// ============ ACHIEVEMENT DETAIL SCREEN ============
class AchievementDetailScreen extends StatefulWidget {
  final Achievement achievement;

  const AchievementDetailScreen({super.key, required this.achievement});

  @override
  State<AchievementDetailScreen> createState() => _AchievementDetailScreenState();
}

class _AchievementDetailScreenState extends State<AchievementDetailScreen> {
  final DataService _dataService = DataService();
  List<Peak> _peaks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPeaks();
  }

  Future<void> _loadPeaks() async {
    final peaks = await _dataService.getPeaksForAchievement(widget.achievement.id);
    setState(() {
      _peaks = peaks;
      _loading = false;
    });
  }

  Future<void> _togglePeakConquered(String peakId) async {
    await _dataService.togglePeakConquered(peakId);
    await _loadPeaks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final achievement = widget.achievement;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(achievement.name),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Nagłówek z postępem
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: achievement.unlocked 
                                ? Colors.amber.withOpacity(0.2) 
                                : Colors.grey.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              achievement.icon, 
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          achievement.description,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${achievement.conqueredPeaks}',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              ' / ${achievement.requiredPeaks}',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: achievement.progress,
                              minHeight: 12,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                achievement.unlocked ? Colors.green : theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Lista szczytów
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Text('Szczyty', style: theme.textTheme.titleLarge),
                  ),
                ),
                
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final peak = _peaks[index];
                        return _AchievementPeakTile(
                          peak: peak,
                          onToggle: () => _togglePeakConquered(peak.id),
                        );
                      },
                      childCount: _peaks.length,
                    ),
                  ),
                ),
                
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            ),
    );
  }
}

class _AchievementPeakTile extends StatelessWidget {
  final Peak peak;
  final VoidCallback onToggle;

  const _AchievementPeakTile({
    required this.peak,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: peak.isConquered 
                ? Colors.green.withOpacity(0.15)
                : Colors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            peak.isConquered ? Icons.check_circle : Icons.radio_button_unchecked,
            color: peak.isConquered ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          peak.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: peak.isConquered ? TextDecoration.lineThrough : null,
            color: peak.isConquered 
                ? theme.colorScheme.onSurface.withOpacity(0.5) 
                : null,
          ),
        ),
        subtitle: Text(
          '${peak.height} m • ${peak.country ?? peak.region}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(
            peak.isConquered ? Icons.close : Icons.check,
            color: peak.isConquered ? Colors.red : Colors.green,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

// ============ USER PROFILE SCREEN ============
class UserProfileScreen extends StatefulWidget {
  final AppUser user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final DataService _dataService = DataService();
  List<AppUser> _friends = [];
  bool _loading = true;
  bool _isCurrentUser = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isCurrentUser = _dataService.isCurrentUser(widget.user.id);
    final friends = await _dataService.getFriendsForUser(widget.user.id);
    setState(() {
      _isCurrentUser = isCurrentUser;
      _friends = friends;
      _loading = false;
    });
  }

  void _navigateToFriendProfile(AppUser friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(user: friend),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = widget.user;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ===== NAGŁÓWEK PROFILU =====
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: theme.colorScheme.primaryContainer,
            actions: [
              if (_isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edycja profilu wkrótce!')),
                    );
                  },
                  tooltip: 'Edytuj profil',
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar
                        Hero(
                          tag: _isCurrentUser ? 'profile_avatar' : 'avatar_${user.id}',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: theme.colorScheme.secondary,
                              child: Text(
                                user.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Imię
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Ranga
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.military_tech, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                user.rank,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ===== TREŚĆ =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== NAJWYŻSZY ZDOBYTY SZCZYT =====
                  if (user.highestPeakName != null) ...[
                    _HighlightCard(
                      peakName: user.highestPeakName!,
                      peakHeight: user.highestPeakHeight ?? 0,
                      peakRegion: user.highestPeakRegion ?? '',
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ===== PODSUMOWANIE STATYSTYK =====
                  Text('Podsumowanie', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _ProfileStatsSummary(user: user),
                  const SizedBox(height: 24),

                  // ===== ZNAJOMI =====
                  Text('Znajomi', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (_loading)
                    const Center(child: CircularProgressIndicator())
                  else
                    _FriendsSection(
                      friends: _friends,
                      onFriendTap: _navigateToFriendProfile,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== KARTA NAJWYŻSZEGO SZCZYTU =====
class _HighlightCard extends StatelessWidget {
  final String peakName;
  final int peakHeight;
  final String peakRegion;

  const _HighlightCard({
    required this.peakName,
    required this.peakHeight,
    required this.peakRegion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.emoji_events, color: Colors.amber, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Najwyższy zdobyty szczyt',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  peakName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$peakHeight m n.p.m. • $peakRegion',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== PODSUMOWANIE STATYSTYK W PROFILU =====
class _ProfileStatsSummary extends StatelessWidget {
  final AppUser user;

  const _ProfileStatsSummary({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MiniStatItem(
              icon: Icons.terrain,
              value: '${user.stats.totalPeaks}',
              label: 'Szczyty',
              color: theme.colorScheme.primary,
            ),
            _MiniStatItem(
              icon: Icons.hiking,
              value: '${user.stats.totalExpeditions}',
              label: 'Wyprawy',
              color: Colors.orange,
            ),
            _MiniStatItem(
              icon: Icons.trending_up,
              value: '${(user.stats.totalElevationGain / 1000).toStringAsFixed(1)}k',
              label: 'Wysokość',
              color: theme.colorScheme.tertiary,
            ),
            _MiniStatItem(
              icon: Icons.workspace_premium,
              value: '${user.conqueredPeaksCount}/28',
              label: 'Korona',
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

// ===== SEKCJA ZNAJOMYCH =====
class _FriendsSection extends StatelessWidget {
  final List<AppUser> friends;
  final void Function(AppUser) onFriendTap;

  const _FriendsSection({
    required this.friends,
    required this.onFriendTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (friends.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text('Brak znajomych', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      );
    }
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return _FriendAvatar(
            friend: friend,
            onTap: () => onFriendTap(friend),
          );
        },
      ),
    );
  }
}

class _FriendAvatar extends StatelessWidget {
  final AppUser friend;
  final VoidCallback onTap;

  const _FriendAvatar({
    required this.friend,
    required this.onTap,
  });

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ];
    return colors[name.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getAvatarColor(friend.name).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: _getAvatarColor(friend.name),
                child: Text(
                  friend.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              friend.name.split(' ').first,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${friend.stats.totalPeaks} szczytów',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
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
  List<String> _countries = [];
  bool _loading = true;
  String _searchQuery = '';
  String _seasonFilter = 'Lato'; // 'Lato' lub 'Zima'
  String _statusFilter = 'Wszystkie'; // 'Wszystkie', 'Zdobyte', 'Do zdobycia'
  String? _countryFilter; // Filtr kraju (null = wszystkie)

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final peaks = await _dataService.getAllPeaks();
    final countries = await _dataService.getAvailableCountries();
    setState(() {
      _peaks = peaks;
      _countries = countries;
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
    
    // Filtruj po kraju
    if (_countryFilter != null && _countryFilter!.isNotEmpty) {
      result = result.where((p) => p.countries.contains(_countryFilter)).toList();
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
    await _loadData();
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
                
                // ===== FILTR KRAJU =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.flag, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          value: _countryFilter,
                          decoration: InputDecoration(
                            labelText: 'Kraj',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            isDense: true,
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Wszystkie kraje'),
                            ),
                            ..._countries.map((c) => DropdownMenuItem<String?>(
                              value: c,
                              child: Text('${Peak.countryFlags[c] ?? '🏳️'} $c'),
                            )),
                          ],
                          onChanged: (v) => setState(() => _countryFilter = v),
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
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                peak.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (peak.flags.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(
                                peak.flags,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ],
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
    final currentUser = await _dataService.getCurrentUser();
    final friends = await _dataService.getFriendsForUser(currentUser.id);
    final achievements = await _dataService.getAchievements();
    setState(() {
      _friends = friends;
      _achievements = achievements;
      _loading = false;
    });
  }

  void _navigateToProfile(AppUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(user: user),
      ),
    );
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
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _navigateToProfile(friend),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Text(friend.initials),
              ),
              title: Text(friend.name),
              subtitle: Text('${friend.stats.totalPeaks} szczytów • ${friend.rank}'),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
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
