import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';

import 'constants/registro_constants.dart';
import 'constants/tabs_constants.dart';
import 'entity/overall_stats.dart';
import 'entity/subject_averages.dart';

class GradesUtils {
  static double getAverageFromGradesAndLocalGrades({
    @required List<LocalGrade> localGrades,
    @required List<Grade> grades,
  }) {
    double sum = 0;
    int count = 0;
    grades.forEach((g) {
      if (isValidGrade(g)) {
        sum += g.decimalValue;
        count++;
      }
    });
    FLog.info(text: 'Media senza local: ${sum / count}');
    FLog.info(text: 'Local Grades: ${localGrades.length}');

    localGrades.forEach((g) {
      if (isValidLocalGrade(g)) {
        sum += g.decimalValue;
        count++;
      }
    });

    FLog.info(text: 'Media con local: ${sum / count}');

    return sum / count;
  }

  static double getDifferencePercentage({
    @required double oldAverage,
    @required double newAverage,
  }) {
    if (newAverage > 0 && oldAverage > 0) {
      return (newAverage - oldAverage) / oldAverage * 10;
    }
    return 0.0;
//     If (CurrentValue > 0.0 && PreviousValue > 0.0) {
//    return (CurrentValue - PreviousValue) / PreviousValue;
// }  return 0.0;
  }

  static double getAverage(int subjectId, List<Grade> grades) {
    double sum = 0;
    int count = 0;

    int countAnnotaions = 0;
    grades.forEach((grade) {
      if (grade.decimalValue == -1.00 && grade.subjectId == subjectId)
        countAnnotaions++;
      if (grade.subjectId == subjectId && isValidGrade(grade)) {
        sum += grade.decimalValue;
        count++;
      }
    });
    final double avg = sum / count;

    if (countAnnotaions == 0 && avg.isNaN) {
      return -1.00;
    } else if (countAnnotaions > 0 && avg.isNaN) {
      return 0.0;
    }

    return avg;
  }

  static int getMinSchoolCredits(double average, int year) {
    if (year < 3) return 0;
    if (year == PrefsConstants.TERZA_SUPERIORE) {
      if (average < 6) return 0;
      if (average == 6) return 7;
      if (average > 6 && average <= 7) return 8;
      if (average > 7 && average <= 8) return 9;
      if (average > 8 && average <= 9) return 10;
      if (average > 9 && average <= 10) return 11;
    } else if (year == PrefsConstants.QUARTA_SUPERIORE) {
      if (average < 6) return 0;
      if (average == 6) return 8;
      if (average > 6 && average <= 7) return 9;
      if (average > 7 && average <= 8) return 10;
      if (average > 8 && average <= 9) return 11;
      if (average > 9 && average <= 10) return 12;
    } else if (year == PrefsConstants.QUINTA_SUPERIORE) {
      if (average < 6) return 7;
      if (average == 6) return 9;
      if (average > 6 && average <= 7) return 10;
      if (average > 7 && average <= 8) return 11;
      if (average > 8 && average <= 9) return 13;
      if (average > 9 && average <= 10) return 14;
    }

    return 0;
  }

  static double getAverageWithoutSubjectId(List<Grade> grades) {
    double sum = 0;
    int count = 0;

    grades.forEach((grade) {
      if (grade.decimalValue != -1.00 ||
          grade.cancelled == true ||
          grade.localllyCancelled == true) {
        sum += grade.decimalValue;

        count++;
      }
    });
    return sum / count;
  }

  static SubjectAverages getSubjectAveragesFromGrades(
      List<Grade> grades, int subjectId) {
    // Declare variables for the different type of averages
    double sumAverage = 0;
    double countAverage = 0;

    double sumPratico = 0;
    double countPratico = 0;

    double sumOrale = 0;
    double countOrale = 0;

    double sumScritto = 0;
    double countScritto = 0;

    grades.forEach((grade) {
      final decimalValue = grade.decimalValue;
      if (isValidGrade(grade) && grade.subjectId == subjectId) {
        // always check the average for all grades
        sumAverage += decimalValue;
        countAverage++;
        // Orale
        if (grade.componentDesc == RegistroConstants.ORALE) {
          sumOrale += decimalValue;
          countOrale++;
        }
        // Scritto
        if (grade.componentDesc == RegistroConstants.SCRITTO) {
          sumScritto += decimalValue;
          countScritto++;
        }
        // Pratico
        if (grade.componentDesc == RegistroConstants.PRATICO) {
          sumPratico += decimalValue;
          countPratico++;
        }
      }
    });

    return SubjectAverages(
      average: sumAverage / countAverage,
      praticoAverage: sumPratico / countPratico,
      scrittoAverage: sumScritto / countScritto,
      oraleAverage: sumOrale / countOrale,
    );
  }

