import 'dart:collection';

import 'package:aoc_2025/util.dart';
import 'package:collection/collection.dart';

typedef Button = List<int>;

class Machine {
  final int lightRequirement;
  final List<Button> buttons;
  final List<int> joltageRequirement;

  Machine(this.lightRequirement, this.buttons, this.joltageRequirement);

  factory Machine.parse(String str) {
    final parts = str.split(' ');

    final first = parts.first;
    final lightRequirement = first
        .substring(1, first.length - 1)
        .split('')
        .map((light) => light == '#')
        .foldIndexed<int>(
          0,
          (index, previous, element) => previous | ((element ? 1 : 0) << index),
        );

    final last = parts.last;
    final joltageReq = last
        .substring(1, last.length - 1)
        .split(',')
        .map(int.parse)
        .toList(growable: false);

    final buttons = parts
        .sublist(1, parts.length - 1)
        .map(
          (button) => button
              .substring(1, button.length - 1)
              .split(',')
              .map(int.parse)
              .toList(growable: false),
        )
        .toList(growable: false);

    return Machine(lightRequirement, buttons, joltageReq);
  }
  
  int pressButton(int state, int buttonIdx) {
    int newState = state;
    final button = buttons[buttonIdx];
    for (final b in button) {
      newState ^= (1 << b);
    }
    return newState;
  }

  List<int> pressButtonJoltage(List<int> state, int buttonIdx) {
    List<int> newState = state.sublist(0);
    final button = buttons[buttonIdx];
    for (final b in button) {
      newState[b] += 1;
    }
    return newState;
  }
  
  String stateString(int state, {int length = 10}) {
    return List.generate(length, (i) => (state & (1 << i)) > 0 ? '#' : '.').reversed.join('');
  }
  
  @override
  String toString() {
    return 'Machine{lightRequirement: ${stateString(lightRequirement)}, buttons: $buttons, joltageRequirement: $joltageRequirement}';
  }
}

void main() async {
  await part2();
}

typedef SearchState = ({int state, int button, int pressCount});
int findPresses(Machine machine) {
  final queue = Queue<SearchState>();
  
  queue.addAll(Iterable.generate(machine.buttons.length, (i) => (state: 0, button: i, pressCount: 0)));
  
  while (queue.isNotEmpty) {
    final taken = queue.removeFirst();
    
    if (taken.state == machine.lightRequirement) {
      return taken.pressCount;
    }

    queue.addAll(Iterable.generate(machine.buttons.length, (i) => (state: machine.pressButton(taken.state, taken.button), button: i, pressCount: taken.pressCount + 1)));
  }
  
  throw Exception("Never should land here");
}

Future<void> part1() async {
  final lines = await getFile().readAsLines();

  final machines = lines.map(Machine.parse);
  
  var sum = 0;
  for (final (i, machine) in machines.indexed) {
    print("$i/${machines.length}");
    sum += findPresses(machine);
  }
  
  print(sum);
}

typedef SearchStateJoltage = ({List<int> state, int button, int pressCount});
int findPressesJoltage(Machine machine) {
  final queue = Queue<SearchStateJoltage>();

  queue.addAll(Iterable.generate(machine.buttons.length, (i) => (state: List.generate(machine.joltageRequirement.length, (i) => 0), button: i, pressCount: 0)));

  while (queue.isNotEmpty) {
    final taken = queue.removeFirst();

    bool isCorrect = true;
    bool shouldSkip = false;
    for (final [s, r] in IterableZip([taken.state, machine.joltageRequirement])) {
      // State > requirement -> cannot continue
      if (s > r) {
        shouldSkip = true;
        break;
      }
      if (s != r) {
        isCorrect = false;
      }
    }
    
    if (shouldSkip) {
      continue;
    }
    if (isCorrect) {
      return taken.pressCount;
    }

    queue.addAll(Iterable.generate(machine.buttons.length, (i) => (state: machine.pressButtonJoltage(taken.state, taken.button), button: i, pressCount: taken.pressCount + 1)));
  }

  throw Exception("Never should land here");
}

Future<void> part2() async {
  final lines = await getFile().readAsLines();

  final machines = lines.map(Machine.parse);

  var sum = 0;
  for (final (i, machine) in machines.indexed) {
    print("$i/${machines.length}");
    final presses = findPressesJoltage(machine);
    sum += presses;
    print(presses);
  }

  print(sum);
}
