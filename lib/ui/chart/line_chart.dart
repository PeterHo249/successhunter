import 'package:flutter/material.dart';
import 'package:successhunter/model/chart_data.dart';
import 'package:fcharts/fcharts.dart';

class CustomLineChart extends StatelessWidget {
  final List<TaskCountPerDate> data;
  final double height;
  final double width;

  CustomLineChart({
    @required this.data,
    this.height: 100.0,
    this.width: 100.0,
  });

  List<Line<TaskCountPerDate, String, int>> generateData() {
    List<Line<TaskCountPerDate, String, int>> lines =
        List<Line<TaskCountPerDate, String, int>>();

    var xAxis = ChartAxis<String>();
    var yAxis = ChartAxis<int>();

    lines.add(
      Line<TaskCountPerDate, String, int>(
        data: data,
        xFn: (datum) => datum.date.toString(),
        yFn: (datum) => datum.attainedCount,
        xAxis: xAxis,
        yAxis: yAxis,
        marker: MarkerOptions(
          paint: PaintOptions.fill(
            color: Colors.green,
          ),
        ),
        stroke: PaintOptions.stroke(
          color: Colors.green,
        ),
      ),
    );
    lines.add(
      Line<TaskCountPerDate, String, int>(
        data: data,
        xFn: (datum) => datum.date.toString(),
        yFn: (datum) => datum.doingCount,
        xAxis: xAxis,
        yAxis: yAxis,
        marker: MarkerOptions(
          paint: PaintOptions.fill(
            color: Colors.amber,
          ),
        ),
        stroke: PaintOptions.stroke(
          color: Colors.amber,
        ),
      ),
    );
    lines.add(
      Line<TaskCountPerDate, String, int>(
        data: data,
        xFn: (datum) => datum.date.toString(),
        yFn: (datum) => datum.failedCount,
        xAxis: xAxis,
        yAxis: yAxis,
        marker: MarkerOptions(
          paint: PaintOptions.fill(
            color: Colors.red,
          ),
        ),
        stroke: PaintOptions.stroke(
          color: Colors.red,
        ),
      ),
    );

    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: LineChart(
        lines: generateData(),
      ),
    );
  }
}
