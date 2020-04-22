import 'package:serializable/serializable.dart';

import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';

part 'formula.g.dart';

@serializable
class Formula extends _$FormulaSerializable {
  static final Formula _formula = Formula._internal();

  factory Formula() {
    return _formula;
  }

  Formula._internal();

  Map<String, dynamic> mapVariable = {};

  List<MappingIndicatorModel> accreditate(
    Map<String, dynamic> map,
    List<MappingIndicatorModel> lmap,
  ) {
    mapVariable = map;

    var newlmap = lmap;
    for (int i = 0; i < newlmap.length; i++) {
      newlmap[i].indicatorValue = mappingFormula(
            newlmap[i].formula,
          ) ??
          0.0;
    }
    mapVariable = {};
    return newlmap;
  }

  mappingFormula(String formula) {
    return Formula()[formula]();
  }

  double f1() {
    double newScores;

    if (mapVariable['NDTPS'] >= 12) {
      newScores = 4;
    } else if (mapVariable['NDTPS'] < 12 && mapVariable['NDTPS'] >= 3) {
      newScores = (2 * mapVariable['NDTPS']) / 9;
    } else {
      // NDTPS < 3
      newScores = 0;
    }

    return newScores;
  }

  double f2() {
    double newScores;

    if (mapVariable['NDTPS'] >= 6) {
      newScores = 4;
    } else if (mapVariable['NDTPS'] < 6 && mapVariable['NDTPS'] >= 3) {
      newScores = (2 * mapVariable['NDTPS']) / 3;
    } else {
      // NDTPS < 3
      newScores = 0;
    }

    return newScores;
  }

  double f3() {
    double newScores;
    double newPDS3;

    newPDS3 = (((mapVariable['NDS3'] / mapVariable['NDTPS']) * 100) / 100);
    mapVariable['PDS3'] = newPDS3;

    if (mapVariable['PDS3'] >= (50 / 100)) {
      newScores = 4;
    } else if (mapVariable['PDS3'] < (50 / 100)) {
      newScores = (2 + (4 * mapVariable['PDS3']));
    }

    return newScores;
  }

  double f4() {
    double newScores;
    double newPGBLKL;

    newPGBLKL =
        (((mapVariable['NDGB'] + mapVariable['NDLK'] + mapVariable['NDL']) /
                    mapVariable['NDTPS']) *
                100) /
            100;
    mapVariable['PGBLKL'] = newPGBLKL;

    if (mapVariable['PGBLKL'] >= (70 / 100)) {
      newScores = 4;
    } else if (mapVariable['PGBLKL'] < (70 / 100)) {
      newScores = (2 + ((20 * mapVariable['PGBLKL']) / 7));
    }

    return newScores;
  }

  double f5() {
    double newScores;

    newScores =
        ((mapVariable['A'] + (2 * mapVariable['B']) + (2 * mapVariable['C'])) /
            5);
    mapVariable['N1'] = newScores;

    return newScores;
  }

  double f6() {
    double newScores;
    double newPJ;
    double newPrmin;
    double formula;

    newPJ = ((mapVariable['NJtotal'] / mapVariable['NLtotal']) * 100) / 100;

    if ((mapVariable['NLtotal'] >= 300)) {
      newPrmin = 30 / 100;
    } else if (mapVariable['NLtotal'] < 300) {
      newPrmin =
          (((50 / 100) - ((mapVariable['NLtotal'] / 300) * (20 / 100))) * 100) /
              100;
    }

    mapVariable['WT'] =
        ((mapVariable['WT1'] + mapVariable['WT2'] + mapVariable['WT3']) / 3);

    if (mapVariable['WT'] < 3) {
      formula = 4;
    } else if (mapVariable['WT'] >= 3 && mapVariable['WT'] <= 6) {
      formula = ((24 - (4 * mapVariable['WT'])) / 3);
    } else if (mapVariable['WT'] > 6) {
      formula = 0;
    }

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    mapVariable['PJ'] = newPJ;
    mapVariable['Prmin'] = newPrmin;

    return newScores;
  }

