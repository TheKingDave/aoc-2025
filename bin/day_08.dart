import 'package:aoc_2025/util.dart';
import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';
import 'package:vector_math/vector_math.dart';

void main() async {
  await part2();
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();
  
  final junctionBoxes = lines.map((line) {
    final parts = line.split(',');
    return Vector3(double.parse(parts[0]), double.parse(parts[1]), double.parse(parts[2]));
  }).toList(growable: false);
  
  
  List<Set<Vector3>> circuits = [];
  
  int? isJunctionInCircuits(Vector3 junction) {
    return circuits.indexed.firstWhereOrNull((a) => a.$2.contains(junction))?.$1;
  }
  
  print(Combinations(2, junctionBoxes).length);
  final combs = Combinations(2, junctionBoxes)().toList(growable: false);
  combs.sort((a, b) => (a[0].distanceTo(a[1]) - b[0].distanceTo(b[1])).ceil());
  print('sorted');
  
  for (final connection in combs.take(1000)) {
    final [a, b] = connection;
    final aCircuit = isJunctionInCircuits(a);
    final bCircuit = isJunctionInCircuits(b);
    
    if (aCircuit != null && bCircuit != null) {
      if (aCircuit != bCircuit) {
        circuits[aCircuit].addAll(circuits[bCircuit]);
        circuits.removeAt(bCircuit);
      }
    } else if (aCircuit != null) {
      circuits[aCircuit].add(b);
    }  else if (bCircuit != null) {
      circuits[bCircuit].add(a);
    } else {
      circuits.add(Set.from(connection));
    }
  }
  
  final cirSize = circuits.map((c) => c.length).toList(growable: false);
  cirSize.sort((a, b) => b - a);
  print(cirSize.take(3).reduce((a, b) => a * b));
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  final junctionBoxes = lines.map((line) {
    final parts = line.split(',');
    return Vector3(double.parse(parts[0]), double.parse(parts[1]), double.parse(parts[2]));
  }).toList(growable: false);


  List<Set<Vector3>> circuits = [];

  int? isJunctionInCircuits(Vector3 junction) {
    return circuits.indexed.firstWhereOrNull((a) => a.$2.contains(junction))?.$1;
  }

  final combs = Combinations(2, junctionBoxes)().toList(growable: false);
  combs.sort((a, b) => (a[0].distanceTo(a[1]) - b[0].distanceTo(b[1])).ceil());
  print('sorted');

  for (final connection in combs) {
    final [a, b] = connection;
    final aCircuit = isJunctionInCircuits(a);
    final bCircuit = isJunctionInCircuits(b);

    if (aCircuit != null && bCircuit != null) {
      if (aCircuit != bCircuit) {
        circuits[aCircuit].addAll(circuits[bCircuit]);
        circuits.removeAt(bCircuit);
      }
    } else if (aCircuit != null) {
      circuits[aCircuit].add(b);
    }  else if (bCircuit != null) {
      circuits[bCircuit].add(a);
    } else {
      circuits.add(Set.from(connection));
    }
    for (final circ in circuits) {
      if (circ.length == junctionBoxes.length) {
        print(connection[0].x * connection[1].x);
        return;
      }
    }
  }
  
  print(circuits);
}
