
class Reward{
  Reward();

  static int getPointsBySubtotal(double subTotal){
    print("getNewPoings = $subTotal");
    return (subTotal/10).floor();
  }
}