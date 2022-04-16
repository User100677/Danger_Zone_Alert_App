import 'package:danger_zone_alert/widget_view/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StateInfo {
  final String crime;
  final int amount;

  StateInfo(this.crime, this.amount);
}

late List<StateInfo> _chartData;
late TooltipBehavior _tooltipBehavior;

class StateInfoPieChart extends StatefulWidget {
  final String title;
  final int robbery, rape, murder, injury;

  const StateInfoPieChart(
      {Key? key,
      required this.title,
      required this.robbery,
      required this.rape,
      required this.injury,
      required this.murder})
      : super(key: key);

  @override
  _StateInfoPieChartController createState() => _StateInfoPieChartController();
}

class _StateInfoPieChartController extends State<StateInfoPieChart> {
  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<StateInfo> getChartData() {
    final List<StateInfo> chartData = [
      StateInfo('Causing Injury', widget.injury),
      StateInfo('Robbery', widget.robbery),
      StateInfo('Murder', widget.murder),
      StateInfo('Rape', widget.rape),
    ];
    return chartData;
  }

  @override
  Widget build(BuildContext context) => _StateInfoPieChartView(this);
}

class _StateInfoPieChartView
    extends WidgetView<StateInfoPieChart, _StateInfoPieChartController> {
  const _StateInfoPieChartView(_StateInfoPieChartController state)
      : super(state);

  @override
  Widget build(BuildContext context) {
    _chartData = state.getChartData();
    return SfCircularChart(
      title: ChartTitle(text: 'State Information'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        PieSeries<StateInfo, String>(
            dataSource: _chartData,
            xValueMapper: (StateInfo data, _) => data.crime,
            yValueMapper: (StateInfo data, _) => data.amount,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true),
      ],
    );
  }
}
