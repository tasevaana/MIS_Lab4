import 'package:flutter/material.dart';
import 'package:lab2/providers/favorite_joke_provider.dart';
import 'package:provider/provider.dart';
import '../models/joke_model.dart';

class JokeListTile extends StatelessWidget {
  final Joke joke;

  const JokeListTile({required this.joke});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final isFavorite = favoritesProvider.isFavorite(joke);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Text(
            joke.setup,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(joke.punchline),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              favoritesProvider.toggleFavorite(joke);
              final message = isFavorite
                  ? 'Removed from favorites'
                  : 'Added to favorites';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          ),
        ),
      ),
    );
  }
}
