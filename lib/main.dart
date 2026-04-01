import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'providers/ev_provider.dart';
import 'providers/charger_provider.dart';
import 'providers/location_provider.dart';
import 'providers/booking_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment variables
  await dotenv.load(fileName: ".env");

  /// Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  /// Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => EVProvider()),
        ChangeNotifierProvider(create: (_) => ChargerProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const EVCommunityApp(),
    ),
  );
}

/// Global Supabase client
final supabase = Supabase.instance.client;
