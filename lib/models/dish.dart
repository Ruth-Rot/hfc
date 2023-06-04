class DishModel {
  final String? id;
  final String type;
  final String amount;
  final String measurement;

  const DishModel(
      {this.id,
      required this.type,
      required this.amount,
      required this.measurement
    });
  toJson() {
    return {
      "dish": type,
      "measurement": measurement,
      "amount": amount,      
    };
  }
}