import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_pokedex_app/models/pokemon.dart';
import 'package:riverpod_pokedex_app/providers/pokemon_data_providers.dart';
import 'package:riverpod_pokedex_app/widgets/pokemon_stats_cart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favoritePokemons;

  PokemonListTile(this.pokemonUrl, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    return pokemon.when(
      data: (data) => _tile(context, false, data),
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
      loading: () {
        return _tile(context, true, null);
      },
    );
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (_) {
                return PokemonStatsCart(pokemonUrl: pokemonUrl);
              },
            );
          }
        },
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
                )
              : CircleAvatar(),
          title: Text(
            pokemon != null
                ? pokemon.name!.toUpperCase()
                : "Currently loading name for Pokemon",
          ),

          subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),

          trailing: IconButton(
            onPressed: () {
              if (_favoritePokemons.contains(pokemonUrl)) {
                _favoritePokemonsProvider.removeFavoritePokemons(pokemonUrl);
              } else {
                _favoritePokemonsProvider.addFavoritePokemons(pokemonUrl);
              }
            },
            icon: Icon(
              _favoritePokemons.contains(pokemonUrl)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
