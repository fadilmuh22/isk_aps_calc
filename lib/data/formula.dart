import 'dart:isolate';

import 'package:isk_aps_calc/data/model/indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';

class Formula {
  static Map<String, dynamic> map;

  static checkDataLooping(
      Map<String, dynamic> map, List<MappingIndicatorModel> lmap) {
    Formula.map = map;
    lmap.map((mappingIndicator) {
      mappingIndicator.indicator.map((indicator) => mappingFormula(indicator));
    });
  }

  static stringToFunction(String function) async {
    final uri = Uri.dataFromString(
      '''
      import 'dart:isolate';
      import 'package:isk_aps_calc/data/formula.dart';

      void main(_, SendPort port) {
        port.send(Formula.$function());
      }
      ''',
      mimeType: 'application/dart',
    );

    final port = ReceivePort();
    final isolate = await Isolate.spawnUri(uri, [], port.sendPort);
    final String response = await port.first;

    port.close();
    isolate.kill();

    print(response);
  }

  static mappingFormula(IndicatorModel indicatorModel) {
    return stringToFunction(indicatorModel.formula);
  }

  static double f1() {
    double newScores;

    if (map['NDTPS'] >= 12) {
      newScores = 4;
    } else if (map['NDTPS'] < 12 && map['NDTPS'] >= 3) {
      newScores = (2 * map['NDTPS']) / 9;
    } else {
      // NDTPS < 3
      newScores = 0;
    }

    return newScores;
  }

  static double f2() {
    double newScores;

    if (map['NDTPS'] >= 6) {
      newScores = 4;
    } else if (map['NDTPS'] < 6 && map['NDTPS'] >= 3) {
      newScores = (2 * map['NDTPS']) / 3;
    } else {
      // NDTPS < 3
      newScores = 0;
    }

    return newScores;
  }

  static double f3() {
    double newScores;
    double newPDS3;

    newPDS3 = ((map['NDS3'] / map['NDTPS']) * 100 / 100);
    map['PDS3'] = newPDS3;

    if (map['PDS3'] >= 50) {
      newScores = 4;
    } else if (map['PDS3'] < 50) {
      newScores = (2 + (4 * map['PDS3']));
    }

    return newScores;
  }

  static double f4() {
    double newScores;
    double newPGBLKL;

    newPGBLKL =
        (((map['NDGB'] + map['NDLK'] + map['NDL']) / map['NDTPS']) * 100 / 100);
    map['PGBLKL'] = newPGBLKL;

    if (map['PGBLKL'] >= 70) {
      newScores = 4;
    } else if (map['PGBLKL'] < 70) {
      newScores = (2 + (20 * map['PGBLKL']));
    }

    return newScores;
  }

  static double f5() {
    double newScores;

    newScores = ((map['A'] + (2 * map['B']) + (2 * map['C'])) / 5);
    map['N1'] = newScores;

    return newScores;
  }

  static double f6() {
    double newScores;
    double newPJ;
    double newPrmin;
    double formula;

    newPJ = ((map['NLtotal'] / map['NJtotal']) * 100);

    if ((map['NLtotal'] >= 300)) {
      newPrmin = 30;
    } else if (map['NLtotal'] < 300) {
      newPrmin = ((50 / 100) - ((map['NLtotal'] / 300) * (20 / 100))) * 100;
    }

    if (map['WT'] < 3) {
      formula = 4;
    } else if (map['WT'] >= 3 && map['WT'] <= 6) {
      formula = ((24 - (4 * map['WT'])) / 3);
    } else if (map['WT'] > 6) {
      formula = 0;
    }

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    map['PJ'] = newPJ;
    map['Prmin'] = newPrmin;

    return newScores;
  }

  static double f7() {
    double newScores;
    double newPJ;
    double newPrmin;
    double formula;

    newPJ = ((map['NLtotal'] / map['NJtotal']) * 100);

    if ((map['NLtotal'] >= 300)) {
      newPrmin = 30;
    } else if (map['NLtotal'] < 300) {
      newPrmin = ((50 / 100) - ((map['NLtotal'] / 300) * (20 / 100))) * 100;
    }

    if (map['WT'] < 6) {
      formula = 4;
    } else if (map['WT'] >= 6 && map['WT'] <= 18) {
      formula = ((18 - map['WT']) / 3);
    } else if (map['WT'] > 18) {
      formula = 0;
    }

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    map['PJ'] = newPJ;
    map['Prmin'] = newPrmin;

    return newScores;
  }

