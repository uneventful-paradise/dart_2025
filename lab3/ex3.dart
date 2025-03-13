class Client{
  final String _name;
  double _purchasesAmount = 0.0;

  Client(String name): this._name = name;

  String get name{return this._name;}
  double get clientPurchases => this._purchasesAmount;  //should it be named something else?
  void add(double amount){
    if(amount > 0){
      this._purchasesAmount += amount;
    }else{
      print("Amount must be positive");
    }
  }
}

class LoyalClient extends Client{
  double _purchasesAmount = 0.0;
  LoyalClient(String loyalName) : super(loyalName);

  double get loyalPurchases{
    return this._purchasesAmount;
  } 

  void discount(){
    this._purchasesAmount = 0.9 * super.clientPurchases;
    print("The loyal client's ${super.name} new purchase amount is ${this.loyalPurchases}");
  }
}

void main() {
  Client client = Client("GDT");
  client.add(200.0);

  print("Total Purchases Amount for ${client.name}: \$${client.clientPurchases}");

  LoyalClient loyalClient = LoyalClient("LM");
  loyalClient.add(300.0);


  loyalClient.discount();
}