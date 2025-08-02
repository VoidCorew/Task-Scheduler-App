import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_scheduler/providers/buttons_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    final buttonsProvider = context.watch<ButtonsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки',
          style: TextStyle(fontFamily: 'Monsterrat'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Основные',
            style: TextStyle(fontFamily: 'Monsterrat', fontSize: 20),
          ),
          ListTile(
            trailing: Switch(
              value: !buttonsProvider.showButtons,
              onChanged: (bool value) {
                setState(() {
                  buttonsProvider.toggleButtons(value);
                });
              },
            ),
            title: const Text(
              'Кнопки',
              style: TextStyle(fontFamily: 'Monsterrat'),
            ),
            subtitle: const Text(
              'Убрать кнопки',
              style: TextStyle(fontFamily: 'Monsterrat'),
            ),
          ),

          const Divider(),

          // const SizedBox(height: 20),
          // const Text(
          //   'Карточки',
          //   style: TextStyle(fontFamily: 'Monsterrat', fontSize: 20),
          // ),
        ],
      ),
    );
  }
}
