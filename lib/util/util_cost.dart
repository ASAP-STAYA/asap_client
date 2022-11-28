const List<int> costs = [2000, 4000, 6000, -1];

String costToString(int cost) {
  if (cost == -1.0) {
    return "상관 없어";
  } else {
    return "~$cost원";
  }
}

int getIndexOfCost(double cost) {
  return costs.indexOf(cost.toInt());
}

int getCostFromSelectedList(List<bool> isSelected) {
  for (int i = 0; i < isSelected.length; i++) {
    if (isSelected[i] == true) {
      return costs[i];
    }
  }
  throw Exception("[ERROR] Any cost is not selected");
}
