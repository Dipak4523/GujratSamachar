import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/tts_service.dart';
import 'services/voice_command_service.dart';
import 'package:workmanager/workmanager.dart';
import 'services/news_api_service.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NewsApiService().fetchNews();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await Workmanager().registerPeriodicTask(
    'fetchNewsTask',
    'fetchNewsTask',
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(hours: 7), // 7:00 AM
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TtsService()),
        ChangeNotifierProvider(create: (_) => VoiceCommandService()),
      ],
      child: MaterialApp(
        title: 'Gujarati Samachar',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
