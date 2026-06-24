import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/random_utils.dart';
import '../../core/database/database_helper.dart';
import '../../models/board_objective.dart';
import '../../models/club.dart';
import '../../models/enums/game_enums.dart';
import '../../models/facility.dart';
import '../../models/financial_record.dart';
import '../../models/game_state.dart';
import '../../models/game_state_models.dart';
import '../../models/league.dart';
import '../../models/player.dart';
import '../../models/tactics.dart';
import 'ai_club_service.dart';
import 'finance_service.dart';
import 'league_engine_service.dart';
import 'player_generator_service.dart';
import 'training_service.dart';
import 'world_generator_service.dart';

class GameService {
  GameService({
    DatabaseHelper? database,
  }) : _database = database ?? DatabaseHelper.instance;

  final DatabaseHelper _database;
  static const _uuid = Uuid();

  Future<GameState> createNewGame({
    required String clubName,
    required String country,
    required String leagueName,
    required String stadiumName,
    required int primaryColor,
    required int secondaryColor,
    String managerName = 'Manager',
  }) async {
    final world = WorldGeneratorService.instance.generateWorld(
      country: country,
      leagueName: leagueName,
    );

    final userClub = WorldGeneratorService.instance.generateClub(
      country: country,
      league: leagueName,
      name: clubName,
      stadiumName: stadiumName,
      primaryColor: Color(primaryColor),
      secondaryColor: Color(secondaryColor),
      isUserClub: true,
      reputation: 55,
    );

    final league = world.leagues.first;
    final aiClubIds = league.clubIds.take(19).toList();
    final aiClubs = world.clubs.take(19).toList();
    final updatedLeague = league.copyWith(
      clubIds: [userClub.id, ...aiClubIds],
    );

    final userPlayers = PlayerGeneratorService.instance.generateSquad(
      userClub.id,
      count: AppConstants.playersPerClub,
    );

    final allClubs = [userClub, ...aiClubs];
    final allPlayers = [...userPlayers, ...world.players.take(19 * 25)];

    final standings = LeagueEngineService.instance.createStandings(
      updatedLeague,
      1,
    );

    final fixtures = LeagueEngineService.instance.generateFixtures(
      league: updatedLeague,
      season: 1,
    );

    final tactics = allClubs
        .map((c) => Tactics(
              clubId: c.id,
              startingXi: allPlayers
                  .where((p) => p.clubId == c.id)
                  .take(11)
                  .map((p) => p.id)
                  .toList(),
            ))
        .toList();

    final objectives = BoardService.instance.generateObjectives(userClub.id, 1);
    final achievements = AchievementService.defaultAchievements();

    return GameState(
      userClubId: userClub.id,
      season: 1,
      week: 1,
      clubs: allClubs,
      players: allPlayers,
      leagues: [updatedLeague],
      standings: standings,
      matches: fixtures,
      tactics: tactics,
      objectives: objectives,
      achievements: achievements,
      isInitialized: true,
      managerName: managerName,
    );
  }

