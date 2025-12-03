import 'dart:math';

import 'package:aoc_2025/util.dart';

void main() async {
  await part2();
}

({int num, int idx}) indexOfLargest(List<int> j) {
  final largest = j.reduce((a, b) => max(a, b));
  return (num: largest, idx: j.indexOf(largest));
}

int findBiggestJoltage(String batteries, int numOfBatteries) {
  var bats = batteries.split('').map(int.parse).toList();

  var sum = 0;
  for (int i = 0; i < numOfBatteries; i++) {
    final withoutLast = bats.sublist(0, bats.length - (numOfBatteries - i - 1));
    final biggest = indexOfLargest(withoutLast);
    bats = bats.sublist(biggest.idx + 1);
    sum += biggest.num * pow(10, numOfBatteries - i - 1).toInt();
  }

  return sum;
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();

  print(
    lines.map((bats) => findBiggestJoltage(bats, 2)).reduce((a, b) => a + b),
  );
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  print(
    lines.map((bats) => findBiggestJoltage(bats, 12)).reduce((a, b) => a + b),
  );
}
