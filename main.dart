import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/movie_list_screen.dart';
import 'screens/favorite_movie_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Hive.openBox('favorite_movies');
  runApp(const MovieListApp());
}

class MovieListApp extends StatelessWidget {
  const MovieListApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('current_user');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF5F8),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFFFFF5F8),
              body: Center(child: CircularProgressIndicator(color: Colors.pink)),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const MainMovieScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
      },
    );
  }
}

class MainMovieScreen extends StatefulWidget {
  const MainMovieScreen({super.key});
  @override State<MainMovieScreen> createState() => _MainMovieScreenState();
}

class _MainMovieScreenState extends State<MainMovieScreen> {
  int _selectedIndex = 0;
  String _username = "User";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('current_user') ?? "User";
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  final List<Widget> _screens = [
    const MovieListScreen(),
    const FavoriteMoviesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Hi, $_username!" : "Favorite Movies"),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () => setState(() => _selectedIndex = 1),
            ),
        ],
      ),
      body: _screens[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 240,
              color: Colors.pink,
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: const CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage ("https://i.pinimg.com/736x/9d/a2/de/9da2debc066be3b34de24763dac28271.jpg",),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_username, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Movie Lover ♡", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.movie, color: Colors.pink),
              title: const Text("All Movies"),
              selected: _selectedIndex == 0,
              selectedTileColor: Colors.pink[100],
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text("Favorite Movies"),
              selected: _selectedIndex == 1,
              selectedTileColor: Colors.pink[100],
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => _logout(),
            ),
          ],
        ),
      ),
    );
  }
}