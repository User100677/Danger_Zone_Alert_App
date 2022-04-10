import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class piechart extends StatefulWidget {
  piechart(
      {Key? key,
      required this.title,
      required this.robbery,
      required this.rape,
      required this.injury,
      required this.murder})
      : super(key: key);

  final String title;
  final int robbery, rape, murder, injury; 

  @override
  _piechartState createState() => _piechartState(robbery, rape, murder, injury);
}

late List<StateInfo> _chartData;
late TooltipBehavior _tooltipBehavior;

class _piechartState extends State<piechart> {
  late int robbery,rape,murder,injury;

_piechartState(this.robbery, this.rape, this.murder, this.injury);
  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _chartData = getChartData();
    return SafeArea(
        child: Scaffold(
            body: SfCircularChart(
      title:
          ChartTitle(text: 'State Information'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        PieSeries<StateInfo, String>(
            dataSource: _chartData,
            xValueMapper: (StateInfo data, _) => data.crime,
            yValueMapper: (StateInfo data, _) => data.amount,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true)
      ],
    )));
  }

  List<StateInfo> getChartData() {
    final List<StateInfo> chartData = [
      StateInfo('Causing Injury', injury),
      StateInfo('Robbery', robbery),
      StateInfo('Murder', murder),
      StateInfo('Rape', rape),
    ];
    return chartData;
  }
}

class StateInfo {
  StateInfo(this.crime, this.amount);
  final String crime;
  final int amount ;
}