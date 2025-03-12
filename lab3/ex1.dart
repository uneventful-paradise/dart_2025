//implement q queue

class Queue<T>{
  var container = [];
  int? size;

  Queue(int size){
    this.size = size;
  }

  void push(T element){
    if(this.container.length <= this.size!){
      this.container.add(element);
    }else{
      print("Queue is full");
    }
  }

  T? pop(){
    if(!this.container.isNotEmpty){
      print("Queue is empty");
      return null;
    }else{
      return this.container.removeAt(0);
    }
  }

  T? front(){
    if(this.container.isNotEmpty){
      return this.container.first();
    }else{
      print("Queue is empty");
      return null;
    }
  }

  T? back(){
    if(this.container.isNotEmpty){
      return this.container.last;
    }else{
      print("Queue is empty");
      return null;
    }
  }

  bool isEmpty() => this.container.isEmpty;

  @override
  String toString(){
    return "Size: ${this.size} | Queue: ${this.container.join(', ')}";
  }
}


void main(){
  Queue<int> intQueue = Queue<int>(3);
  intQueue.push(2);
  intQueue.push(5);
  intQueue.push(4);
  print(intQueue.back());
  print(intQueue.pop());
  intQueue.push(22);
  print(intQueue.toString());
}