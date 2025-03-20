import 'dart:io';

class FileStack{
  final String _filename;
  List<String>_stack = [];

  FileStack(this._filename){
    readFromFile();
  }

  void readFromFile(){
    try{
      if(File(this._filename).existsSync()){
        this._stack = File(this._filename).readAsLinesSync();
        // print(this._stack);
      }
    }catch(e){
      print("Error while attempting to open file: $e");
    }
  }

  bool isEmpty() => this._stack.isEmpty;

  void writeToFile(){
    try{
      if(File(this._filename).existsSync()){
        File(this._filename).writeAsStringSync(this._stack.join('\n'));
      }
    }catch(e){
      print("Error at opening file: $e");
    }
  }

  void push(String value){
    this._stack.add(value);
    this.writeToFile();
  }

  String? pop(){
    if(!this.isEmpty()){
      String element = this._stack.removeLast();
      // print("stack after pop: ${this._stack}");
      this.writeToFile();
      return element;

    }else{
      print("Stack is empty");
      return null;
    }
  }

}

void main(){
  FileStack fs = FileStack("ex2/storage_2.txt");
  print(fs._stack);
  fs.push(65.toString());
  print(fs._stack);
  print(fs.pop());
  print(fs.pop());
}