import 'dart:async';
import 'dart:io';
String filename = "storage.txt";

List<dynamic>stack = [];

Future<void> read_stack() async{
  var file = File(filename);
  String contents = await file.readAsStringSync();
  print(contents);
  stack.add(contents);
}

void write_stack() async {
  // var file = await File(filename).writeAsString(stack.toString());
}

dynamic pop(){
  var res;
  read_stack();
  if (stack.isNotEmpty){
    res = stack.removeLast();
    write_stack();
  }
  return res;
}

void push(dynamic element){
  read_stack();
  stack.add(element.toString());
  write_stack();
  print("Wrote stack ${stack}");
}

void main() async{
  await read_stack();
  sleep(Duration(seconds: 1));
  print(stack);
}