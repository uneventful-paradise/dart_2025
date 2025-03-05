void main(List<String>arguments){
    List<List<int>> l = List<List<int>>.generate(arguments.first.length * 9 + 1, (i)=>[]);
    int n = int.parse(arguments.first);
    for(int i = 1; i <= n; ++i){
        l[i.toString().split('').map(int.parse).toList().reduce((sum, a)=>sum+=a)].add(i);
    }
    var lens = l.map((i)=>i.length).toList();
    var max_val = lens.reduce((curr, next) => curr > next? curr: next);
    lens = lens.where((i) => i == max_val).toList();
    print(lens.length);
}