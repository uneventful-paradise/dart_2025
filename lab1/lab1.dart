bool is_prime(int x){
    if(x < 2)
        return false;
    if(x == 2)
        return true;
    for(int d = 2; d*d <= x; ++ d){
        if(x%d == 0)
            return false;
    }
    return true;
}

void print_prime(){
    var c = 0, n = 0;
    while(c < 100){
        if(is_prime(n)){
            print(n);
            c++;
        }
        n++;
    } 
}

/*Write a DART program that extracts all words from a 
phrase. A word is considered to be formed out 
of letters and numbers. Words are separated one from another with one 
or multiple spaces or punctuation marks.*/

void extract_words(String s)
{
    s = s.replaceAll(".", " ");
    s = s.replaceAll(",", " ");
    s = s.replaceAll("!", " ");
    s = s.replaceAll(";", " ");
    var tokens = s.split(" ");
    print("Words are:");
    for(int i = 0; i < tokens.length; ++i){
        if(tokens[i].length > 0){
            print(tokens[i]);
        }
    }
}

/*Write a dart function that extracts all the numbers from a text. 
The numbers can be double or int. The program will return the sum of the extracted numbers. */

void find_numbers(String s){
    // var res = s.replaceAll(new RegExp(r'[^0-9]'), '');
    // var intReg = RegExp(r'(\d+)');
    var floatReg = RegExp(r'([-+]?\d+(\.\d+)?)');
    // var floatReg = RegExp('r([-+]?[0-9]*(\.[0-9]+))');
    // print(intReg.allMatches(s).map((m)=>m.group(0)).join(', '));
    var nums = floatReg.allMatches(s).map((m)=>m.group(0)!);
    double sum = 0;
    for(final String number in nums){
        sum+=double.parse(number);
    }
    print(sum);
}

void convert_format(String s){
    var sb = new StringBuffer();
    int i = 1;
    sb.write(s[0].toLowerCase());
    while(i < s.length){
        if(s[i] == s[i].toUpperCase()){
            sb.write('_');
            sb.write(s[i].toLowerCase());
        }else{
            sb.write(s[i]);
        }
        i++;
    }
    var res = sb.toString();
    print(res);
}

void main(){
    print_prime();
    // extract_words("iuli e  sme.cher");
    // find_numbers("iuli 22 e s4mecher 152  -22.52");
    // convert_format("testUpperCase");
}