  double f7() {
    double newScores;
    double newPJ;
    double newPrmin;
    double formula;

    newPJ = ((mapVariable['NJtotal'] / mapVariable['NLtotal']) * 100) / 100;

    if ((mapVariable['NLtotal'] >= 300)) {
      newPrmin = 30 / 100;
    } else if (mapVariable['NLtotal'] < 300) {
      newPrmin =
          (((50 / 100) - ((mapVariable['NLtotal'] / 300) * (20 / 100))) * 100) /
              100;
    }

    mapVariable['WT'] =
        ((mapVariable['WT1'] + mapVariable['WT2'] + mapVariable['WT3']) / 3);

    if (mapVariable['WT'] < 6) {
      formula = 4;
    } else if (mapVariable['WT'] >= 6 && mapVariable['WT'] <= 18) {
      formula = ((18 - mapVariable['WT']) / 3);
    } else if (mapVariable['WT'] > 18) {
      formula = 0;
    }

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    mapVariable['PJ'] = newPJ;
    mapVariable['Prmin'] = newPrmin;

    return newScores;
  }

  double f8() {
    double newScores;
    double newPJ;
    double newPrmin;
    double formula;

    newPJ = ((mapVariable['NJtotal'] / mapVariable['NLtotal']) * 100) / 100;

    if ((mapVariable['NLtotal'] >= 300)) {
      newPrmin = 30 / 100;
    } else if (mapVariable['NLtotal'] < 300) {
      newPrmin =
          (((50 / 100) - ((mapVariable['NLtotal'] / 300) * (20 / 100))) * 100) /
              100;
    }

    mapVariable['PBS'] =
        ((mapVariable['PBS1'] + mapVariable['PBS2'] + mapVariable['PBS3']) /
                3) /
            100;

    if (mapVariable['PBS'] >= (60 / 100)) {
      formula = 4;
    } else if (mapVariable['PBS'] < (60 / 100)) {
      formula = (20 * mapVariable['PBS']) / 3;
    }

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    mapVariable['PJ'] = newPJ;
    mapVariable['Prmin'] = newPrmin;

    return newScores;
  }

  double f9() {
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

    newPJ = ((mapVariable['NJItotal'] / mapVariable['NLtotal']) * 100) / 100;

    if ((mapVariable['NLtotal'] >= 300)) {
      newPrmin = 30 / 100;
    } else if (mapVariable['NLtotal'] < 300) {
      newPrmin =
          (((50 / 100) - ((mapVariable['NLtotal'] / 300) * (20 / 100))) * 100) /
              100;
    }

    newTKG = (((4 * mapVariable['G1']) +
            (3 * mapVariable['G2']) +
            (2 * mapVariable['G3']) +
            mapVariable['G4'])) /
        100;
    newTKH = (((4 * mapVariable['H1']) +
            (3 * mapVariable['H2']) +
            (2 * mapVariable['H3']) +
            mapVariable['H4'])) /
        100;
    newTKI = (((4 * mapVariable['I1']) +
            (3 * mapVariable['I2']) +
            (2 * mapVariable['I3']) +
            mapVariable['I4'])) /
        100;
    newTKJ = (((4 * mapVariable['J1']) +
            (3 * mapVariable['J2']) +
            (2 * mapVariable['J3']) +
            mapVariable['J4'])) /
        100;
    newTKK = (((4 * mapVariable['K1']) +
            (3 * mapVariable['K2']) +
            (2 * mapVariable['K3']) +
            mapVariable['K4'])) /
        100;
    newTKL = (((4 * mapVariable['L1']) +
            (3 * mapVariable['L2']) +
            (2 * mapVariable['L3']) +
            mapVariable['L4'])) /
        100;
    newTKM = (((4 * mapVariable['M1']) +
            (3 * mapVariable['M2']) +
            (2 * mapVariable['M3']) +
            mapVariable['M4'])) /
        100;

    formula =
        (newTKG + newTKH + newTKI + newTKJ + newTKK + newTKL + newTKM) / 7;

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    mapVariable['PJ'] = newPJ;
    mapVariable['Prmin'] = newPrmin;
    mapVariable['TKG'] = newTKG;
    mapVariable['TKH'] = newTKH;
    mapVariable['TKI'] = newTKI;
    mapVariable['TKJ'] = newTKJ;
    mapVariable['TKK'] = newTKK;
    mapVariable['TKL'] = newTKL;
    mapVariable['TKM'] = newTKM;
    mapVariable['TKtotal'] = formula;

    return newScores;
  }

