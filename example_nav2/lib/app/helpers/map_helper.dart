




Map<String, int> returnSortedMap(Map<String, int> myMap) {
  var sortedEntries = myMap.entries.toList()..sort((e1, e2) {
    var diff = e2.value.compareTo(e1.value);
    if (diff == 0) diff = e2.key.compareTo(e1.key);
    return diff;
  });
  return Map<String, int>.fromEntries(sortedEntries);
}