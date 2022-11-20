const List<double> distance = [0.5, 1.0, 2.0, -1.0];

String distanceToString(double distance) {
  if (distance == -1.0) {
    return "상관 없어";
  } else {
    return "~${distance}km";
  }
}
