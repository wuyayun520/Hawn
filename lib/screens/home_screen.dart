import 'package:flutter/material.dart';
import 'discover_page.dart';
import 'my_challenges_page.dart';
import 'trending_page.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<Widget> _pages = [
    const DiscoverPage(),
    const MyChallengesPage(),
    const TrendingPage(),
    const ProfilePage(),
  ];

  final List<String> _tabImages = [
    'assets/tab/hawn_tab_nor1.webp',
    'assets/tab/hawn_tab_nor2.webp',
    'assets/tab/hawn_tab_nor3.webp',
    'assets/tab/hawn_tab_nor4.webp',
  ];

  final List<String> _tabSelectedImages = [
    'assets/tab/hawn_tab_selete1.webp',
    'assets/tab/hawn_tab_selete2.webp',
    'assets/tab/hawn_tab_selete3.webp',
    'assets/tab/hawn_tab_selete4.webp',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          
          // Floating TabBar
          Positioned(
            left: 40,
            right: 40,
            bottom: 30,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                      _tabController.animateTo(index);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Image.asset(
                        _currentIndex == index
                            ? _tabSelectedImages[index]
                            : _tabImages[index],
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}