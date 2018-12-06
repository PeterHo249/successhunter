import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:successhunter/style/theme.dart' as Theme;

class PieChart extends StatefulWidget {
  final List<ChartEntry> data;
  final double size;
  final String holeLabel;

  PieChart({@required this.data, @required this.size, this.holeLabel});

  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  CircularStackEntry data;

  @override
  void initState() {
    super.initState();
    data = CircularStackEntry(widget.data
        .map(
          (entry) => CircularSegmentEntry(
                entry.value,
                entry.color,
              ),
        )
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCircularChart(
      size: Size(widget.size, widget.size),
      initialChartData: [data],
      key: GlobalKey<AnimatedCircularChartState>(),
      duration: Duration(milliseconds: 500),
      holeLabel: widget.holeLabel ?? 'Today\nWork',
      labelStyle: Theme.contentStyle.copyWith(color: Colors.white),
      chartType: CircularChartType.Radial,
    );
  }
}

class ChartEntry {
  final double value;
  final Color color;

  ChartEntry({this.value, this.color});
}
