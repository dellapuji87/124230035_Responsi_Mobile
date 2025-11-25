class Movie {
  final String id;
  final String title;
  final String imgUrl;
  final String releaseDate;
  final String rating;
  final String genre;
  final String director;
  final String duration;
  final String cast;
  final String language;
  final String description;
  
  

  Movie({
    required this.id, required this.title, required this.imgUrl,
    required this.releaseDate, required this.rating, required this.genre,
    required this.director, required this.duration, required this.cast,  required this.language,  required this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'],
      imgUrl: json['imgUrl'],
      releaseDate: json['release_date'],
      rating:json['rating'].toString(),
      genre: json['genre'],
      director: json['director'],
      duration:json['duration'].toString(),
      cast: json['cast'],
      language: json['language'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'imgUrl': imgUrl, 'release_date': releaseDate,
    'rating': rating, 'genre': genre, 'director': director, 'duration': duration, 'cast': cast, 'language':language, 'description': description,
  };
}