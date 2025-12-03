import 'package:aoc_2025/util.dart';

void main() async {
  await part2();
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();

  var countZero = 0;

  var maxRot = 99 + 1;
  var rot = 50;

  for (final line in lines) {
    final dir = line.startsWith('R') ? 1 : -1;
    final num = int.parse(line.substring(1));

    rot = (rot + (num * dir)) % maxRot;
    if (rot == 0) {
      countZero++;
    }
  }

  print(countZero);
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  var countZero = 0;

  var maxRot = 99 + 1;
  var rot = 50;

  for (final line in lines) {
    final dir = line.startsWith('R') ? 1 : -1;
    final num = int.parse(line.substring(1));
    
    final zeros = Iterable.generate(num, (idx) => (rot + (idx * dir)) % maxRot).where((n) => n == 0).length;
    //print('$line $rot $zeros');
    countZero += zeros;
    
    rot = (rot + (num * dir)) % maxRot;
  }
  
  /*for (final line in lines) {
    //print('$line :: $rot');
    final dir = line.startsWith('R') ? 1 : -1;
    final num = int.parse(line.substring(1));

    final baseCount = rot == 0 ? -1 : 0;
    if ((dir == -1 && num >= rot)) {
      countZero += baseCount + (num / maxRot).ceil();
    }
    
    if ((dir == 1 && (rot + num >= maxRot))) {
      countZero += (num / maxRot).ceil();
    }

    rot = (rot + (num * dir)) % maxRot;
  }*/

  print(countZero);
}
