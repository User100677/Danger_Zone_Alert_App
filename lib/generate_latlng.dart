import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

List<Map<dynamic, dynamic>> result = [];

void main() async {
  await _loadCSV();
}

_loadCSV() async {
  List<List<dynamic>> _data = [];

  var input = File('assets/dataset.csv').openRead();
  _data = await input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();

  CsvModel csvModel = CsvModel(_data);
  csvModel.sumCrimeState();
}

class CsvModel {
  List<int> yearData = [];
  List<String> stateData = [];
  List<String> contingentData = [];
  List<String> typeOfCrimeData = [];
  List<int> numberOfCrimeData = [];
  List<Map<dynamic, dynamic>> stateCrimeData = [];

  List<String> uniqueState = [];
  List<num> uniqueNumCrime = [];

  CsvModel(List<List<dynamic>> data) {
    for (int i = 1; i < data.length; i++) {
      yearData.add(data[i][0]);
      stateData.add(data[i][1]);
      contingentData.add(data[i][2]);
      typeOfCrimeData.add(data[i][3]);
      numberOfCrimeData.add(data[i][4]);

      var map = {};
      map['state'] = data[i][1];
      map['numCrime'] = data[i][4];
      stateCrimeData.add(map);
    }
    sumCrimeState();
    calculateResult();
  }

  sumCrimeState() {
    // Store each unique state
    uniqueState = stateData.toSet().toList();
    // Generate a size of uniqueState.length of 0
    uniqueNumCrime = List<num>.generate(uniqueState.length, (index) => 0);

    for (int i = 0; i < stateCrimeData.length; i++) {
      uniqueState.forEach((state) {
        if (stateCrimeData[i]['state'] == state) {
          int index = uniqueState.indexOf(state);
          uniqueNumCrime[index] += stateCrimeData[i]['numCrime'];
        }
      });
    }
  }

  calculateResult() {
    for (int i = 0; i < uniqueState.length; i++) {
      var map = {};
      map['state'] = uniqueState[i];
      map['totalCrime'] = uniqueNumCrime[i];
      result.add(map);
    }

    for (int i = 0; i < result.length; i++) {
      print(result[i]['state']);
      print(result[i]['totalCrime']);
    }
  }
}

/*

[Year, State, Contingent/ PDRM District, Type of Crime, Number of Crime],
[2015, Johor, Batu Pahat, Murder, 2]

*/
