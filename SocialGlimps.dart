import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Color Constants (matching AdminPanelPage)
class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF10B981);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Social Glimpse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryOrange,
          secondary: AppColors.primaryOrange,
          surface: AppColors.white,
        ),
      ),
      home: const SocialGlimpsePage(),
    );
  }
}

class SocialGlimpsePage extends StatefulWidget {
  const SocialGlimpsePage({Key? key}) : super(key: key);

  @override
  State<SocialGlimpsePage> createState() => _SocialGlimpsePageState();
}

class _SocialGlimpsePageState extends State<SocialGlimpsePage> {
  int _currentView = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x401A3A52),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              toolbarHeight: 80,
              title: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        "assets/Nss_Logo.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Social Glimpse',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Memories & Moments',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.white, AppColors.lightGrey.withOpacity(0.3)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Tab Selection
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton('Photos', 0, Icons.photo_camera),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          'Videos',
                          1,
                          Icons.play_circle_outline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (_currentView == 0) _buildPhotosTab() else _buildVideosTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, IconData icon) {
    final isActive = _currentView == index;
    return GestureDetector(
      onTap: () => setState(() => _currentView = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.primaryOrange, Color(0xFFFF8A3D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? AppColors.white : AppColors.darkGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.darkGrey,
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosTab() {
    final activities = [
      {
        'title': 'Blood Donation Camp',
        'date': 'Oct 5, 2025',
        'photos': 6,
        'color': AppColors.primaryOrange,
        'imageUrls': [
          'https://images.unsplash.com/photo-1615461066159-fea0960485d5?w=800&q=80',
          'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=800&q=80',
          'https://images.unsplash.com/photo-1615461065929-4f8ffed6ca40?w=800&q=80',
          'https://images.unsplash.com/photo-1584515933487-779824d29309?w=800&q=80',
          'https://images.unsplash.com/photo-1536856136534-bb679c52a9aa?w=800&q=80',
          'https://images.unsplash.com/photo-1579154204601-01588f351e67?w=800&q=80',
        ],
      },
      {
        'title': 'Tree Plantation Drive',
        'date': 'Oct 1, 2025',
        'photos': 8,
        'color': AppColors.successGreen,
        'imageUrls': [
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800&q=80',
          'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=800&q=80',
          'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=800&q=80',
          'https://images.unsplash.com/photo-1592150621744-aca64f48394a?w=800&q=80',
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
          'https://images.unsplash.com/photo-1591958911259-bee2173bdccc?w=800&q=80',
        ],
      },
      {
        'title': 'Beach Cleanup',
        'date': 'Sep 28, 2025',
        'photos': 10,
        'color': Color(0xFF06B6D4),
        'imageUrls': [
          'https://images.unsplash.com/photo-1618477461853-cf6ed80faba5?w=800&q=80',
          'https://images.unsplash.com/photo-1618477388954-7852f32655ec?w=800&q=80',
          'https://images.unsplash.com/photo-1576767976542-4c3c9b08ad8a?w=800&q=80',
          'https://images.unsplash.com/photo-1583264143734-c0b4c7f7e482?w=800&q=80',
          'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=800&q=80',
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80',
        ],
      },
      {
        'title': 'Literacy Campaign',
        'date': 'Sep 25, 2025',
        'photos': 7,
        'color': Color(0xFFFB923C),
        'imageUrls': [
          'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800&q=80',
          'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=800&q=80',
          'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=800&q=80',
          'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=800&q=80',
          'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800&q=80',
          'https://images.unsplash.com/photo-1577896851231-70ef18881754?w=800&q=80',
        ],
      },
      {
        'title': 'Health Awareness',
        'date': 'Sep 20, 2025',
        'photos': 9,
        'color': Color(0xFFA855F7),
        'imageUrls': [
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800&q=80',
          'https://images.unsplash.com/photo-1584515933487-779824d29309?w=800&q=80',
          'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=800&q=80',
          'https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=800&q=80',
          'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=800&q=80',
          'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=800&q=80',
        ],
      },
    ];

    return Column(
      children: activities.map((activity) {
        return _buildActivityCard(
          title: activity['title'] as String,
          date: activity['date'] as String,
          photoCount: activity['photos'] as int,
          color: activity['color'] as Color,
          imageUrls: activity['imageUrls'] as List<String>,
        );
      }).toList(),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String date,
    required int photoCount,
    required Color color,
    required List<String> imageUrls,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/Nss_Logo.jpg",
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyBlue,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryOrange.withOpacity(
                                  0.15,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    size: 12,
                                    color: AppColors.primaryOrange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$photoCount',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryOrange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Photo Grid - EXACTLY 3 photos per row
              LayoutBuilder(
                builder: (context, constraints) {
                  final spacing = 10.0;
                  final totalSpacing = spacing * 2; // spacing between 3 items
                  final availableWidth = constraints.maxWidth;
                  final photoSize = (availableWidth - totalSpacing) / 3;

                  return Column(
                    children: [
                      // First row - 3 photos
                      Row(
                        children: List.generate(3, (index) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < 2 ? spacing : 0,
                              ),
                              child: _buildPhotoItem(
                                context,
                                title,
                                imageUrls,
                                index,
                                photoSize,
                                color,
                                photoCount,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      // Second row - 3 photos
                      Row(
                        children: List.generate(3, (index) {
                          final photoIndex = index + 3;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < 2 ? spacing : 0,
                              ),
                              child: _buildPhotoItem(
                                context,
                                title,
                                imageUrls,
                                photoIndex,
                                photoSize,
                                color,
                                photoCount,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoItem(
    BuildContext context,
    String title,
    List<String> imageUrls,
    int photoIndex,
    double photoSize,
    Color color,
    int photoCount,
  ) {
    return GestureDetector(
      onTap: () {
        _showPhotoViewer(context, title, imageUrls, photoIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Image.network(
                  imageUrls[photoIndex % imageUrls.length],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.lightGrey,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryOrange,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: color.withOpacity(0.2),
                      child: Icon(Icons.image, color: color, size: 35),
                    );
                  },
                ),
                if (photoIndex == 5 && photoCount > 6)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+${photoCount - 6}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'more',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    final streetPlays = [
      {
        'title': 'Anti-Plastic Awareness',
        'date': 'Oct 3, 2025',
        'duration': '5:32',
        'views': '1.2K',
        'color': AppColors.primaryOrange,
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800&q=80',
      },
      {
        'title': 'Save Water Campaign',
        'date': 'Sep 29, 2025',
        'duration': '4:15',
        'views': '980',
        'color': Color(0xFF06B6D4),
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80',
      },
      {
        'title': 'Women Empowerment',
        'date': 'Sep 22, 2025',
        'duration': '6:20',
        'views': '1.5K',
        'color': Color(0xFFEC4899),
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800&q=80',
      },
      {
        'title': 'Education for All',
        'date': 'Sep 15, 2025',
        'duration': '5:50',
        'views': '890',
        'color': Color(0xFFFB923C),
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800&q=80',
      },
      {
        'title': 'Drug Awareness',
        'date': 'Sep 10, 2025',
        'duration': '4:45',
        'views': '1.1K',
        'color': Color(0xFFEF4444),
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800&q=80',
      },
    ];

    return Column(
      children: streetPlays.map((video) {
        return _buildVideoCard(
          title: video['title'] as String,
          date: video['date'] as String,
          duration: video['duration'] as String,
          views: video['views'] as String,
          color: video['color'] as Color,
          videoUrl: video['videoUrl'] as String,
          thumbnailUrl: video['thumbnailUrl'] as String,
        );
      }).toList(),
    );
  }

  Widget _buildVideoCard({
    required String title,
    required String date,
    required String duration,
    required String views,
    required Color color,
    required String videoUrl,
    required String thumbnailUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => _showVideoPlayer(context, title, videoUrl),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/Nss_Logo.jpg",
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyBlue,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryOrange,
                                AppColors.primaryOrange.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryOrange.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'STREET PLAY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.network(
                        thumbnailUrl,
                        width: double.infinity,
                        height: 210,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 210,
                            color: AppColors.lightGrey,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryOrange,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 210,
                            color: color.withOpacity(0.2),
                            child: Icon(
                              Icons.video_library,
                              color: color,
                              size: 60,
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryOrange,
                                  AppColors.primaryOrange.withOpacity(0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryOrange.withOpacity(
                                    0.5,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 42,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                duration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: color),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 13,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.navyBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: AppColors.navyBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$views views',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.navyBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  void _showPhotoViewer(
    BuildContext context,
    String title,
    List<String> imageUrls,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.navyBlue, Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/Nss_Logo.jpg",
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrls[index],
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 320,
                          color: AppColors.lightGrey,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 320,
                          color: AppColors.lightGrey,
                          child: const Icon(
                            Icons.image,
                            size: 80,
                            color: AppColors.darkGrey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                      shadowColor: AppColors.primaryOrange.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoPlayer(BuildContext context, String title, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullScreenVideoPlayer(title: title, videoUrl: videoUrl),
      ),
    );
  }
}

// Full Screen Video Player Widget
class FullScreenVideoPlayer extends StatefulWidget {
  final String title;
  final String videoUrl;

  const FullScreenVideoPlayer({
    Key? key,
    required this.title,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primaryOrange,
          handleColor: AppColors.primaryOrange,
          backgroundColor: AppColors.lightGrey,
          bufferedColor: AppColors.primaryOrange.withOpacity(0.3),
        ),
        placeholder: Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryOrange),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                const Text(
                  'Error loading video',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            titleSpacing: 0,
            toolbarHeight: 80,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/Nss_Logo.jpg",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryOrange),
                  const SizedBox(height: 20),
                  const Text(
                    'Loading video...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : _errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load video',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      _initializePlayer();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              )
            : _chewieController != null
            ? Chewie(controller: _chewieController!)
            : const SizedBox(),
      ),
    );
  }
}
