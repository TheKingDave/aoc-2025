import 'package:collection/collection.dart';
import 'package:aoc_2025/util.dart';

typedef Devices = Map<String, List<String>>;

void main() async {
  final lines = await getFile().readAsLines();
  
  final deviceMap = { for (var parts in lines.map((line) => line.split(': '))) parts[0] : parts[1].split(' ') };
  
  await part2(deviceMap);
}

Future<void> part1(Devices deviceMap) async {
  int countPaths(String device) {
    if (device == 'out') {
      return 1;
    }
    final dev = deviceMap[device];
    if (dev == null) {
      return 0;
    }
    
    return dev.map(countPaths).sum;
  }
  
  print(countPaths('you'));
}

typedef Search = (String, bool, bool);
Future<void> part2(Devices deviceMap) async {
  final cache = <Search, int>{};
  
  int countPaths(Search search) {
    //print(search);
    final foundCache = cache[search];
    if (foundCache != null) {
      return foundCache;
    }
    
    if (search.$1 == 'out') {
      return search.$2 && search.$3 ? 1 : 0;
    }
    final dev = deviceMap[search.$1];
    if (dev == null) {
      return 0;
    }

    final sum = dev.map((d) => countPaths((d, search.$2 || search.$1 == 'dac', search.$3 || search.$1 == 'fft'))).sum;
    cache[search] = sum;
    return sum;
  }

  print(countPaths(('svr', false, false)));
}