List<Set<int>> solve(List<int> nbs) {
  List<Set<int>> res = [];

  for (int i = 0; i < nbs.length; ++i) {
    for (int j = i + 1; j < nbs.length; ++j) {
      if (nbs[i] == nbs[j]) {
        res.add({i, j}); 
      }
    }
  }

  return res;
}

void main() {
  List<int> numbers = [1, 2, 3, 1, 1, 3, 2, 2];
  print(solve(numbers)); 
}