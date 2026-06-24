class AppConstants {
  AppConstants._();

  static const String appName = 'Football Dynasty';
  static const String appSubtitle = 'Road to Glory';

  static const int playersPerClub = 25;
  static const int youthSquadSize = 12;
  static const int seasonsPerYear = 1;
  static const int weeksPerSeason = 38;
  static const int transferWindowsOpenWeeks = 4;

  static const int promotionSpots = 3;
  static const int relegationSpots = 3;

  static const double homeAdvantageBonus = 0.08;
  static const double maxMorale = 100.0;
  static const double maxFitness = 100.0;

  static const String defaultCurrency = '€';
  static const int autoSaveIntervalMinutes = 5;

  static const List<String> countries = [
    'England',
    'Spain',
    'Germany',
    'Italy',
    'France',
    'Portugal',
    'Netherlands',
    'Brazil',
    'Argentina',
  ];

  static const Map<String, List<String>> leaguesByCountry = {
    'England': ['Premier League', 'Championship', 'League One'],
    'Spain': ['La Liga', 'Segunda División'],
    'Germany': ['Bundesliga', '2. Bundesliga'],
    'Italy': ['Serie A', 'Serie B'],
    'France': ['Ligue 1', 'Ligue 2'],
    'Portugal': ['Primeira Liga'],
    'Netherlands': ['Eredivisie'],
    'Brazil': ['Brasileirão'],
    'Argentina': ['Primera División'],
  };
}
