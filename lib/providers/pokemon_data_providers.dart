import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_pokedex_app/models/pokemon.dart';
import 'package:riverpod_pokedex_app/services/database_service.dart';
import 'package:riverpod_pokedex_app/services/http_service.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>((
  ref,
  url,
) async {
  HttpService _httpService = GetIt.instance.get<HttpService>();
  Response<dynamic>? res = await _httpService.get(url);

  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data!);
  }

  return null;
});

final favoritePokemonsProvider =
    NotifierProvider<FavoritePokemonsProvider, List<String>>(() {
      return FavoritePokemonsProvider();
    });

String FAVORIT_POKEMON_LIST_KEY = "FAVORIT_POKEMON_LIST_KEY";

class FavoritePokemonsProvider extends Notifier<List<String>> {
  final DatabaseService _databaseService = GetIt.instance
      .get<DatabaseService>();

  @override
  List<String> build() {
    Future.microtask(() => _setup());
    return [];
  }

  Future<void> _setup() async {
    List<String>? result = await _databaseService.getList(
      FAVORIT_POKEMON_LIST_KEY,
    );
    state = result ?? [];
  }

  void addFavoritePokemons(String url) {
    state = [...state, url];

    _databaseService.saveList(FAVORIT_POKEMON_LIST_KEY, state);
  }

  void removeFavoritePokemons(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVORIT_POKEMON_LIST_KEY, state);
  }
}
