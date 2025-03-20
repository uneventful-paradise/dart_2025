import 'dart:convert';
import 'dart:io';

Map<String, dynamic> getJsonObj(String filename){
  var json = JsonDecoder();
  String contents = File(filename).readAsStringSync();
  return json.convert(contents);
}

void printMapContents(Map<String, dynamic>obj){
    obj.forEach((key, value){
    print("Key: $key");
    if( value is Map<String, dynamic>){
      printMapContents(value);
    }else{
      print(": $value");
    }
  });
}

bool searchForNode(List<String> needleKeys, dynamic needleValue, int haystackLevel, int needleLevel, Map<String, dynamic> haystack) {
  for (var entry in haystack.entries) {
    if (haystackLevel == needleLevel &&
        entry.key == needleKeys[needleLevel] &&
        entry.value == needleValue) {
      return true;
    }
    if (entry.value is Map<String, dynamic> &&
        haystackLevel < needleLevel &&
        entry.key == needleKeys[haystackLevel]) {
      if (searchForNode(needleKeys, needleValue, haystackLevel + 1, needleLevel, entry.value)) {
        return true;
      }
    }
  }
  return false;
}


void searchForDups(Map<String, dynamic> obj1, Map<String, dynamic>obj2, List<String>pastKeys, int level){
  obj1.forEach((key, value){
    pastKeys.add(key);
    if(searchForNode(pastKeys, value, 0, level, obj2)){
      print("$key : $value pair is a dup");
    }
    pastKeys.remove(key);
    if(value is Map<String, dynamic>){
      pastKeys.add(key);
      searchForDups(value, obj2, pastKeys, level+1);
      pastKeys.remove(key);
    }
  });
}

Map<String, dynamic>jsonSubtract(Map<String, dynamic> obj1, Map<String, dynamic> obj2){
  Map<String, dynamic> res = {};
  
  obj1.forEach((key, value){
    //if key doesn't exist in obj2 then this pair is unique to obj1
    if(!obj2.keys.contains(key)){
      res[key] = value;
    }
    //key exists now check for problematic equality possibilities (nested dictionaries or lists)
    else if(value is Map<String, dynamic> && obj2[key] is Map<String, dynamic>){
      Map<String, dynamic> subRes = jsonSubtract(value, obj2[key]);
      if(subRes.isNotEmpty){
        res[key] = subRes;
      }
    }else if(value is List && obj2[key] is List){//problematic for elements that dont have equality operator defined?
      final List<dynamic> subRes = value.where((item) => !obj2[key].contains(item)).toList();
      if(subRes.isNotEmpty){
        res[key] = subRes;
      }
    }else{
      if(value != obj2[key]){
        res[key] = value;
      }
    }
  });
  
  return res;
}

Map<String, dynamic>jsonSubJson(String jsonPath1, String jsonPath2){
  var obj1 = getJsonObj(jsonPath1);
  var obj2 = getJsonObj(jsonPath2);
  // printMapContents(obj1);

  // searchForDups(obj1, obj2, [], 0);
  
  return jsonSubtract(obj1, obj2);
}