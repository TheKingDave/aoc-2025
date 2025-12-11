import 'dart:math';

import 'package:aoc_2025/pairwise.dart';
import 'package:aoc_2025/poly.dart';
import 'package:aoc_2025/util.dart';
import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';

typedef P = Point<int>;

class Rect {
  late final P pMin;
  late final P pMax;

  Rect(P a, P b) {
    pMin = P(min(a.x, b.x), min(a.y, b.y));
    pMax = P(max(a.x, b.x), max(a.y, b.y));
  }

  List<Line> get lines {
    final c = Point(pMin.x, pMax.y);
    final d = Point(pMax.x, pMin.y);
    
    return [Line(pMin, c), Line(pMin, d), Line(pMax, c), Line(pMax, d)];
  }
}

class Line {
  final P a;
  final P b;

  Line(this.a, this.b);

  bool get vertical {
    return a.x == b.x;
  }

  bool get horizontal {
    return a.y == b.y;
  }

  int get minX {
    return min(a.x, b.x);
  }

  int get maxX {
    return max(a.x, b.x);
  }

  int get minY {
    return min(a.y, b.y);
  }

  int get maxY {
    return max(a.y, b.y);
  }

  @override
  String toString() {
    return 'Line{a: $a, b: $b, minX: $minX}';
  }


}

int rectSize(P a, P b) {
  return ((a.x - b.x).abs() + 1) * ((a.y - b.y).abs() + 1);
}

void main() async {
  await part2();
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();

  final reds = lines
      .map((line) => line.split(',').map(int.parse))
      .map((nums) => P(nums.first, nums.last))
      .toList(growable: false);

  final combs = Combinations(2, reds)()
      .map((ps) => [rectSize(ps[0], ps[1]), ps])
      .sorted((a, b) => (b[0] as int) - (a[0] as int));
  print(combs.first);
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  final reds = lines
      .map((line) => line.split(',').map(double.parse))
      .map((nums) => Point<double>(nums.first, nums.last))
      .toList(growable: false);

  //final redLines = PairwiseIterable(reds).map((pair) => Line(pair.$1, pair.$2));
  //final verticalLines = redLines.where((line) => line.vertical);
  //final horizontalLines = redLines.where((line) => line.horizontal);

  int maxSize = 0;
  
  final poly = Poly(vertices: reds);
  
  for (var y = 0; y < 15; y++) {
    for (var x = 0; y < 10; x++) {
      if (poly.isPointInPolygon(Point(x.toDouble(), y.toDouble()))) {
        print('$x : $y');
      }
    }
  }
  
  /*for (final (i, a) in reds.indexed) {
    for (final (brokenJ, b) in reds.sublist(i + 1).indexed) {
      final j = brokenJ + i + 1;
      if ((i - j).abs() == 1) {
        continue;
      }
      if (rectSize(a, b) <= maxSize) {
        continue;
      }

      final a2 = P(a.x, b.y);
      final b2 = P(b.x, a.y);

      final rect = Rect(a, b);
      
      final collides = rect.lines.whereNot((cl) {
        if (cl.vertical) {
          final collidingLine = horizontalLines.firstWhereOrNull((vl) {
            final c1 = vl.minX <= cl.a.x;
            final c2 = vl.maxX >= cl.a.x;
            final c3 = cl.minY <= vl.a.y || vl.minY == rect.pMax.y;
            final c4 = cl.maxY > vl.a.y || vl.maxY == rect.pMin.y;

            final combined = c1 && c2 && c3 && c4;
            return combined;
          });
          if (collidingLine != null) {
            return false;
          }
        } else {
          final collidingLine = horizontalLines.firstWhereOrNull((vl) {
            final c1 = vl.minY <= cl.a.y;
            final c2 = vl.maxY >= cl.a.y;
            final c3 = cl.minX < vl.a.x;
            final c4 = cl.maxX > vl.a.x;

            final combined = c1 && c2 && c3 && c4;
            return combined;
          });
          if (collidingLine != null) {
            return false;
          }
        }
        return true;
      }).firstOrNull;
      
      if (collides == null) {
        print("$a $b");
        final rSize = rectSize(a, b);
        if (rSize > maxSize) {
          print("Bigger: $a $b");
          maxSize = rSize;
        }
      }
    }
  }*/
  
  print(maxSize);
}
