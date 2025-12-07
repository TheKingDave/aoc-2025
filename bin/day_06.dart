import 'dart:math';

import 'package:aoc_2025/util.dart';
import 'package:collection/collection.dart';

void main() async {
  await part2();
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();
  
  final numbers = lines.map((line) => line.trim().split(RegExp(' +')).map(int.parse).toList(growable: false));
  final ops = lines.removeLast().trim().split(RegExp(' +'));
  
  int sum = 0;
  for (final (idx, op) in ops.indexed) {
    final combine = op == '+' ? (int a, int b) => a + b : (int a, int b) => a * b;
    
    sum += numbers.map((ns) => ns[idx]).reduce(combine);
  }
  
  print(sum);
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  final regexp = RegExp("(\\+|\\*) +");
  final ops = regexp.allMatches(lines.removeLast()).map((match) => match.group(0)!).toList(growable: false);
  ops.last += ' ';
  
  
  final numbers = lines.map((line) {
    final iter = line.split('').iterator;
    return ops.map((op) {
      final ret = Iterable.generate(op.length-1).map((_) => (iter..moveNext()).current).toList(growable: false);
      // Skip space between columns
      iter.moveNext();
      return ret;
    }).toList(growable: false);
  });
  
  var sum = 0;
  for (final (idx, op) in ops.indexed) {
    final combine = op.startsWith('+') ? (int a, int b) => a + b : (int a, int b) => a * b;
    final column = numbers.map((ns) => ns[idx]);
    
    final customNums = List.generate(op.length-1, (i) => column.map((c) => c[i]).where((c) => c != ' ').join('')).map(int.parse);
    sum += customNums.reduce(combine);
  }
  
  print(sum);
}
