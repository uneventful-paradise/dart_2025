void main(List<String>arguments){
    var mapping = <String,int>{};
    for(int i = 0; i < arguments.length - 1; i+=2){
        mapping[arguments[i]] = int.parse(arguments[i+1]);
    }
    print(mapping);
    String coding = arguments.last;
    int sum = 0;
    
    for(int i = 0; i < coding.length; ++i){
        sum = sum + (mapping[coding[i]] as int);
    }
    print(sum);
}
//dart lab2/ex2.dart A 5 B 3 C 9 ABBCC