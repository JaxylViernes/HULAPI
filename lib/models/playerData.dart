import 'package:hive/hive.dart';

part 'playerData.g.dart';

@HiveType(typeId: 1)
class Player {
  @HiveField(0)
  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final int level;

  @HiveField(4)
  final int score;

  Player({
    required this.name,
    required this.image,
    this.level = 0,
    this.score = 0,
  });
}