  static OverallStats getOverallStatsFromSubjectGrades(
      Subject subject, List<Grade> grades, int period) {
    // get the number of insufficienze
    int insufficienze = 0;
    int sufficienze = 0;

    ///double average = 0;
    ///double worstAverage = 10.0;
    ///double bestAverage = 0;
    Subject worstSubject;
    Subject bestSubject;

    double maxGrade = -1.0;
    double minGrade = 10.0;

    int count = 0;
    double sum = 0;

    // average = getAverageWithoutSubjectId(
    //     grades.where((grade) => grade.subjectId == subject.id).toList());
    // // Check if it is best average
    // if (average > bestAverage) {
    //   bestSubject = subject;
    //   bestAverageó = average;
    // }
    // // Check fo worst subject
    // if (average < worstAverage) {
    //   worstSubject = subject;
    //   worstAverage = average;
    // }

    grades.forEach((grade) {
      // Ignore the grades in blue
      if ((grade.decimalValue != -1.00 && grade.periodPos == period) |
          (grade.decimalValue != -1.00 && period == TabsConstants.GENERALE)) {
        count++;
        sum += grade.decimalValue;

        // check for insufficienze and sufficienze
        if (grade.decimalValue >= 6) sufficienze++;
        if (grade.decimalValue < 6) insufficienze++;

        // check for best grade
        if (grade.decimalValue > maxGrade) {
          maxGrade = grade.decimalValue;
        }
        // check for min grade
        if (grade.decimalValue < minGrade) {
          minGrade = grade.decimalValue;
        }
      }
    });

    if (count > 0) {
      return OverallStats(
          insufficienze: insufficienze,
          sufficienze: sufficienze,
          votoMin: minGrade,
          votoMax: maxGrade,
          bestSubject: bestSubject,
          worstSubject: worstSubject,
          average: sum / count);
    } else {
      return null;
    }
  }

  static double getAverageForPratica(List<Grade> grades) {
    double sum = 0;
    int count = 0;

    grades.forEach((grade) {
      if (grade.decimalValue != -1.00 &&
          grade.componentDesc == RegistroConstants.ORALE) {
        sum += grade.decimalValue;
        count++;
      }
    });
    return sum / count;
  }

  /// Taken from registro elettroncio github by Simone Luconi, thanks
  static String getGradeMessage(
      double obj, double average, int numberOfGrades, BuildContext context) {
    if (average.isNaN)
      return AppLocalizations.of(context).translate('dont_worry');
    if (obj > 10 || average > 10) {
      return AppLocalizations.of(context).translate('calculation_error');
    }
    if (obj >= 10 && average < obj) {
      return AppLocalizations.of(context).translate('objective_unreacheable');
    }

    var array = [0.75, 0.5, 0.25, 0.0];
    var index = 0;
    double sommaVotiDaPrendere;
    var votiMinimi = [0.0, 0.0, 0.0, 0.0, 0.0];
    double diff;
    double diff2;
    double resto = 0.0;
    double parteIntera;
    double parteDecimale;
    try {
      do {
        index += 1;
        sommaVotiDaPrendere =
            obj * (numberOfGrades + index) - average * numberOfGrades;
      } while (sommaVotiDaPrendere / index > 10);
      var i = 0;
      while (i < index) {
        votiMinimi[i] = sommaVotiDaPrendere / index + resto;
        resto = 0.0;
        parteIntera = votiMinimi[i];
        parteDecimale = (votiMinimi[i] - parteIntera) * 100;
        if (parteDecimale != 25.0 &&
            parteDecimale != 50.0 &&
            parteDecimale != 75.0) {
          var k = 0;
          do {
            diff = votiMinimi[i] - (parteIntera + array[k]);
            k++;
          } while (diff < 0);
          votiMinimi[i] = votiMinimi[i] - diff;
          resto = diff;
        }
        if (votiMinimi[i] > 10) {
          diff2 = votiMinimi[i] - 10;
          votiMinimi[i] = 10.0;
          resto += diff2;
        }
        i += 1;
      }
      String returnString;
      final trans = AppLocalizations.of(context);
      if (votiMinimi[0] <= 0) return trans.translate('dont_worry');
      if (votiMinimi[0] <= obj)
        return "${trans.translate('dont_get_less_than')} ${votiMinimi[0].toStringAsFixed(2)}";
      else {
        returnString = "${trans.translate('get_at_least')} ";

        if (votiMinimi.where((voto) => voto != 0.0).length > 3) {
          return trans.translate('objective_unreacheable');
        }
        votiMinimi.where((votoMinimo) => votoMinimo != 0.0).forEach((voto) {
          returnString += "${voto.toStringAsFixed(2)}, ";
        });
        return returnString.substring(0, returnString.length - 2);
      }
    } catch (e) {
      return AppLocalizations.of(context).translate('objective_unreacheable');
    }
  }

  static bool isValidGrade(Grade grade) {
    return (grade.decimalValue != -1.00 &&
        grade.cancelled == false &&
        grade.localllyCancelled == false);
  }

  static bool isValidLocalGrade(LocalGrade grade) {
    return (grade.decimalValue != -1.00 || grade.cancelled != true);
  }
}