  double f10() {
    double newScores;
    double newRL;
    double newRN;
    double newRI;

    newRL = (((mapVariable['NA1'] + mapVariable['NB1'] + mapVariable['NC1']) /
            mapVariable['NM']) *
        (100 / 100));
    newRN = (((mapVariable['NA2'] +
                mapVariable['NA3'] +
                mapVariable['NB2'] +
                mapVariable['NC2']) /
            mapVariable['NM']) *
        (100 / 100));
    newRI = (((mapVariable['NA4'] + mapVariable['NB3'] + mapVariable['NC3']) /
            mapVariable['NM']) *
        (100 / 100));

    mapVariable['RL'] = newRL;
    mapVariable['RN'] = newRN;
    mapVariable['RI'] = newRI;

    if (mapVariable['RI'] >= (2 / 100)) {
      newScores = 4;
    } else if ((mapVariable['RI'] < (2 / 100)) &&
        (mapVariable['RN'] >= (20 / 100))) {
      newScores = (3 + (mapVariable['RI'] / (2 / 100)));
    } else if ((mapVariable['RI'] < 2 / 100 && mapVariable['RI'] > 0) &&
        ((mapVariable['RN'] > 0) && (mapVariable['RN'] < (20 / 100)))) {
      newScores = (2 +
          (2 * (mapVariable['RI'] / (2 / 100))) +
          (mapVariable['RN'] / (20 / 100)) -
          ((mapVariable['RI'] * mapVariable['RN']) / ((2 / 100) * (20 / 100))));
    } else if ((mapVariable['RI'] == 0) &&
        (mapVariable['RN'] == 0) &&
        (mapVariable['RL'] >= (70 / 100))) {
      newScores = 2;
    } else if ((mapVariable['RI'] == 0) &&
        (mapVariable['RN'] == 0) &&
        (mapVariable['RL'] < (70 / 100))) {
      newScores = ((2 * mapVariable['RL']) / (70 / 100));
    }

    return newScores;
  }

  double f11() {
    double newScores;
    double newPGBLK;

    newPGBLK =
        (((mapVariable['NDGB'] + mapVariable['NDLK']) / mapVariable['NDTPS']) *
                100) /
            100;
    mapVariable['PGBLK'] = newPGBLK;

    if (mapVariable['PGBLK'] >= (70 / 100)) {
      newScores = 4;
    } else if (mapVariable['PGBLK'] < (70 / 100)) {
      newScores = (2 + ((20 * mapVariable['PGBLK']) / 7));
    }

    return newScores;
  }

  double f12() {
    double newScores;
    double newPGBLK;

    newPGBLK =
        (((mapVariable['NDGB'] + mapVariable['NDLK']) / mapVariable['NDTPS']) *
                100) /
            100;
    mapVariable['PGBLK'] = newPGBLK;

    if ((mapVariable['NDGB'] >= 2) && (mapVariable['PGBLK'] >= 70)) {
      newScores = 4;
    } else if ((mapVariable['NDGB'] >= 2) && (mapVariable['PGBLK'] < 70)) {
      newScores = ((2 + (20 * mapVariable['PGBLK'])) / 7);
    } else {
      // NDGB < 2
      newScores = 0;
    }

    return newScores;
  }

  double f13() {
    double newScores;
    double newPGB;

    newPGB = ((mapVariable['NDGB'] / mapVariable['NDTPS']) * 100) / 100;
    mapVariable['PGB'] = newPGB;

    if ((mapVariable['NDGB'] >= 2) && (mapVariable['PGB'] >= 70)) {
      newScores = 4;
    } else if ((mapVariable['NDGB'] >= 2) && (mapVariable['PGB'] < 70)) {
      newScores = ((2 + (20 * mapVariable['PGB'])) / 7);
    } else {
      // NDGB < 2
      newScores = 0;
    }

    return newScores;
  }