  static double f8() {
    double newScores;
    double newPJ;
    double newPrmin;
    double formula;

    newPJ = ((map['NLtotal'] / map['NJtotal']) * 100);

    if ((map['NLtotal'] >= 300)) {
      newPrmin = 30;
    } else if (map['NLtotal'] < 300) {
      newPrmin = ((50 / 100) - ((map['NLtotal'] / 300) * (20 / 100))) * 100;
    }

    if (map['PBS'] >= 60) {
      formula = 4;
    } else if (map['PBS'] > 18) {
      formula = (20 * map['PBS']) / 3;
    }

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    map['PJ'] = newPJ;
    map['Prmin'] = newPrmin;

    return newScores;
  }

  static double f9() {
    double newScores;
    double newPJ;
    double newPrmin;
    double formula;
    double newTKG;
    double newTKH;
    double newTKI;
    double newTKJ;
    double newTKK;
    double newTKL;
    double newTKM;

    newPJ = ((map['NLtotal'] / map['NJItotal']) * 100);

    if ((map['NLtotal'] >= 300)) {
      newPrmin = 30;
    } else if (map['NLtotal'] < 300) {
      newPrmin = ((50 / 100) - ((map['NLtotal'] / 300) * (20 / 100))) * 100;
    }

    newTKG =
        (((4 * map['G1']) + (3 * map['G2']) + (2 * map['G3']) + map['G4']));
    newTKH =
        (((4 * map['H1']) + (3 * map['H2']) + (2 * map['H3']) + map['H4']));
    newTKI =
        (((4 * map['I1']) + (3 * map['I2']) + (2 * map['I3']) + map['I4']));
    newTKJ =
        (((4 * map['J1']) + (3 * map['J2']) + (2 * map['J3']) + map['J4']));
    newTKK =
        (((4 * map['K1']) + (3 * map['K2']) + (2 * map['K3']) + map['K4']));
    newTKL =
        (((4 * map['L1']) + (3 * map['L2']) + (2 * map['L3']) + map['L4']));
    newTKM =
        (((4 * map['M1']) + (3 * map['M2']) + (2 * map['M3']) + map['M4']));

    formula =
        (newTKG + newTKH + newTKI + newTKJ + newTKK + newTKL + newTKM) / 7;

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    map['PJ'] = newPJ;
    map['Prmin'] = newPrmin;
    map['TKG'] = newTKG;
    map['TKH'] = newTKH;
    map['TKI'] = newTKI;
    map['TKJ'] = newTKJ;
    map['TKK'] = newTKK;
    map['TKL'] = newTKL;
    map['TKM'] = newTKM;
    map['TKtotal'] = formula;

    return newScores;
  }

  static double f10() {
    double newScores;
    double newRL;
    double newRN;
    double newRI;

    newRL =
        (((map['NA1'] + map['NB1'] + map['NC1']) / map['NM']) * (100 / 100));
    newRN = (((map['NA2'] + map['NA3'] + map['NB2'] + map['NC2']) / map['NM']) *
        (100 / 100));
    newRI =
        (((map['NA4'] + map['NB3'] + map['NC3']) / map['NM']) * (100 / 100));

    map['RL'] = newRL;
    map['RN'] = newRN;
    map['RI'] = newRI;

    if (map['RI'] >= (2 / 100)) {
      newScores = 4;
    } else if ((map['RI'] < (2 / 100)) && (map['RN'] >= (20 / 100))) {
      newScores = (3 + (map['RI'] / (2 / 100)));
    } else if ((map['RI'] < 2 / 100 && map['RI'] > 0) &&
        ((map['RN'] > 0) && (map['RN'] < (20 / 100)))) {
      newScores = (2 +
          (2 * (map['RI'] / (2 / 100))) +
          (map['RN'] / (20 / 100)) -
          ((map['RI'] * map['RN']) / ((2 / 100) * (20 / 100))));
    } else if ((map['RI'] == 0) &&
        (map['RN'] == 0) &&
        (map['RL'] >= (70 / 100))) {
      newScores = 2;
    } else if ((map['RI'] == 0) &&
        (map['RN'] == 0) &&
        (map['RL'] < (70 / 100))) {
      newScores = ((2 * map['RL']) / (70 / 100));
    }

    return newScores;
  }

