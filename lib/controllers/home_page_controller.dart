import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_pokedex_app/models/page_data.dart';
import 'package:riverpod_pokedex_app/models/pokemon.dart';
import 'package:riverpod_pokedex_app/services/http_service.dart';

class HomePageController extends Notifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;

  late HttpService _httpService;
  bool _isLoading = false;

  @override
  HomePageData build() {
    _httpService = _getIt.get<HttpService>();
    Future.microtask(() => loadData());
    return HomePageData.initial();
  }

  Future<void> loadData() async {
    if (_isLoading) return;
    _isLoading = true;
    if (state.data == null) {
      Response? res = await _httpService.get(
        "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0",
      );
      if (res != null && res.data != null) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(data: data);
        print(state.data?.results?.first);
      }
    } else {
      if (state.data?.next != null) {
        Response? res = await _httpService.get(state.data!.next!);

        if (res != null && res.data != null) {
          PokemonListData data = PokemonListData.fromJson(res.data!);

          state = state.copyWith(
            data: data.copyWith(
              results: [...?state.data?.results, ...?data.results],
            ),
          );
        }
      }
    }
    _isLoading = false;
  }
}
