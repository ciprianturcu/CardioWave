import 'dart:ffi';

double calculateColapsFromAlgorithmOutput(String distance1, String distance2) {
  double intDistance1 = double.parse(distance1);
  double intDistance2 = double.parse(distance2);
  // Calculate delta
  double delta = (intDistance1.abs() - intDistance2.abs()).abs();
  //Calculate average
  double average = (intDistance1 + intDistance2) / 2.0;
  // Handle the case where the average is zero to prevent division by zero
  if (average == 0) {
    return 0; // or handle as you see fit
  }

  // Calculate the percentage difference
  double percentageDiff = (delta / average) * 100;

  return percentageDiff;
}

bool isColaps(String distance1, String distance2) {
  if (calculateColapsFromAlgorithmOutput(distance1, distance2) > 50)
    return true;
  return false;
}
