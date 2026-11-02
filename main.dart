import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Gallery',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    GalleryPage(),
    AlbumPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album_outlined),
            activeIcon: Icon(Icons.photo_album),
            label: 'Album',
          ),
        ],
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  final List<String> images = const [
    'assets/images/my image1.jpeg',
    'assets/images/myiamge2.jpeg',
    'https://picsum.photos/id/1015/600/600',
    'https://picsum.photos/id/1016/600/600',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Photo Gallery'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final isNetwork = images[index].startsWith('http');
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    images: images,
                    initialIndex: index,
                    heroPrefix: 'gallery',
                  ),
                ),
              );
            },
            child: Center(
              child: Hero(
                tag: 'gallery-image-$index',
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isNetwork
                        ? Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AlbumModel {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> images;

  const AlbumModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.images,
  });
}

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  final List<AlbumModel> albums = const [
    AlbumModel(
      name: 'My Photos',
      icon: Icons.person,
      color: Colors.blue,
      images: [
        'assets/images/my image1.jpeg',
        'assets/images/myiamge2.jpeg',
      ],
    ),
    AlbumModel(
      name: 'Favorites',
      icon: Icons.favorite,
      color: Colors.redAccent,
      images: [
        'https://picsum.photos/id/1015/600/600',
        'https://picsum.photos/id/1016/600/600',
      ],
    ),
    AlbumModel(
      name: 'Nature Album',
      icon: Icons.landscape,
      color: Colors.teal,
      images: [
        'https://picsum.photos/id/1018/600/600',
        'https://picsum.photos/id/1020/600/600',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: albums.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          final album = albums[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumDetailScreen(album: album),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: album.color.withValues(alpha: 0.15),
                      child: Icon(
                        album.icon,
                        size: 26,
                        color: album.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      album.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${album.images.length} images',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AlbumDetailScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumDetailScreen({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: album.images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final imagePath = album.images[index];
          final isNetwork = imagePath.startsWith('http');
          final heroTag = 'album-${album.name}-$index';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    images: album.images,
                    initialIndex: index,
                    heroPrefix: 'album-${album.name}',
                  ),
                ),
              );
            },
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isNetwork
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String heroPrefix;

  const DetailPage({
    super.key,
    required this.images,
    required this.initialIndex,
    this.heroPrefix = 'gallery',
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late PageController pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${currentIndex + 1} / ${widget.images.length}',
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final imagePath = widget.images[index];
          final isNetwork = imagePath.startsWith('http');
          final heroTag = '${widget.heroPrefix}-$index';

          return Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                child: isNetwork
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