  double f15() {
    double newScores;
    double newRDPS;

    newRDPS = (mapVariable['NDT'] / mapVariable['NPS']);
    mapVariable['RDPS'] = newRDPS;

    if (mapVariable['RDPS'] >= 10) {
      newScores = 4;
    } else if ((mapVariable['RDPS'] >= 5) && (mapVariable['RDPS'] < 10)) {
      newScores = ((2 * mapVariable['RDPS']) / 5);
    } else {
      // RDPS < 5
      newScores = 0;
    }

    return newScores;
  }

  double f16() {
    double newScores;
    double newPDTT;

    newPDTT = (((mapVariable['NDTT'] / (mapVariable['NDTT'] + mapVariable['NDT']))) * 100) / 100;
    mapVariable['PDTT'] = newPDTT;

    if (mapVariable['PDTT'] <= (10 / 100)) {
      newScores = 4;
    } else if ((mapVariable['PDTT'] > (10 / 100)) &&
        (mapVariable['PDTT']) <= (40 / 100)) {
      newScores = ((14 - (20 * mapVariable['PDTT'])) / 3);
    } else {
      // PDTT > 40%
      newScores = 0;
    }

    return newScores;
  }

  double f17() {
    double newScores;

    newScores = ((mapVariable['A'] + (2 * mapVariable['B'])) / 3);
    mapVariable['N2'] = newScores;

    return newScores;
  }

  double f18() {
    double newScores;
    double newRL;
    double newRN;
    double newRI;

    newRL = (((mapVariable['NA1'] + mapVariable['NB1'] + mapVariable['NC1']) /
            mapVariable['NM']) *
        (100 / 100));
    newRN = (((mapVariable['NA2'] +
                mapVariable['NA3'] +
                mapVariable['NB2'] +
                mapVariable['NC2']) /
            mapVariable['NM']) *
        (100 / 100));
    newRI = (((mapVariable['NA4'] + mapVariable['NB3'] + mapVariable['NC3']) /
            mapVariable['NM']) *
        (100 / 100));

    mapVariable['RL'] = newRL;
    mapVariable['RN'] = newRN;
    mapVariable['RI'] = newRI;

    if (mapVariable['RI'] >= (3 / 100)) {
      newScores = 4;
    } else if ((mapVariable['RI'] < (3 / 100)) &&
        (mapVariable['RN'] >= (30 / 100))) {
      newScores = (3 + (mapVariable['RI'] / (3 / 100)));
    } else if (((mapVariable['RI'] < (3 / 100)) && (mapVariable['RI'] > 0)) &&
        ((mapVariable['RN'] > 0) && (mapVariable['RN'] < (30 / 100)))) {
      newScores = (2 +
          (2 * (mapVariable['RI'] / (3 / 100))) +
          (mapVariable['RN'] / (30 / 100)) -
          ((mapVariable['RI'] * mapVariable['RN']) / ((3 / 100) * (30 / 100))));
    } else if ((mapVariable['RI'] == 0) &&
        (mapVariable['RN'] == 0) &&
        (mapVariable['RL'] >= (90 / 100))) {
      newScores = 2;
    } else if ((mapVariable['RI'] == 0) &&
        (mapVariable['RN'] == 0) &&
        (mapVariable['RL'] < (90 / 100))) {
      newScores = ((2 * mapVariable['RL']) / (90 / 100));
    }

    return newScores;
  }

  double f19() {
    double newScores;

    newScores = ((mapVariable['A'] + (2 * mapVariable['B'])) / 3);
    mapVariable['N3'] = newScores;

    return newScores;
  }

  double f20() {
    double newScores;
    double newNSA;

    newNSA = (((4 * mapVariable['NUnggul']) +
            (3.5 * mapVariable['NA']) +
            (3 * mapVariable['NBaik_Sekali']) +
            (2.5 * mapVariable['NB']) +
            (2 * mapVariable['NBaik']) +
            (1.5 * mapVariable['NC'])) /
        (mapVariable['NUnggul'] +
            mapVariable['NA'] +
            mapVariable['NBaik_Sekali'] +
            mapVariable['NB'] +
            mapVariable['NBaik'] +
            mapVariable['NC'] +
            mapVariable['NK']));
    mapVariable['NSA'] = newNSA;

    if (mapVariable['NSA'] >= 3.50) {
      newScores = 4;
    } else if (mapVariable['NSA'] < 3.50) {
      newScores = (mapVariable['NSA'] + 0.5);
    }

    return newScores;
  }