  static double f11() {
    double newScores;
    double newPGBLK;

    newPGBLK = (((map['NDGB'] + map['NDLK']) / map['NDTPS']) * (100 / 100));
    map['PGBLK'] = newPGBLK;

    if (map['PGBLK'] >= (70 / 100)) {
      newScores = 4;
    } else if (map['PGBLK'] < (70 / 100)) {
      newScores = ((2 + (20 * map['PGBLK'])) / 7);
    }

    return newScores;
  }

  static double f12() {
    double newScores;
    double newPGBLK;

    newPGBLK = (((map['NDGB'] + map['NDLK']) / map['NDTPS']) * (100 / 100));
    map['PGBLK'] = newPGBLK;
    
    if ((map['NDGB'] >= 2) && (map['PGBLK'] >= (70 / 100))) {
      newScores = 4;
    } else if ((map['NDGB'] >= 2) && (map['PGBLK'] < (70 / 100))) {
      newScores = ((2 + (20 * map['PGBLK'])) / 7);
    } else {
      // NDGB < 2
      newScores = 0;
    }

    return newScores;
  }

  static double f13() {
    double newScores;
    double newPGB;
    
    newPGB = ((map['NDGB'] / map['NDTPS']) * (100 / 100));
    map['PGB'] = newPGB;
    
    if ((map['NDGB'] >= 2) && (map['PGB'] >= (70 / 100))) {
      newScores = 4;
    } else if ((map['NDGB'] >= 2) && (map['PGB'] < (70 / 100))) {
      newScores = ((2 + (20 * map['PGB'])) / 7);
    } else {
      // NDGB < 2
      newScores = 0;
    }

    return newScores;
  }

  static double f15() {
    double newScores;
    double newRDPS;
    
    newRDPS = (map['NDT'] / map['NPS']);
    map['RDPS'] = newRDPS;
    
    if (map['RDPS'] >= 10) {
      newScores = 4;
    } else if ((map['RDPS'] >= 5) && (map['RDPS'] < 10)) {
      newScores = ((2 * map['RDPS']) / 5);
    } else {
      // RDPS < 5
      newScores = 0;
    }

    return newScores;
  }

  static double f16() {
    double newScores;
    double newPDTT;
    
    newPDTT = (((map['NDTT'] / map['NDT']) / map['NDTT']) * (100 / 100));
    map['PDTT'] = newPDTT;
    
    if (map['PDTT'] >= (10 / 100)) {
      newScores = 4;
    } else if ((map['PDTT'] > (10 / 100)) && (map['PDTT']) <= (40 / 100)) {
      newScores = ((14 - (20 * map['PDTT'])) / 3);
    } else {
      // PDTT > 40%
      newScores = 0;
    }

    return newScores;
  }

  static double f17() {
    double newScores;
    
    newScores = ((map['A'] + (2 * map['B'])) / 3);
    map['N2'] = newScores;

    return newScores;
  }

  static double f18() {
    double newScores;
    double newRL;
    double newRN;
    double newRI;
    
    newRL =
        (((map['NA1'] + map['NB1'] + map['NC1']) / map['NM']) * (100 / 100));
    newRN = (((map['NA2'] + map['NA3'] + map['NB2'] + map['NC2']) / map['NM']) *
        (100 / 100));
    newRI =
        (((map['NA4'] + map['NB3'] + map['NC3']) / map['NM']) * (100 / 100));

    map['RL'] = newRL;
    map['RN'] = newRN;
    map['RI'] = newRI;

    if (map['RI'] >= (3 / 100)) {
      newScores = 4;
    } else if ((map['RI'] < (3 / 100)) && (map['RN'] >= (30 / 100))) {
      newScores = (3 + (map['RI'] / (3 / 100)));
    } else if (((map['RI'] < (3 / 100)) && (map['RI'] > 0)) &&
        ((map['RN'] > 0) && (map['RN'] < (30 / 100)))) {
      newScores = (2 +
          (2 * (map['RI'] / (3 / 100))) +
          (map['RN'] / (30 / 100)) -
          ((map['RI'] * map['RN']) / ((3 / 100) * (30 / 100))));
    } else if ((map['RI'] == 0) &&
        (map['RN'] == 0) &&
        (map['RL'] >= (90 / 100))) {
      newScores = 2;
    } else if ((map['RI'] == 0) &&
        (map['RN'] == 0) &&
        (map['RL'] < (90 / 100))) {
      newScores = ((2 * map['RL']) / (90 / 100));
    }

    return newScores;
  }

