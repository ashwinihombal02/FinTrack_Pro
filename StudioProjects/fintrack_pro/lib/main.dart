import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'data/db/app_database.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'domain/usecases/delete_transaction.dart';
import 'domain/usecases/update_transaction.dart';
import 'presentation/dashboard/dashboard_screen.dart';
import 'l10n/language_provider.dart';

void main() {
  runApp(const ProviderScope(child: FinTrackApp()));
}

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚠️ NOTE: ideally move DB to provider later
    final db = AppDatabase();
    final repository = TransactionRepositoryImpl(db);

    final deleteTransaction = DeleteTransaction(repository);
    final updateTransaction = UpdateTransaction(repository);

    return Consumer(
      builder: (context, ref, _) {
        final themeMode = ref.watch(themeProvider);
        final locale = ref.watch(localeProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FinTrack Pro',

          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,

          // 🌍 THIS IS THE KEY FIX
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('kn'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: DashboardScreen(
            deleteTransaction: deleteTransaction,
            updateTransaction: updateTransaction,
          ),
        );
      },
    );
  }
}