  Future<GameState> advanceWeek(GameState state) async {
    if (state.userClubId == null) return state;

    var matches = LeagueEngineService.instance.simulateMatchweek(
      matches: state.matches,
      week: state.week,
      clubs: state.clubs,
      players: state.players,
      tactics: state.tactics,
    );

    var standings = state.standings;
    for (final match in matches.where((m) => m.week == state.week && m.isPlayed)) {
      standings = LeagueEngineService.instance.updateStandings(
        standings: standings,
        match: match,
      );
    }

    var players = state.players.map((p) {
      return p.copyWith(
        fitness: (p.fitness - 3).clamp(50, 100),
        form: (p.form + (RandomUtils.nextDouble(-2, 3))).clamp(30, 99),
      );
    }).toList();

    var clubs = state.clubs;
    final finances = List<FinancialRecord>.from(state.finances);

    for (final club in clubs) {
      final squad = players.where((p) => p.clubId == club.id).toList();
      final salaries = FinanceService.instance.calculateTotalSalaries(
        squad.map((p) => p.salary).toList(),
      );
      final hasHomeMatch = matches.any(
        (m) => m.week == state.week && m.homeClubId == club.id && m.isPlayed,
      );
      final record = FinanceService.instance.generateWeeklyRecord(
        club: club,
        season: state.season,
        week: state.week,
        totalSalaries: salaries,
        isHomeMatch: hasHomeMatch,
      );
      finances.add(record);
      final index = clubs.indexWhere((c) => c.id == club.id);
      clubs[index] = FinanceService.instance.applyFinancials(club, record);
    }

    var newWeek = state.week + 1;
    var newSeason = state.season;
    var yearsManaged = state.yearsManaged;
    var positionHistory = List<int>.from(state.positionHistory);

    if (newWeek > AppConstants.weeksPerSeason) {
      newWeek = 1;
      newSeason++;
      yearsManaged++;

      final league = state.userLeague;
      if (league != null && state.userClubId != null) {
        final position = LeagueEngineService.instance.getPosition(
          standings.where((s) => s.leagueId == league.id).toList(),
          state.userClubId!,
        );
        positionHistory.add(position);

        // Youth intake
        final youth = PlayerGeneratorService.instance.generateYouthIntake(
          state.userClubId!,
        );
        players = [...players, ...youth];
      }
    }

    var achievements = AchievementService.instance.checkAchievements(
      state: state,
      current: state.achievements,
    );

    final userClub = clubs.firstWhere((c) => c.id == state.userClubId);
    final league = state.userLeague;
    if (league != null) {
      final position = LeagueEngineService.instance.getPosition(
        standings.where((s) => s.leagueId == league.id).toList(),
        state.userClubId!,
      );
      final confidence = BoardService.instance.updateBoardConfidence(
        club: userClub,
        objectives: state.objectives,
        leaguePosition: position,
        totalTeams: league.clubIds.length,
      );
      final clubIndex = clubs.indexWhere((c) => c.id == state.userClubId);
      clubs[clubIndex] = userClub.copyWith(boardConfidence: confidence);
    }

    return state.copyWith(
      week: newWeek,
      season: newSeason,
      matches: matches,
      standings: standings,
      players: players,
      clubs: clubs,
      finances: finances,
      achievements: achievements,
      yearsManaged: yearsManaged,
      positionHistory: positionHistory,
    );
  }

  GameState applyTraining(
    GameState state,
    TrainingType type,
    int intensity,
  ) {
    if (state.userClubId == null) return state;

    final squad = state.playersForClub(state.userClubId!);
    final trained = TrainingService.instance.applyTraining(
      players: squad,
      type: type,
      intensity: intensity,
    );

    final otherPlayers = state.players
        .where((p) => p.clubId != state.userClubId)
        .toList();

    return state.copyWith(players: [...otherPlayers, ...trained]);
  }

  GameState upgradeFacility(GameState state, FacilityType type) {
    if (state.userClubId == null) return state;

    final club = state.userClub!;
    final facility = Facility(clubId: club.id, type: type);

    if (club.budget < facility.upgradeCost) return state;

    final updatedClub = club.copyWith(
      budget: club.budget - facility.upgradeCost,
      stadiumCapacity: type == FacilityType.stadium
          ? club.stadiumCapacity + 5000
          : club.stadiumCapacity,
      reputation: club.reputation + 1,
    );

    final clubs = state.clubs.map((c) {
      return c.id == club.id ? updatedClub : c;
    }).toList();

    return state.copyWith(clubs: clubs);
  }

  Future<void> saveGame(GameState state, String userId, {bool cloud = false}) async {
    final saveId = _uuid.v4();
    final club = state.userClub;

    await _database.saveGame(
      id: saveId,
      userId: userId,
      saveName: '${club?.name ?? 'Save'} - S${state.season}W${state.week}',
      gameData: state.toMap(),
      isCloud: cloud,
      clubName: club?.name,
      season: state.season,
      week: state.week,
    );
  }

  Future<GameState?> loadGame(String saveId) async {
    final data = await _database.loadGame(saveId);
    if (data == null) return null;
    return GameState.fromMap(data);
  }
}
