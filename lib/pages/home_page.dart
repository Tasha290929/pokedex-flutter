import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_pokedex_app/controllers/home_page_controller.dart';
import 'package:riverpod_pokedex_app/models/page_data.dart';
import 'package:riverpod_pokedex_app/providers/pokemon_data_providers.dart';
import 'package:riverpod_pokedex_app/widgets/pokemon_card.dart';
import 'package:riverpod_pokedex_app/widgets/pokemon_list_tile.dart';

import '../models/pokemon.dart';

final homePageControllerProvider =
NotifierProvider<HomePageController, HomePageData>(() {
  return HomePageController();
});

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonScrollController = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favoritePokemons;

  @override
  void initState() {
    super.initState();
    _allPokemonScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokemonScrollController.removeListener(_scrollListener);
    _allPokemonScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonScrollController.offset >=
        _allPokemonScrollController.position.maxScrollExtent) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);

    _homePageData = ref.watch(homePageControllerProvider);

    _favoritePokemons = ref.watch(favoritePokemonsProvider);

    return Scaffold(body: _buildUI(context));
  }

  Widget? _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery
              .sizeOf(context)
              .width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery
                .sizeOf(context)
                .width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favoritePokemonsList(
                  context
              ),
              _allPokemonsList(context)],
          ),
        ),
      ),
    );
  }

  Widget _favoritePokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .sizeOf(context)
          .width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favorites",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery
                .sizeOf(context)
                .height * 0.50,
            width: MediaQuery
                .sizeOf(context)
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favoritePokemons.isNotEmpty) SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.48,
                  child:
                  GridView.builder(
                    scrollDirection: Axis.horizontal,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: _favoritePokemons.length,
                      itemBuilder: (context, index) {
                        String pokemonUrl = _favoritePokemons[index];
                    return PokemonCard(pokemonUrl: pokemonUrl);
                  }),
                ),
                if (_favoritePokemons.isEmpty) const Text(
                    "No favorite Pokemons"),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .sizeOf(context)
          .width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All Pokemons', style: TextStyle(fontSize: 25)),
          SizedBox(
            height: MediaQuery
                .sizeOf(context)
                .height * 0.60,
            child: ListView.builder(
              controller: _allPokemonScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemon.url ?? '');
              },
            ),
          ),
        ],
      ),
    );
  }
}