  static double f19() {
    double newScores;
    
    newScores = ((map['A'] + (2 * map['B'])) / 3);
    map['N3'] = newScores;

    return newScores;
  }

  static double f20() {
    double newScores;
    double newNSA;

    newNSA = (((4 * map['NUnggul']) + (3.5 * map['NA']) + (3 * map['NBaik_Sekali']) + (2.5 * map['NB']) + (2 * map['NBaik']) + (1.5 * map['NC'])) / (map['NUnggul'] + map['NA'] + map['NBaik_Sekali'] + map['NB'] + map['NBaik'] + map['NC'] + map['NK']));
    map['NSA'] = newNSA;

    if (map['NSA'] >= 3.50) {
      newScores = 4;
    } else if (map['NSA'] < 3.50) {
      newScores = (map['NSA'] + 0.5);
    }

    return newScores;
  }

  static double f21() {
    double newScores;
    double newRL;
    double newRN;
    double newRI;
    
    newRL = (map['NA1'] / map['NDT']);
    newRN = ((map['NA2'] + map['NA3']) / map['NDT']);
    newRI = (map['NA4'] / map['NDT']);

    map['RL'] = newRL;
    map['RN'] = newRN;
    map['RI'] = newRI;

    if (map['RI'] >= 0.1) {
      newScores = 4;
    } else if ((map['RI'] < 0.1) && (map['RN'] >= 1)) {
      newScores = (3 + (map['RI'] + 0.1));
    } else if ((map['RI'] > 0 && map['RI'] < 0.1) && (map['RN'] > 0 && map['RN'] < 1)) {
      newScores = (2 + (2 * (map['RI'] / 0.1)) + (map['RN'] / 1) - ((map['RI'] * map['RN']) / (0.1 * 1)));
    } else if ((map['RI'] == 0) && (map['RN'] == 0) && (map['RL'] >= 2)) {
      newScores = 2;
    } else if ((map['RI'] == 0) && (map['RN'] == 0) && (map['RL'] < 2)) {
      newScores = ((2 * map['RL']) / 2);
    }

    return newScores;
  }

  static double f22() {
    double newScores;
    double newRL;
    double newRN;
    double newRI;
    
    newRL = (map['NA1'] / map['NDT']);
    newRN = ((map['NA2'] + map['NA3']) / map['NDT']);
    newRI = (map['NA4'] / map['NDT']);

    map['RL'] = newRL;
    map['RN'] = newRN;
    map['RI'] = newRI;

    if (map['RI'] >= 0.05) {
      newScores = 4;
    } else if ((map['RI'] < 0.05) && (map['RN'] >= 0.5)) {
      newScores = (3 + (map['RI'] + 0.05));
    } else if ((map['RI'] > 0 && map['RI'] < 0.05) && (map['RN'] > 0 && map['RN'] < 0.5)) {
      newScores = (2 + (2 * (map['RI'] / 0.05)) + (map['RN'] / 0.5) - ((map['RI'] * map['RN']) / (0.05 * 0.5)));
    } else if ((map['RI'] == 0) && (map['RN'] == 0) && (map['RL'] >= 2)) {
      newScores = 2;
    } else if ((map['RI'] == 0) && (map['RN'] == 0) && (map['RL'] < 2)) {
      newScores = ((2 * map['RL']) / 2);
    }

    return newScores;
  }

  static double f23() {
    double newScores;

    newScores = map['A'];
    
    return newScores;
  }

  static double f24() {
    double newScores;

    newScores = map['B'];
    
    return newScores;
  }

  static String getAccreditation() {
   return 'TERAKREDITASI UNGGUL'; 
  }
}
