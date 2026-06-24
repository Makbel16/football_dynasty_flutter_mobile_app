import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Club extends Equatable {
  const Club({
    required this.id,
    required this.name,
    required this.country,
    required this.league,
    required this.stadiumName,
    required this.primaryColor,
    required this.secondaryColor,
    this.logoUrl,
    this.budget = 5000000,
    this.clubValue = 10000000,
    this.fanHappiness = 70,
    this.boardConfidence = 70,
    this.reputation = 50,
    this.isUserClub = false,
    this.stadiumCapacity = 30000,
    this.foundedYear = 1900,
  });

  final String id;
  final String name;
  final String country;
  final String league;
  final String stadiumName;
  final Color primaryColor;
  final Color secondaryColor;
  final String? logoUrl;
  final double budget;
  final double clubValue;
  final double fanHappiness;
  final double boardConfidence;
  final int reputation;
  final bool isUserClub;
  final int stadiumCapacity;
  final int foundedYear;

  Club copyWith({
    String? id,
    String? name,
    String? country,
    String? league,
    String? stadiumName,
    Color? primaryColor,
    Color? secondaryColor,
    String? logoUrl,
    double? budget,
    double? clubValue,
    double? fanHappiness,
    double? boardConfidence,
    int? reputation,
    bool? isUserClub,
    int? stadiumCapacity,
    int? foundedYear,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      league: league ?? this.league,
      stadiumName: stadiumName ?? this.stadiumName,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      logoUrl: logoUrl ?? this.logoUrl,
      budget: budget ?? this.budget,
      clubValue: clubValue ?? this.clubValue,
      fanHappiness: fanHappiness ?? this.fanHappiness,
      boardConfidence: boardConfidence ?? this.boardConfidence,
      reputation: reputation ?? this.reputation,
      isUserClub: isUserClub ?? this.isUserClub,
      stadiumCapacity: stadiumCapacity ?? this.stadiumCapacity,
      foundedYear: foundedYear ?? this.foundedYear,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'country': country,
        'league': league,
        'stadiumName': stadiumName,
        'primaryColor': primaryColor.toARGB32(),
        'secondaryColor': secondaryColor.toARGB32(),
        'logoUrl': logoUrl,
        'budget': budget,
        'clubValue': clubValue,
        'fanHappiness': fanHappiness,
        'boardConfidence': boardConfidence,
        'reputation': reputation,
        'isUserClub': isUserClub ? 1 : 0,
        'stadiumCapacity': stadiumCapacity,
        'foundedYear': foundedYear,
      };

  factory Club.fromMap(Map<String, dynamic> map) => Club(
        id: map['id'] as String,
        name: map['name'] as String,
        country: map['country'] as String,
        league: map['league'] as String,
        stadiumName: map['stadiumName'] as String,
        primaryColor: Color(map['primaryColor'] as int),
        secondaryColor: Color(map['secondaryColor'] as int),
        logoUrl: map['logoUrl'] as String?,
        budget: (map['budget'] as num).toDouble(),
        clubValue: (map['clubValue'] as num).toDouble(),
        fanHappiness: (map['fanHappiness'] as num).toDouble(),
        boardConfidence: (map['boardConfidence'] as num).toDouble(),
        reputation: map['reputation'] as int? ?? 50,
        isUserClub: (map['isUserClub'] as int? ?? 0) == 1,
        stadiumCapacity: map['stadiumCapacity'] as int? ?? 30000,
        foundedYear: map['foundedYear'] as int? ?? 1900,
      );

  @override
  List<Object?> get props => [id, name, league];
}
