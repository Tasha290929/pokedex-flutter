import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_pokedex_app/pages/home_page.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_pokedex_app/services/database_service.dart';
import 'package:riverpod_pokedex_app/services/http_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupServices();
  runApp(const MyApp());
}

Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HttpService>(HttpService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PokeDex',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          // textTheme: GoogleFonts.lato(),
        ),
        home: HomePage(),
      ),
    );
  }
}
