import 'dart:math';

import 'package:aoc_2025/util.dart';
import 'package:collection/collection.dart';

class Range {
  final int from;
  final int to;

  Range(this.from, this.to);
  
  factory Range.parse(String str) {
    final [f, t] = str.split('-');
    return Range(int.parse(f), int.parse(t));
  }
  
  bool includes(int idx) {
    return idx >= from && idx <= to;
  }
  
  bool overlapsWith(Range other) {
    // 3-5 10-14
    
    return (from <= other.from && to >= other.from) || (other.from <= from && other.to >= from);
  }
  
  Range combine(Range other) {
    return Range(min(from, other.from), max(to, other.to));
  }
  
  int get size {
    return (to - from) + 1;
  }

  @override
  String toString() {
    return 'Range{from: $from, to: $to}';
  }
}

void main() async {
  await part2();
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();
  
  final ranges = lines.takeWhile((line) => line != '').map(Range.parse);
  final ingredients = lines.skipWhile((line) => line != '').skip(1).map(int.parse);
  
  print(ingredients.where((ing) => ranges.any((range) => range.includes(ing))).length);
}

List<Range> combineRanges(List<Range> ranges) {
  final combinedRanges = <Range>[];

  for (final range in ranges) {
    final overlap = combinedRanges.firstWhereOrNull((r) => r.overlapsWith(range));
    if (overlap == null) {
      combinedRanges.add(range);
    } else {
      combinedRanges.remove(overlap);
      combinedRanges.add(range.combine(overlap));
    }
  }
  return combinedRanges;
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  var ranges = lines.takeWhile((line) => line != '').map(Range.parse).toList();
  
  while (true) {
    int lengthBefore = ranges.length;
    ranges = combineRanges(ranges);
    int lengthAfter = ranges.length;
    if (lengthBefore == lengthAfter) {
      break;
    }
  }
  print(ranges.fold<int>(0, (sum, r) => sum + r.size));
}
