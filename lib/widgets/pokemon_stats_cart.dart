import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_pokedex_app/providers/pokemon_data_providers.dart';

class PokemonStatsCart extends ConsumerWidget {
  final String pokemonUrl;

  PokemonStatsCart({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    return AlertDialog(
      title: const Text("Statistics"),
      content: pokemon.when(
        data: (data) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children:
                data?.stats?.map((s) {
                  return Text("${s.stat?.name?.toUpperCase()}: ${s.baseStat}");
                }).toList() ??
                [],
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
        loading: () {
          return const CircularProgressIndicator(color: Colors.white);
        },
      ),
    );
  }
}
