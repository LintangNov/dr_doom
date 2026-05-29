import '../entities/sensor_bundle.dart';

class CalculateRiskScore {
  const CalculateRiskScore();

  /// Calculates the Doomscrolling Risk Score (DRS) based on sensor metrics.
  /// The returned score is clamped between 0.0 and 100.0.
  double call(SensorBundle bundle) {
    double score = 0.0;

    // 1. Ratio swipe-tap > 15: +25
    if (bundle.swipeToTapRatio > 15.0) {
      score += 25.0;
    }

    // 2. Rhythmic scroll > 10 min: +15
    if (bundle.rhythmicScrollMinutes > 10.0) {
      score += 15.0;
    }

    // 3. isLyingDown & isVeryStill: +20
    if (bundle.isLyingDown && bundle.isVeryStill) {
      score += 20.0;
    }

    // 4. lux < 5 & isLateNight: +20 (atau lux < 50 & isEvening: +10)
    if (bundle.lux < 5.0 && bundle.isLateNight) {
      score += 20.0;
    } else if (bundle.lux < 50.0 && bundle.isEvening) {
      score += 10.0;
    }

    // 5. sessionMinutes > 45: +30 (atau > 20: +15)
    if (bundle.sessionMinutes > 45.0) {
      score += 30.0;
    } else if (bundle.sessionMinutes > 20.0) {
      score += 15.0;
    }

    // 6. rapidSwitching: +8
    if (bundle.rapidSwitching) {
      score += 8.0;
    }

    // 7. Jika berbaring + malam + gelap total (<5 lux): bonus +15
    if (bundle.isLyingDown && bundle.isLateNight && bundle.lux < 5.0) {
      score += 15.0;
    }

    // Clamp score to range [0.0, 100.0]
    return score.clamp(0.0, 100.0);
  }
}
