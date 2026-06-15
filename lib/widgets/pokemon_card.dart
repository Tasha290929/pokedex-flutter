import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_pokedex_app/providers/pokemon_data_providers.dart';
import 'package:riverpod_pokedex_app/widgets/pokemon_stats_cart.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;
  late FavoritePokemonsProvider _favoritePokemonsProvider;

  PokemonCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);

    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    return pokemon.when(
      data: (data) {
        return _card(context, false, data);
      },

      error: (error, stackTrace) {
        return Text("Error: $error");
      },
      loading: () {
        return _card(context, true, null);
      },
    );
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: GestureDetector(
        onTap: () {
          if(!isLoading) {
            showDialog(context: context, builder: (_) {
              return PokemonStatsCart(pokemonUrl: pokemonUrl);
            });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor,
            boxShadow: const [
              BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon?.name?.toUpperCase() ?? "Pokemon",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "#${pokemon?.id?.toString()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CircleAvatar(
                  backgroundImage: pokemon != null
                      ? NetworkImage(pokemon!.sprites!.frontDefault!)
                      : null,
                  radius: MediaQuery.sizeOf(context).height * 0.05,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${pokemon?.moves?.length} Moves",
                    style: const TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      _favoritePokemonsProvider.removeFavoritePokemons(
                        pokemonUrl,
                      );
                    },
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
