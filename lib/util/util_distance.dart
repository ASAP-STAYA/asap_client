const List<double> distances = [0.5, 1.0, 2.0, -1.0];

String distanceToString(double distance) {
  if (distance == -1.0) {
    return "상관 없어";
  } else {
    return "~${distance}km";
  }
}

int getIndexOfDistance(double distance) {
  return distances.indexOf(distance);
}

double getDistanceFromSelectedList(List<bool> isSelected) {
  for (int i = 0; i < isSelected.length; i++) {
    if (isSelected[i] == true) {
      return distances[i];
    }
  }
  throw Exception("[ERROR] Any distance is not selected");
}
