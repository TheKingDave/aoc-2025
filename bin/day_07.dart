import 'dart:math';

import 'package:aoc_2025/util.dart';

typedef P = Point<int>;

void main() async {
  await part2();
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();

  int splits = 0;
  final beams = <int>{};
  final splitters = <P>{};
  
  for (final (y, line) in lines.indexed) {
    for (final (x, char) in line.split('').indexed) {
      if (char == 'S') {
        beams.add(x);
      }
      if (char == '^') {
        splitters.add(P(x, y));
      }
    }
  }

  for (final y in Iterable.generate(lines.length)) {
    for (final b in [...beams]) {
      if (splitters.contains(P(b, y))) {
        splits++;
        beams.remove(b);
        beams.add(b-1);
        beams.add(b+1);
      }
    }
  }
  
  print(splits);
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  final beams = <int>[];
  final splitters = <Set<int>>[];


  final allPoints = RegExp('^\\.+\$');
  final applicableLines = lines.where((l) => !allPoints.hasMatch(l));
  
  for (final (y, line) in applicableLines.indexed) {
    splitters.add({});
    for (final (x, char) in line.split('').indexed) {
      if (char == 'S') {
        beams.add(x);
      }
      if (char == '^') {
        splitters[y].add(x);
      }
    }
  }
  
  final cache = <P, int>{};
  int findPaths(P p) {
    if (cache.containsKey(p)) {
      return cache[p]!;
    }
    if (p.y >= splitters.length) {
      return 1;
    }
    
    final paths = splitters[p.y].contains(p.x) ? findPaths(P(p.x-1, p.y+1)) + findPaths(P(p.x+1, p.y+1)) : findPaths(P(p.x, p.y+1));
    cache[p] = paths;
    return paths;
  }

  print(findPaths(P(beams[0], 0)));
}
