import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/enums/game_enums.dart';
import '../../models/game_state.dart';
import '../../models/tactics.dart';
import '../../models/user_profile.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/game_repository.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../database/database_helper.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());
final databaseProvider =
    Provider<DatabaseHelper>((ref) => DatabaseHelper.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());
final gameRepositoryProvider = Provider<GameRepository>((ref) => GameRepository());

final authStateProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = Provider<UserProfile?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier(this._repository) : super(const GameState());

  final GameRepository _repository;

  Future<void> createNewGame({
    required String clubName,
    required String country,
    required String leagueName,
    required String stadiumName,
    required int primaryColor,
    required int secondaryColor,
    String managerName = 'Manager',
  }) async {
    state = await _repository.createNewGame(
      clubName: clubName,
      country: country,
      leagueName: leagueName,
      stadiumName: stadiumName,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      managerName: managerName,
    );
  }

  Future<void> advanceWeek() async {
    state = await _repository.advanceWeek(state);
  }

  void applyTraining(TrainingType type, int intensity) {
    state = _repository.applyTraining(state, type, intensity);
  }

  void upgradeFacility(FacilityType type) {
    state = _repository.upgradeFacility(state, type);
  }

  Future<void> saveGame(String userId, {bool cloud = false}) async {
    await _repository.saveGame(state, userId, cloud: cloud);
  }

  Future<void> loadGame(String saveId) async {
    final loaded = await _repository.loadGame(saveId);
    if (loaded != null) state = loaded;
  }

  void updateTactics(Tactics tactics) {
    final updated = state.tactics.map((t) {
      return t.clubId == tactics.clubId ? tactics : t;
    }).toList();
    if (!updated.any((t) => t.clubId == tactics.clubId)) {
      updated.add(tactics);
    }
    state = state.copyWith(tactics: updated);
  }
}

final gameProvider =
    StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(ref.watch(gameRepositoryProvider));
});
