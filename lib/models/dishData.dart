class DishData {
  final double calories;
  final double protein;
  final double crabs;
  final double fat;

  const DishData({
    required this.calories,
    required this.protein,
    required this.crabs,
    required this.fat,
  });

  factory DishData.fromJson(Map<String, dynamic> json) {
    double pro= 0.0;
    if(json['totalDaily'].length>0){
      pro = json['totalDaily']['PROCNT']['quantity'].toDouble();
    }
    double cra= 0.0;
    if(json['totalDaily'].length>0){
      cra = json['totalDaily']['CHOCDF']['quantity'].toDouble();
    }
    double fat= 0.0;
    if(json['totalDaily'].length>0 ){
      fat = json['totalDaily']['FAT']['quantity'].toDouble();
    }
    return DishData(
      calories: json['calories'].toDouble(),
      protein: pro,
      crabs: cra,
      fat: fat,
    );
  }

 double getCalories() {
    return calories;
  }

  toJson() {
    return {
     "calories": calories,
      "crabs": crabs,
      "fat": fat,   
      "protein": protein
  };
  }
}
