import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_models.dart';

class ApiService {
  static const baseUrl = "https://681388b3129f6313e2119693.mockapi.io/api/v1/movie";

  static Future<List<Movie>> getMovies() async {
    final res = await http.get(Uri.parse(baseUrl));
    final data = json.decode(res.body) as List;
    return data.map((e) => Movie.fromJson(e)).toList();
  }
}

