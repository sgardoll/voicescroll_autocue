import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:voicescroll_autocue/globals/app_state.dart';
import 'package:voicescroll_autocue/pages/home_page.dart';

@NowaGenerated()
late final SharedPreferences sharedPrefs;

@NowaGenerated()
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

@NowaGenerated({'visibleInNowa': false})
class MyApp extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      builder: (context, child) => MaterialApp(
        theme: AppState.of(context).theme,
        initialRoute: 'HomePage',
        routes: {'HomePage': (context) => HomePage()},
      ),
    );
  }
}
