import 'package:collection/collection.dart';
import 'package:aoc_2025/util.dart';

void main() async {
  await part2();
}

typedef Range = ({int from, int to});

Range parseRange(String inp) {
  final [f, t] = inp.split('-');
  return (from: int.parse(f), to: int.parse(t));
}

bool isInvalidId1(int id) {
  final str = id.toString();
  if (str.length % 2 != 0) {
    return false;
  }
  
  return str.substring(0, str.length ~/ 2) == str.substring(str.length ~/ 2);
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();

  print(lines.first.split(',').map(parseRange).map((range) => Iterable.generate(range.to - range.from + 1, (n) => range.from + n).where(isInvalidId1)).expand((a) => a).reduce((a, b) => a + b));
}

bool isInvalidId2(int id) {
  final str = id.toString();
  
  return Iterable.generate(str.length ~/ 2, (n) => str.substring(0, n+1)).where((chars) => str.length % chars.length == 0).firstWhereOrNull((chars) => chars * (str.length ~/ chars.length) == str) != null;
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  print(lines.first.split(',').map(parseRange).map((range) => Iterable.generate(range.to - range.from + 1, (n) => range.from + n).where(isInvalidId2)).expand((a) => a).reduce((a, b) => a + b));
}