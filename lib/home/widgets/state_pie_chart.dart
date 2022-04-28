import 'package:danger_zone_alert/models/state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// This is  used to display pie chart of total crimes cases in each state of Malaysia
class StatePieChart extends StatelessWidget {
  List<StateInfo> states;
  int totalCrimeCount;
  bool isBackground;

  StatePieChart(
      {Key? key,
      required this.states,
      required this.totalCrimeCount,
      required this.isBackground})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
          pieTouchData: PieTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: isBackground ? 60 : 70,
          sections: chartData(totalCrimeCount)),
    );
  }

  List<PieChartSectionData> chartData(int totalCrimeCount) {
    List<PieChartSectionData> pieChartData = [];

    for (StateInfo state in states) {
      double fontSize = isBackground ? 20.0 : 0.0;
      double radius = 75.0;

      // Calculate the percentage of the total crime of the state
      String percentage =
          (state.totalCrime / totalCrimeCount * 100).round().toString();

      pieChartData.add(PieChartSectionData(
        titlePositionPercentageOffset: 0.6,
        color: isBackground ? state.color.withOpacity(0.6) : state.color,
        value: state.totalCrime.toDouble(),
        title: percentage + '%\n',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, color: Colors.white),
      ));
    }

    return pieChartData;
  }
}
