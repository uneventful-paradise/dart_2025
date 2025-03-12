List<int>solve(List<String>arguments){
    var string_fragments = List.from(arguments);
    List<int>fragments = string_fragments.map<int>((i)=>int.parse(i)).toList();
    for(int i = fragments.length-1; i >= 0; --i){
        if(fragments[i] == 9){
            fragments[i] = 0;
        }else{
            fragments[i]++;
            return fragments;
        }
    }
    if(fragments.first == 0){
        fragments.insert(0, 1);
    }
    return fragments;
}

void main(List<String>arguments){
    print(solve(arguments));
}
//dart lab2/ex1.dart 9 9 9