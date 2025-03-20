class MathOps<T,G>{
  int convertToInt<T>(T obj){
    if(obj is String){
      int? result = int.tryParse(obj);
      if(result != null){
        return result;
      }else{
        throw Exception("Invalid Integer representation");
      }
    }
    else if(obj is double){
      return obj.round();
    }else if(obj is int){
      return obj;
    }
    return 0;
  }

  int sub(T obj1, G obj2){
    int a, b;
    try{
      a = convertToInt(obj1);
      b = convertToInt(obj2);
      return a - b;
    }on Exception catch(e){
      print(e);
    }
    return -1;
  }

  int prod(T obj1, G obj2){
    int a, b;
    try{
      a = convertToInt(obj1);
      b = convertToInt(obj2);
      return a * b;
    }on Exception catch(e){
      print(e);
    }
    return -1;
  }

  int mod(T obj1, G obj2){
    int a, b;
    try{
      a = convertToInt(obj1);
      b = convertToInt(obj2);
      return a % b;
    }on Exception catch(e){
      print(e);
    }
    return -1;
  }
}

void main(){
  MathOps<String, double> m_ops = MathOps();
  print(m_ops.prod("23", 5.2));
}