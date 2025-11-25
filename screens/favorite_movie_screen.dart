import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie_models.dart';
import 'movie_detail_screen.dart';

class FavoriteMoviesScreen extends StatelessWidget {
  const FavoriteMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('favorite_movies').listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 100, color: Colors.pink.withOpacity(0.6)),
                const SizedBox(height: 20),
                const Text("Belum ada film favorit ♡", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const Text("Tekan hati pada film untuk menambahkannya", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        final favorites = box.values.map((e) => Movie.fromJson(Map<String, dynamic>.from(e))).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, i) {
            final movie = favorites[i];
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(movie.imgUrl, fit: BoxFit.cover))),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(movie.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    Text("★ ${movie.rating} | ${movie.genre}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}