  double f21() {
    double newScores;
    double newRL;
    double newRN;
    double newRI;

    newRL = (mapVariable['NA1'] / mapVariable['NDT']);
    newRN = ((mapVariable['NA2'] + mapVariable['NA3']) / mapVariable['NDT']);
    newRI = (mapVariable['NA4'] / mapVariable['NDT']);

    mapVariable['RL'] = newRL;
    mapVariable['RN'] = newRN;
    mapVariable['RI'] = newRI;

    if (mapVariable['RI'] >= 0.1) {
      newScores = 4;
    } else if ((mapVariable['RI'] < 0.1) && (mapVariable['RN'] >= 1)) {
      newScores = (3 + (mapVariable['RI'] + 0.1));
    } else if ((mapVariable['RI'] > 0 && mapVariable['RI'] < 0.1) &&
        (mapVariable['RN'] > 0 && mapVariable['RN'] < 1)) {
      newScores = (2 +
          (2 * (mapVariable['RI'] / 0.1)) +
          (mapVariable['RN'] / 1) -
          ((mapVariable['RI'] * mapVariable['RN']) / (0.1 * 1)));
    } else if ((mapVariable['RI'] == 0) &&
        (mapVariable['RN'] == 0) &&
        (mapVariable['RL'] >= 2)) {
      newScores = 2;
    } else if ((mapVariable['RI'] == 0) &&
        (mapVariable['RN'] == 0) &&
        (mapVariable['RL'] < 2)) {
      newScores = ((2 * mapVariable['RL']) / 2);
    }

    return newScores;
  }

  double f22() {
    double newScores;
    double newRL;
    double newRN;
    double newRI;

    newRL = (mapVariable['NA1'] / mapVariable['NDT']);
    newRN = ((mapVariable['NA2'] + mapVariable['NA3']) / mapVariable['NDT']);
    newRI = (mapVariable['NA4'] / mapVariable['NDT']);

    mapVariable['RL'] = newRL;
    mapVariable['RN'] = newRN;
    mapVariable['RI'] = newRI;

    if (mapVariable['RI'] >= 0.05) {
      newScores = 4;
    } else if ((mapVariable['RI'] < 0.05) && (mapVariable['RN'] >= 0.5)) {
      newScores = (3 + (mapVariable['RI'] + 0.05));
    } else if ((mapVariable['RI'] > 0 && mapVariable['RI'] < 0.05) &&
        (mapVariable['RN'] > 0 && mapVariable['RN'] < 0.5)) {
      newScores = (2 +
          (2 * (mapVariable['RI'] / 0.05)) +
          (mapVariable['RN'] / 0.5) -
          ((mapVariable['RI'] * mapVariable['RN']) / (0.05 * 0.5)));
    } else if ((mapVariable['RI'] == 0) &&
        (mapVariable['RN'] == 0) &&
        (mapVariable['RL'] >= 2)) {
      newScores = 2;
    } else if ((mapVariable['RI'] == 0) &&
        (mapVariable['RN'] == 0) &&
        (mapVariable['RL'] < 2)) {
      newScores = ((2 * mapVariable['RL']) / 2);
    }

    return newScores;
  }

  double f23() {
    double newScores;

    newScores = mapVariable['A'];

    return newScores;
  }

  double f24() {
    double newScores;

    newScores = mapVariable['B'];

    return newScores;
  }

  double f25() {
    double newScores;

    newScores = mapVariable['C'];

    return newScores;
  }

  double f26() {
    double newScores;

    newScores = mapVariable['D'];

    return newScores;
  }

  double f27() {
    double newScores;

    newScores = mapVariable['E'];

    return newScores;
  }

  double f28() {
    double newScores;

    newScores = mapVariable['F'];

    return newScores;
  }

