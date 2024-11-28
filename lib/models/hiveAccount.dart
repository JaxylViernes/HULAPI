import 'package:hive/hive.dart';

part 'hiveAccount.g.dart';

@HiveType(typeId: 0)
class HiveAccount {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String avatar;

  @HiveField(2)
  int score;

  @HiveField(3)
  int tagalogScore;

  @HiveField(4)
  int bisayaScore;

  @HiveField(5)
  int tagalogLevel;

  @HiveField(6)
  int bisayaLevel;

  HiveAccount(
      {required this.name,
      required this.avatar,
      required this.score,
      required this.tagalogLevel,
      required this.tagalogScore,
      required this.bisayaLevel,
      required this.bisayaScore});
}
