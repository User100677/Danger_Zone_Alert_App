/// Donut chart with labels example. This is a simple pie chart with a hole in
/// the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
 // final int murder, robbery, injury, rape;

  DonutAutoLabelChart(this.seriesList,
      {this.animate = true});

      /// Creates a [PieChart] with sample data and no transition.
  factory DonutAutoLabelChart.withSampleData(robbery, rape, injury,murder) 
  {
    return new DonutAutoLabelChart(
      _createData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CrimeData, int>> _createData() {
    final data = [
      new CrimeData('robbery', 100),
      new CrimeData('rape', 50),
    ];

    return [
      new charts.Series<CrimeData, int>(
        id: 'Crime Info',
        domainFn: (CrimeData crime, _) => crime.amount,
        measureFn: (CrimeData crime, _) => crime.amount,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CrimeData row, _) => '${row.crime}: ${row.amount}',
      )
    ];
  }
}

/// Sample linear data type.
class CrimeData {
  final String crime;
  final int amount;

  CrimeData(this.crime, this.amount);
}
