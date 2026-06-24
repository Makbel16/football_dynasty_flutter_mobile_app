import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/formation_positions.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/enums/game_enums.dart';
import '../../../models/tactics.dart';
import '../../../widgets/section_header.dart';

class TacticsScreen extends ConsumerStatefulWidget {
  const TacticsScreen({super.key});

  @override
  ConsumerState<TacticsScreen> createState() => _TacticsScreenState();
}

class _TacticsScreenState extends ConsumerState<TacticsScreen> {
  late Tactics _tactics;

  @override
  void initState() {
    super.initState();
    final game = ref.read(gameProvider);
    _tactics = game.tacticsForClub(game.userClubId ?? '') ??
        Tactics(clubId: game.userClubId ?? '');
  }

  void _save() {
    ref.read(gameProvider.notifier).updateTactics(_tactics);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tactics saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider);
    final squad = game.userClubId != null
        ? game.playersForClub(game.userClubId!)
        : <dynamic>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tactics'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Formation'),
            Wrap(
              spacing: 8,
              children: FormationPositions.availableFormations.map((f) {
                return ChoiceChip(
                  label: Text(f),
                  selected: _tactics.formation == f,
                  onSelected: (_) => setState(() => _tactics = _tactics.copyWith(formation: f)),
                  selectedColor: AppTheme.accentGold.withValues(alpha: 0.3),
                );
              }).toList(),
            ),

            // Pitch visualization
            const SizedBox(height: 16),
            Card(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.pitchGreen.withValues(alpha: 0.8),
                      AppTheme.pitchGreen,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    _tactics.formation,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),

            const SectionHeader(title: 'Attacking Style'),
            _EnumSelector<AttackingStyle>(
              value: _tactics.attackingStyle,
              values: AttackingStyle.values,
              label: (v) => v.name,
              onChanged: (v) => setState(() => _tactics = _tactics.copyWith(attackingStyle: v)),
            ),

            const SectionHeader(title: 'Defensive Style'),
            _EnumSelector<DefensiveStyle>(
              value: _tactics.defensiveStyle,
              values: DefensiveStyle.values,
              label: (v) => v.name,
              onChanged: (v) => setState(() => _tactics = _tactics.copyWith(defensiveStyle: v)),
            ),

            const SectionHeader(title: 'Pressing'),
            _EnumSelector<PressingIntensity>(
              value: _tactics.pressing,
              values: PressingIntensity.values,
              label: (v) => v.name,
              onChanged: (v) => setState(() => _tactics = _tactics.copyWith(pressing: v)),
            ),

            const SectionHeader(title: 'Sliders'),
            _SliderRow(
              label: 'Possession',
              value: _tactics.possession.toDouble(),
              onChanged: (v) => setState(() => _tactics = _tactics.copyWith(possession: v.round())),
            ),
            _SliderRow(
              label: 'Counter Attack',
              value: _tactics.counterAttack.toDouble(),
              onChanged: (v) => setState(() => _tactics = _tactics.copyWith(counterAttack: v.round())),
            ),
            _SliderRow(
              label: 'Width',
              value: _tactics.width.toDouble(),
              onChanged: (v) => setState(() => _tactics = _tactics.copyWith(width: v.round())),
            ),
            _SliderRow(
              label: 'Tempo',
              value: _tactics.tempo.toDouble(),
              onChanged: (v) => setState(() => _tactics = _tactics.copyWith(tempo: v.round())),
            ),

            const SectionHeader(title: 'Starting XI'),
            ...squad.take(11).map((player) => CheckboxListTile(
                  title: Text(player.name),
                  subtitle: Text('${player.position.code} • ${player.overall} OVR'),
                  value: _tactics.startingXi.contains(player.id),
                  onChanged: (selected) {
                    setState(() {
                      final xi = List<String>.from(_tactics.startingXi);
                      if (selected == true && xi.length < 11) {
                        xi.add(player.id);
                      } else {
                        xi.remove(player.id);
                      }
                      _tactics = _tactics.copyWith(startingXi: xi);
                    });
                  },
                )),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _EnumSelector<T> extends StatelessWidget {
  const _EnumSelector({
    required this.value,
    required this.values,
    required this.label,
    required this.onChanged,
  });

  final T value;
  final List<T> values;
  final String Function(T) label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: values.map((v) {
        return ChoiceChip(
          label: Text(label(v)),
          selected: value == v,
          onSelected: (_) => onChanged(v),
          selectedColor: AppTheme.accentGold.withValues(alpha: 0.3),
        );
      }).toList(),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              activeColor: AppTheme.accentGold,
              onChanged: onChanged,
            ),
          ),
          Text('${value.round()}'),
        ],
      ),
    );
  }
}
