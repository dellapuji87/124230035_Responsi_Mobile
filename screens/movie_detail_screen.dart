import 'package:flutter/material.dart';
import '../models/movie_models.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Film")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(movie.imgUrl, height: 300, fit: BoxFit.cover))),
            const SizedBox(height: 20),
            Text(movie.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pink)),
            const SizedBox(height: 12),
            Row(children: [const Icon(Icons.star, color: Colors.amber), Text(" ${movie.rating} / 10", style: const TextStyle(fontSize: 18))]),
            Text("Genre: ${movie.genre}", style: const TextStyle(fontSize: 16)),
            Text("Rilis: ${movie.releaseDate}", style: const TextStyle(fontSize: 16)),
            Text("Sutradara: ${movie.director}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}