import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class ClubCreationScreen extends ConsumerStatefulWidget {
  const ClubCreationScreen({super.key});

  @override
  ConsumerState<ClubCreationScreen> createState() => _ClubCreationScreenState();
}

class _ClubCreationScreenState extends ConsumerState<ClubCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clubNameController = TextEditingController();
  final _stadiumController = TextEditingController();
  final _managerController = TextEditingController(text: 'Manager');

  String _selectedCountry = AppConstants.countries.first;
  String _selectedLeague = AppConstants.leaguesByCountry['England']!.first;
  Color _primaryColor = AppTheme.accentGold;
  Color _secondaryColor = AppTheme.accentBlue;
  bool _isLoading = false;

  @override
  void dispose() {
    _clubNameController.dispose();
    _stadiumController.dispose();
    _managerController.dispose();
    super.dispose();
  }

  Future<void> _createClub() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ref.read(gameProvider.notifier).createNewGame(
            clubName: _clubNameController.text.trim(),
            country: _selectedCountry,
            leagueName: _selectedLeague,
            stadiumName: _stadiumController.text.trim(),
            primaryColor: _primaryColor.toARGB32(),
            secondaryColor: _secondaryColor.toARGB32(),
            managerName: _managerController.text.trim(),
          );

      final user = ref.read(currentUserProvider);
      if (user != null) {
        await ref.read(gameProvider.notifier).saveGame(user.id);
      }

      if (mounted) context.go(AppRouter.dashboard);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create club: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final leagues = AppConstants.leaguesByCountry[_selectedCountry] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Create Your Club')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentGold))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: _primaryColor,
                              child: Icon(Icons.shield, size: 40, color: _secondaryColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _clubNameController.text.isEmpty
                                  ? 'Your Club'
                                  : _clubNameController.text,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _clubNameController,
                      decoration: const InputDecoration(
                        labelText: 'Club Name',
                        prefixIcon: Icon(Icons.shield_outlined),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter club name' : null,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stadiumController,
                      decoration: const InputDecoration(
                        labelText: 'Stadium Name',
                        prefixIcon: Icon(Icons.stadium_outlined),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter stadium name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _managerController,
                      decoration: const InputDecoration(
                        labelText: 'Manager Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      items: AppConstants.countries
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            _selectedCountry = v;
                            _selectedLeague =
                                AppConstants.leaguesByCountry[v]!.first;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedLeague,
                      decoration: const InputDecoration(
                        labelText: 'League',
                        prefixIcon: Icon(Icons.emoji_events_outlined),
                      ),
                      items: leagues
                          .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedLeague = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ColorPicker(
                            label: 'Primary Color',
                            color: _primaryColor,
                            onChanged: (c) => setState(() => _primaryColor = c),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ColorPicker(
                            label: 'Secondary Color',
                            color: _secondaryColor,
                            onChanged: (c) => setState(() => _secondaryColor = c),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _createClub,
                      child: const Text('Start Your Dynasty'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.label,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;

  static const _colors = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFFB300),
    Color(0xFF8E24AA),
    Color(0xFFFFD700),
    Color(0xFF00ACC1),
    Color(0xFF6D4C41),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _colors.map((c) {
            return GestureDetector(
              onTap: () => onChanged(c),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: color == c
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
