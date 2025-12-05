import 'dart:math';

import 'package:aoc_2025/util.dart';

typedef P = Point<int>;

final directions = [
  P(-1, -1), P(0, -1), P(1, -1), 
  P(-1, 0),          P(1, 0), 
  P(-1, 1), P(0, 1), P(1, 1)
];

void main() async {
  await part2();
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();
  
  final rolls = <P>{};
  
  for (final (y, line) in lines.indexed) {
    for (final (x, char) in line.split('').indexed) {
      if (char == '@') {
        rolls.add(P(x, y));
      }
    }
  }
  
  print(rolls.where((roll) => directions.where((dir) => rolls.contains(roll + dir)).length < 4).length);
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  final rolls = <P>{};

  for (final (y, line) in lines.indexed) {
    for (final (x, char) in line.split('').indexed) {
      if (char == '@') {
        rolls.add(P(x, y));
      }
    }
  }
  
  var removed = 0;
  while (true) {
    final toRemove = rolls.where((roll) => directions.where((dir) => rolls.contains(roll + dir)).length < 4).toSet();
    if (toRemove.isEmpty) {
      break;
    }
    removed += toRemove.length;
    rolls.removeAll(toRemove);
  }
  
  print(removed);
}
