
Set<String>get_matches(String base, List<RegExp>regexes){
  Set<String> res = {};
  for(int i = 0; i < regexes.length; ++i){
    Iterable<Match> matches = regexes[i].allMatches(base);
    res.addAll(matches.map((e) => e[0].toString()));
  }
  return res;
}

void main(){
  List<RegExp>regexes = [RegExp(r"\d+"), RegExp(r"\w+")];
  print(get_matches("Mi-i foame mor, vreau sa prezint 231calcul numer1c 125", regexes));
}