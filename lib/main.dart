import 'package:flutter/material.dart';
import 'screens/calendario_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('es_ES', null).then((_) => runApp(const MiAppPostIt()));
}

class MiAppPostIt extends StatelessWidget {
  const MiAppPostIt({super.key});

  @override
  Widget build(BuildContext contex) {
    return MaterialApp(
      localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      locale: const Locale('es', 'ES'),
      title: 'PinIt - Mis Post-its',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
        ),
      ),
      home: const CalendarioScreen(),
    );
  }
}