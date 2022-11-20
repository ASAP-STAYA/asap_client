const List<double> cost = [0.0, 500.0, 1000.0, -1.0];

String costToString(double cost) {
  if (cost == 0.0) {
    return "무료만";
  } else if (cost == -1.0) {
    return "상관 없어";
  } else {
    return "~$cost원";
  }
}
