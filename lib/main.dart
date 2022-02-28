import 'package:clean_arc/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.red.shade800,
        appBarTheme: AppBarTheme(color: Colors.red.shade800),
        accentColor: Colors.red.shade600
      ),
      home: const NumberTriviaPage(),
    );
  }
}
