import 'package:uuid/uuid.dart';
import '../../core/utils/random_utils.dart';
import '../../models/club.dart';
import '../../models/enums/game_enums.dart';
import '../../models/player.dart';
import '../../models/transfer_offer.dart';

class TransferEngineService {
  TransferEngineService._();
  static final TransferEngineService instance = TransferEngineService._();
  static const _uuid = Uuid();

  double calculateTransferValue(Player player) {
    var value = player.marketValue;
    value *= 1 + (player.form - 50) / 100;
    if (player.age < 24) value *= 1.2;
    if (player.potential > player.overall + 10) value *= 1.15;
    if (player.contractYears <= 1) value *= 0.7;
    return value.clamp(50000, 200000000);
  }

  TransferOffer createOffer({
    required Player player,
    required Club fromClub,
    required Club toClub,
    TransferType type = TransferType.buy,
    bool isLoan = false,
  }) {
    final value = calculateTransferValue(player);
    final feeMultiplier = RandomUtils.nextDouble(0.85, 1.15);
    final offeredFee = value * feeMultiplier;
    final salary = player.salary * RandomUtils.nextDouble(1.0, 1.3);

    return TransferOffer(
      id: _uuid.v4(),
      playerId: player.id,
      fromClubId: fromClub.id,
      toClubId: toClub.id,
      fee: offeredFee,
      type: type,
      status: TransferStatus.negotiating,
      salary: salary,
      contractYears: RandomUtils.nextInt(2, 5),
      isLoan: isLoan,
      createdAt: DateTime.now(),
    );
  }

  List<TransferOffer> generateAiOffers({
    required List<Player> marketPlayers,
    required Club aiClub,
    required List<Club> allClubs,
    int count = 3,
  }) {
    final offers = <TransferOffer>[];
    final shuffled = RandomUtils.shuffle(marketPlayers);

    for (var i = 0; i < count && i < shuffled.length; i++) {
      final player = shuffled[i];
      final sellerClub = allClubs.firstWhere(
        (c) => c.id == player.clubId,
        orElse: () => aiClub,
      );
      if (sellerClub.id == aiClub.id) continue;

      offers.add(createOffer(
        player: player,
        fromClub: sellerClub,
        toClub: aiClub,
      ));
    }
    return offers;
  }

  TransferOffer negotiate({
    required TransferOffer offer,
    required double counterFee,
    required double counterSalary,
  }) {
    final feeDiff = (counterFee - offer.fee).abs() / offer.fee;
    final accepted = feeDiff < 0.15 && counterSalary <= offer.salary * 1.2;

    return offer.copyWith(
      fee: counterFee,
      salary: counterSalary,
      status: accepted ? TransferStatus.completed : TransferStatus.negotiating,
    );
  }

  bool canAfford(Club club, double fee, double weeklySalary) {
    return club.budget >= fee && club.budget >= weeklySalary * 52 * 3;
  }

  Player completeTransfer({
    required Player player,
    required TransferOffer offer,
  }) {
    return player.copyWith(
      clubId: offer.toClubId,
      salary: offer.salary,
      contractYears: offer.contractYears,
      isOnLoan: offer.isLoan,
      loanFromClubId: offer.isLoan ? offer.fromClubId : null,
      morale: player.morale + 5,
    );
  }

  List<Player> getTransferListedPlayers(
    List<Player> allPlayers, {
    String? excludeClubId,
  }) {
    return allPlayers
        .where((p) =>
            p.clubId != excludeClubId &&
            !p.isYouth &&
            !p.clubId.startsWith('market_'))
        .toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
  }
}
