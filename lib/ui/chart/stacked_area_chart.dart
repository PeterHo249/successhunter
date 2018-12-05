import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StackedAreaChart extends StatelessWidget {
  final List<TaskCountPerDate> data;
  final bool animate;
  final double height;
  final double width;

  StackedAreaChart({@required this.data, this.animate: true, this.height: 100.0, this.width: 100.0});

  List<charts.Series<TaskCountPerType, int>> _convertDataToSeriesList() {
    final doingTaskData = <TaskCountPerType>[];
    final attainedTaskData = <TaskCountPerType>[];
    final failedTaskData = <TaskCountPerType>[];

    for (int i = 0; i < data.length; i++) {
      doingTaskData.add(
        TaskCountPerType(
          date: data[i].date,
          value: data[i].doingCount,
        ),
      );
      attainedTaskData.add(
        TaskCountPerType(
          date: data[i].date,
          value: data[i].attainedCount,
        ),
      );
      failedTaskData.add(
        TaskCountPerType(
          date: data[i].date,
          value: data[i].failedCount,
        ),
      );
    }

    return <charts.Series<TaskCountPerType, int>>[
      charts.Series<TaskCountPerType, int>(
        id: 'Doing',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (TaskCountPerType taskCount, _) => taskCount.date,
        measureFn: (TaskCountPerType taskCount, _) => taskCount.value,
        data: doingTaskData,
      ),
      charts.Series<TaskCountPerType, int>(
        id: 'Attained',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TaskCountPerType taskCount, _) => taskCount.date,
        measureFn: (TaskCountPerType taskCount, _) => taskCount.value,
        data: attainedTaskData,
      ),
      charts.Series<TaskCountPerType, int>(
        id: 'Failed',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TaskCountPerType taskCount, _) => taskCount.date,
        measureFn: (TaskCountPerType taskCount, _) => taskCount.value,
        data: failedTaskData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SizedBox(
        height: height,
        width: width,
        child: charts.LineChart(
          _convertDataToSeriesList(),
          defaultRenderer: charts.LineRendererConfig(
            includeArea: true,
            stacked: true,
          ),
          animate: animate,
        ),
      ),
    );
  }
}

class TaskCountPerType {
  final int date;
  final int value;

  TaskCountPerType({
    this.date,
    this.value: 0,
  });
}

class TaskCountPerDate {
  final int date;
  final int doingCount;
  final int attainedCount;
  final int failedCount;

  TaskCountPerDate({
    @required this.date,
    this.doingCount: 0,
    this.attainedCount: 0,
    this.failedCount: 0,
  });
}
