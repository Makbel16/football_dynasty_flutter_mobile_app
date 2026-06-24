import '../models/enums/game_enums.dart';
import '../models/game_state.dart';
import '../services/game_service.dart';
import '../core/database/database_helper.dart';
import '../services/firestore_service.dart';

class GameRepository {
  GameRepository({
    GameService? gameService,
    DatabaseHelper? database,
    FirestoreService? firestore,
  })  : _gameService = gameService ?? GameService(),
        _database = database ?? DatabaseHelper.instance,
        _firestore = firestore ?? FirestoreService();

  final GameService _gameService;
  final DatabaseHelper _database;
  final FirestoreService _firestore;

  Future<GameState> createNewGame({
    required String clubName,
    required String country,
    required String leagueName,
    required String stadiumName,
    required int primaryColor,
    required int secondaryColor,
    String managerName = 'Manager',
  }) =>
      _gameService.createNewGame(
        clubName: clubName,
        country: country,
        leagueName: leagueName,
        stadiumName: stadiumName,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        managerName: managerName,
      );

  Future<GameState> advanceWeek(GameState state) => _gameService.advanceWeek(state);

  GameState applyTraining(GameState state, TrainingType type, int intensity) =>
      _gameService.applyTraining(state, type, intensity);

  GameState upgradeFacility(GameState state, FacilityType type) =>
      _gameService.upgradeFacility(state, type);

  Future<void> saveGame(GameState state, String userId, {bool cloud = false}) async {
    await _gameService.saveGame(state, userId, cloud: cloud);
    if (cloud) {
      await _firestore.saveGameToCloud(
        userId: userId,
        saveId: DateTime.now().millisecondsSinceEpoch.toString(),
        gameData: state.toMap(),
        saveName: '${state.userClub?.name ?? 'Save'} S${state.season}',
      );
    }
  }

  Future<GameState?> loadGame(String saveId) => _gameService.loadGame(saveId);

  Future<List<Map<String, dynamic>>> getSaves(String userId) =>
      _database.getSavesForUser(userId);
}