  double f29() {
    double newScores;
    double newPJ;
    double newPrmin;
    double formula;

    newPJ = ((mapVariable['NJtotal'] / mapVariable['NLtotal']) * 100) / 100;

    if ((mapVariable['NLtotal'] >= 300)) {
      newPrmin = 30 / 100;
    } else if (mapVariable['NLtotal'] < 300) {
      newPrmin =
          (((50 / 100) - ((mapVariable['NLtotal'] / 300) * (20 / 100))) * 100) /
              100;
    }

    mapVariable['PBS'] =
        ((mapVariable['PBS1'] + mapVariable['PBS2'] + mapVariable['PBS3']) / 3);

    if (mapVariable['PBS'] >= (80 / 100)) {
      formula = 4;
    } else if (mapVariable['PBS'] < (80 / 100)) {
      formula = (5 * mapVariable['PBS']);
    }

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    mapVariable['PJ'] = newPJ;
    mapVariable['Prmin'] = newPrmin;

    return newScores;
  }

  double f30() {
    double newScores;

    newScores = mapVariable['N'];

    return newScores;
  }

  double f31() {
    double newScores;

    newScores = mapVariable['O'];

    return newScores;
  }

  double f32() {
    double newScores;

    newScores =
        (mapVariable['NL1'] + mapVariable['NL2'] + mapVariable['NL3']);
    mapVariable['NLtotal'] = newScores;

    return newScores;
  }

  double f33() {
    double newScores;

    newScores =
        (mapVariable['NJ1'] + mapVariable['NJ2'] + mapVariable['NJ3']);
    mapVariable['NJtotal'] = newScores;

    return newScores;
  }

  double f34() {
    double newScores;

    newScores =
        (mapVariable['NJI1'] + mapVariable['NJI2'] + mapVariable['NJI3']);
    mapVariable['NJItotal'] = newScores;

    return newScores;
  }

  double f35() {
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

    newPJ = ((mapVariable['NJItotal'] / mapVariable['NLtotal']) * 100) / 100;

    if ((mapVariable['NLtotal'] >= 300)) {
      newPrmin = 30 / 100;
    } else if (mapVariable['NLtotal'] < 300) {
      newPrmin =
          (((50 / 100) - ((mapVariable['NLtotal'] / 300) * (20 / 100)))) / 100;
    }

    newTKG = (((4 * mapVariable['G1']) +
            (3 * mapVariable['G2']) +
            (2 * mapVariable['G3']) +
            mapVariable['G4'])) /
        100;
    newTKH = (((4 * mapVariable['H1']) +
            (3 * mapVariable['H2']) +
            (2 * mapVariable['H3']) +
            mapVariable['H4'])) /
        100;
    newTKI = (((4 * mapVariable['I1']) +
            (3 * mapVariable['I2']) +
            (2 * mapVariable['I3']) +
            mapVariable['I4'])) /
        100;
    newTKJ = (((4 * mapVariable['J1']) +
            (3 * mapVariable['J2']) +
            (2 * mapVariable['J3']) +
            mapVariable['J4'])) /
        100;
    newTKK = (((4 * mapVariable['K1']) +
            (3 * mapVariable['K2']) +
            (2 * mapVariable['K3']) +
            mapVariable['K4'])) /
        100;
    newTKL = (((4 * mapVariable['L1']) +
            (3 * mapVariable['L2']) +
            (2 * mapVariable['L3']) +
            mapVariable['L4'])) /
        100;
    newTKM = (((4 * mapVariable['M1']) +
            (3 * mapVariable['M2']) +
            (2 * mapVariable['M3']) +
            mapVariable['M4'])) /
        100;

    formula =
        (newTKG + newTKH + newTKI + newTKJ + newTKK + newTKL + newTKM) / 7;

    if (newPJ >= newPrmin) {
      newScores = formula;
    } else {
      newScores = ((newPJ / newPrmin) * formula);
    }

    mapVariable['PJ'] = newPJ;
    mapVariable['Prmin'] = newPrmin;
    mapVariable['TKG'] = newTKG;
    mapVariable['TKH'] = newTKH;
    mapVariable['TKI'] = newTKI;
    mapVariable['TKJ'] = newTKJ;
    mapVariable['TKK'] = newTKK;
    mapVariable['TKL'] = newTKL;
    mapVariable['TKM'] = newTKM;
    mapVariable['TKtotal'] = formula;

    return newScores;
  }

  String getAccreditation() {
    return 'TERAKREDITASI UNGGUL';
  }
}
