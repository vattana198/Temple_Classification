// lib/utils/classifier_utils.dart
import 'dart:math';

class ClassifierUtils {
  /// Predicts the closest matching class from reference embeddings
  static String? predictClass(
    Map<String, List<double>> referenceDatabase,
    List<double> testEmbedding, {
    double? maxDistance, // Optional threshold
  }) {
    double minDistance = double.infinity;
    String? predictedClass;

    referenceDatabase.forEach((label, referenceEmbedding) {
      final distance = euclideanDistance(testEmbedding, referenceEmbedding);
      
      if (distance < minDistance && (maxDistance == null || distance <= maxDistance)) {
        minDistance = distance;
        predictedClass = label;
      }
    });

    return predictedClass;
  }

  static double euclideanDistance(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must be of the same length');
    }
    double sum = 0.0;
    for (int i = 0; i < a.length; i++) {
      sum += (a[i] - b[i]) * (a[i] - b[i]);
    }
    return sqrt(sum);
  }
}