import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/models/angle_mode.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/history_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/settings_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, SettingsProvider, HistoryProvider>(
      builder:
          (context, themeProvider, settingsProvider, historyProvider, child) {
            final settings = settingsProvider.settings;

            return Scaffold(
              appBar: AppBar(title: const Text('Settings')),
              body: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  //Cài đặt Chủ đề
                  ListTile(
                    title: const Text('Theme'),
                    trailing: DropdownButton<ThemeMode>(
                      value: themeProvider.themeMode,
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Dark'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('System'),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode != null) {
                          themeProvider.setTheme(mode);
                        }
                      },
                    ),
                  ),
                  const Divider(),

                  //Cài đặt Máy tính
                  ListTile(
                    title: const Text('Decimal Precision'),
                    trailing: DropdownButton<int>(
                      value: settings.decimalPrecision,
                      items: List.generate(9, (index) => index + 2)
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text('$p places'),
                            ),
                          )
                          .toList(),
                      onChanged: (precision) {
                        if (precision != null) {
                          settingsProvider.setDecimalPrecision(precision);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Angle Mode'),
                    trailing: DropdownButton<AngleMode>(
                      value: settings.angleMode,
                      items: const [
                        DropdownMenuItem(
                          value: AngleMode.degrees,
                          child: Text('Degrees'),
                        ),
                        DropdownMenuItem(
                          value: AngleMode.radians,
                          child: Text('Radians'),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode != null) {
                          settingsProvider.setAngleMode(mode);
                        }
                      },
                    ),
                  ),
                  const Divider(),

                  // Cài đặt Phản hồi
                  SwitchListTile(
                    title: const Text('Haptic Feedback'),
                    value: settings.hapticFeedbackEnabled,
                    onChanged: (isEnabled) {
                      settingsProvider.setHapticFeedback(isEnabled);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Sound Effects'),
                    value: settings.soundEffectsEnabled,
                    onChanged: (isEnabled) {
                      settingsProvider.setSoundEffects(isEnabled);
                    },
                  ),
                  const Divider(),
                  //Cài đặt Lịch sử
                  ListTile(
                    title: const Text('History Size'),
                    trailing: DropdownButton<int>(
                      value: settings.historySize,
                      items: const [
                        DropdownMenuItem(value: 25, child: Text('25 items')),
                        DropdownMenuItem(value: 50, child: Text('50 items')),
                        DropdownMenuItem(value: 100, child: Text('100 items')),
                      ],
                      onChanged: (size) {
                        if (size != null) {
                          settingsProvider.setHistorySize(size);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        _showClearHistoryDialog(context, historyProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    child: const Text('Clear All History'),
                  ),
                ],
              ),
            );
          },
    );
  }

  ///Hiển thị hộp thoại xác nhận trước khi xóa lịch sử.
  void _showClearHistoryDialog(
    BuildContext context,
    HistoryProvider historyProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text(
            'Are you sure you want to clear all calculation history? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); //Đóng hộp thoại
              },
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                historyProvider.clearAllHistory();
                Navigator.of(dialogContext).pop(); //Đóng hộp thoại

                //Hiển thị SnackBar thông báo thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('History cleared successfully.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
