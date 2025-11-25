import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../models/movie_models.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override 
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder<List<Movie>>(
            future: ApiService.getMovies(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final genres = snapshot.data!.map((m) => m.genre).toSet().toList();
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text("All"),
                      selected: _selectedGenre == null,
                      onSelected: (_) => setState(() => _selectedGenre = null),
                      backgroundColor: Colors.pink[50],
                      selectedColor: Colors.pink,
                      labelStyle: TextStyle(color: _selectedGenre == null ? Colors.white : Colors.pink),
                    ),
                    const SizedBox(width: 8),
                    ...genres.map((g) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(g),
                        selected: _selectedGenre == g,
                        onSelected: (_) => setState(() => _selectedGenre = g),
                        backgroundColor: Colors.pink[50],
                        selectedColor: Colors.pink,
                        labelStyle: TextStyle(color: _selectedGenre == g ? Colors.white : Colors.pink),
                      ),
                    )),
                  ],
                ),
              );
            },
          ),
        ),

        Expanded(
          child: FutureBuilder<List<Movie>>(
            future: ApiService.getMovies(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: Colors.pink));
              }
              var movies = snapshot.data!;
              if (_selectedGenre != null) {
                movies = movies.where((m) => m.genre == _selectedGenre).toList();
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: movies.length,
                itemBuilder: (context, i) {
                  final movie = movies[i];
                  return MovieCard(movie: movie);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('favorite_movies').listenable(),
      builder: (context, box, _) {
        final isFav = box.containsKey(movie.id);
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(movie.imgUrl, fit: BoxFit.cover))),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(movie.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    Text("★ ${movie.rating} | ${movie.genre}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Positioned(
                  top: 8, right: 8,
                  child: IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
                    onPressed: () {
                      if (isFav) {
                        box.delete(movie.id);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dihapus dari favorit"), backgroundColor: Colors.red));
                      } else {
                        box.put(movie.id, movie.toJson());
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ditambahkan ke favorit ♡"), backgroundColor: Colors.green));
                      }
                    },
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

