import 'package:flutter/material.dart';

void main() {
  runApp(const MovieReviewApp());
}

class MovieReviewApp extends StatelessWidget {
  const MovieReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Reviews',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MovieListPage(),
    );
  }
}

class Movie {
  final String title;
  final String description;
  final double rating;
  final String imageUrl;

  Movie({
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
  });
}

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  final List<Movie> movies = const [
    Movie(
      title: 'Inception',
      description: 'A thief with the ability to enter people\'s dreams and steal their secrets.',
      rating: 8.8,
      imageUrl: 'https://via.placeholder.com/150x220.png?text=Inception',
    ),
    Movie(
      title: 'Interstellar',
      description: 'A group of explorers travel through a wormhole in space to ensure humanity\'s survival.',
      rating: 8.6,
      imageUrl: 'https://via.placeholder.com/150x220.png?text=Interstellar',
    ),
    Movie(
      title: 'The Dark Knight',
      description: 'Batman faces the Joker, a criminal mastermind who plunges Gotham into chaos.',
      rating: 9.0,
      imageUrl: 'https://via.placeholder.com/150x220.png?text=Dark+Knight',
    ),
  ];

  void _navigateToDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Reviews')),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (_, index) {
          final movie = movies[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(movie.imageUrl, width: 70, fit: BoxFit.cover),
              title: Text(movie.title),
              subtitle: Text("Rating: ${movie.rating}"),
              onTap: () => _navigateToDetail(context, movie),
            ),
          );
        },
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(movie.imageUrl, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              movie.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Rating: ${movie.rating}",
              style: const TextStyle(fontSize: 20, color: Colors.amber),
            ),
            const SizedBox(height: 20),
            Text(
              movie.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
