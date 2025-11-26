import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/calculator_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/history_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/theme_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/settings_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/screens/calculator_screen.dart';
import 'package:flutter_caculator_nguyennamphuong/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => StorageService()), // Cung cấp StorageService
        ChangeNotifierProxyProvider<StorageService, SettingsProvider>(
          create: (context) => SettingsProvider(context.read<StorageService>()),
          update: (context, storage, previous) => SettingsProvider(storage),
        ),
        ChangeNotifierProvider(create: (context) => CalculatorProvider()),
        ChangeNotifierProxyProvider2<
          CalculatorProvider,
          StorageService,
          HistoryProvider
        >(
          create: (context) => HistoryProvider(
            context.read<CalculatorProvider>(),
            context.read<StorageService>(),
          ),
          update: (context, calculator, storage, previousHistory) {
            //Khi CalculatorProvider hoặc StorageService thay đổi, tạo lại HistoryProvider
            final history = HistoryProvider(calculator, storage);
            //Thiết lập callback để CalculatorProvider có thể gọi HistoryProvider
            calculator.onCalculationComplete = history.addHistory;
            //Thiết lập các provider phụ thuộc khác nếu cần
            calculator.setSettingsProvider(context.read<SettingsProvider>());
            return history;
          },
        ),
      ],
      child: const CalculatorApp(),
    ),
  );
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    //Lắng nghe ThemeProvider để cập nhật theme cho MaterialApp
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Calculator',
          themeMode: themeProvider.themeMode,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          debugShowCheckedModeBanner: false,
          home: const CalculatorScreen(),
        );
      },
    );
  }
}
