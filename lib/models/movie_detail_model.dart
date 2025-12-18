class MovieDetailModel { 
  final String title;
  final String year;
  final String poster;
  final String plot;
  final String director;
  final String genre;
  final String imdbID; // Tambahkan field ini untuk navigasi rekomendasi

  const MovieDetailModel({ 
    required this.title,
    required this.year,
    required this.poster,
    required this.plot,
    required this.director,
    required this.genre,
    required this.imdbID,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      title: json['Title'] ?? 'N/A', 
      year: json['Year'] ?? 'N/A', 
      poster: json['Poster'] ?? '', 
      plot: json['Plot'] ?? 'No plot available', 
      director: json['Director'] ?? 'N/A', 
      genre: json['Genre'] ?? 'N/A',
      imdbID: json['imdbID'] ?? '', // Ambil imdbID dari respon JSON
    ); 
  }
}