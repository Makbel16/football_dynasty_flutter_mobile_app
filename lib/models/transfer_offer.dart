import 'package:equatable/equatable.dart';
import 'enums/game_enums.dart';

class TransferOffer extends Equatable {
  const TransferOffer({
    required this.id,
    required this.playerId,
    required this.fromClubId,
    required this.toClubId,
    required this.fee,
    required this.type,
    this.status = TransferStatus.negotiating,
    this.salary = 0,
    this.contractYears = 3,
    this.isLoan = false,
    this.createdAt,
  });

  final String id;
  final String playerId;
  final String fromClubId;
  final String toClubId;
  final double fee;
  final TransferType type;
  final TransferStatus status;
  final double salary;
  final int contractYears;
  final bool isLoan;
  final DateTime? createdAt;

  TransferOffer copyWith({
    String? id,
    String? playerId,
    String? fromClubId,
    String? toClubId,
    double? fee,
    TransferType? type,
    TransferStatus? status,
    double? salary,
    int? contractYears,
    bool? isLoan,
    DateTime? createdAt,
  }) {
    return TransferOffer(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      fromClubId: fromClubId ?? this.fromClubId,
      toClubId: toClubId ?? this.toClubId,
      fee: fee ?? this.fee,
      type: type ?? this.type,
      status: status ?? this.status,
      salary: salary ?? this.salary,
      contractYears: contractYears ?? this.contractYears,
      isLoan: isLoan ?? this.isLoan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'playerId': playerId,
        'fromClubId': fromClubId,
        'toClubId': toClubId,
        'fee': fee,
        'type': type.name,
        'status': status.name,
        'salary': salary,
        'contractYears': contractYears,
        'isLoan': isLoan ? 1 : 0,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory TransferOffer.fromMap(Map<String, dynamic> map) => TransferOffer(
        id: map['id'] as String,
        playerId: map['playerId'] as String,
        fromClubId: map['fromClubId'] as String,
        toClubId: map['toClubId'] as String,
        fee: (map['fee'] as num).toDouble(),
        type: TransferType.values.byName(map['type'] as String),
        status: TransferStatus.values.byName(map['status'] as String),
        salary: (map['salary'] as num?)?.toDouble() ?? 0,
        contractYears: map['contractYears'] as int? ?? 3,
        isLoan: (map['isLoan'] as int? ?? 0) == 1,
        createdAt: map['createdAt'] != null
            ? DateTime.parse(map['createdAt'] as String)
            : null,
      );

  @override
  List<Object?> get props => [id, playerId, status];
}
