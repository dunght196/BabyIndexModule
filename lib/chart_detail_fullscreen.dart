import 'package:babyindexmodule/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';

import 'app_util.dart';
import 'build_chart_index.dart';
import 'color_util.dart';


class ChartDetailFullScreen extends StatefulWidget {
  final String title;
  final List<Entry> dataBelowLine;
  final List<Entry> dataTopLine;
  final List<Entry> dataIndex;
  final List<Entry> dataGuess;

  ChartDetailFullScreen({this.title, this.dataBelowLine, this.dataTopLine, this.dataIndex, this.dataGuess});


  @override
   _ChartDetailFullScreenState createState() => _ChartDetailFullScreenState(title, dataBelowLine, dataTopLine, dataIndex, dataGuess);
}

class _ChartDetailFullScreenState extends State<ChartDetailFullScreen> {
  final String title;
  final List<Entry> dataBelowLine;
  final List<Entry> dataTopLine;
  final List<Entry> dataIndex;
  final List<Entry> dataGuess;
  LineChartController lineChartController;

  _ChartDetailFullScreenState(this.title,this.dataBelowLine, this.dataTopLine, this.dataIndex, this.dataGuess);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _initControllerLineChart();
    _initLineChartData();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back, color: Colors.white),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 0,
                  child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.blue, size: 28),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                  )
              ),
              Expanded(
                  flex: 10,
                  child: Container(height: 350, child: LineChart(lineChartController))
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.red,
                width: 8,
                height: 8,
                margin: EdgeInsets.only(left: 110),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'Ngưỡng dưới',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Container(
                color: Colors.green,
                width: 8,
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'Ngưỡng trên',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Container(
                color: Colors.grey,
                width: 8,
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'Dự đoán',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Container(
                color: AppUtil.getColorExplain(title),
                width: 8,
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(title, style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _initControllerLineChart() {
    var desc = Description()..enabled = false;
    lineChartController = LineChartController(
        backgroundColor: Colors.transparent,
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..drawGridLines = (true)
            ..setLabelCount2(8, true)
            ..setValueFormatter(FormatXAxisValue(AppUtil.getSuffixYAxis(title)))
            ..typeface = Util.LIGHT;
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        legendSettingFunction: (legend, controller) {
          legend
            ..enabled = (false);
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..position = XAxisPosition.BOTTOM
            ..drawGridLines = (true)
            ..setValueFormatter(FormatXAxisValue("thg"))
            ..setLabelCount2(6, true)
            ..typeface = Util.LIGHT;
        },
        drawGridBackground: false,
        dragXEnabled: true,
        dragYEnabled: false,
        scaleXEnabled: true,
        scaleYEnabled: false,
        highLightPerTapEnabled: true,
        pinchZoomEnabled: false,
        doubleTapToZoomEnabled: true,
        description: desc);
  }

  void _initLineChartData() {
    List<Entry> values = List();
    List<Entry> values1 = List();
    List<Entry> values2 = List();
    List<Entry> values3 = List();

    LineDataSet set1;
    LineDataSet set2;
    LineDataSet set3;
    LineDataSet set4;

    values.addAll(dataBelowLine);
    values1.addAll(dataTopLine);
    values2.addAll(dataIndex);
    values3.addAll(dataGuess);

    set1 = LineDataSet(values, "DataSet 1");
    set1.setDrawValues(false);
    set1.setLineWidth(1);
    set1.setDrawCircles(false);
    set1.setColor1(ColorUtil.BELOW_LINE);
    set1.setHighlightEnabled(false);
    set1.setDrawFilled(true);
    // set color of filled area
    set1.setFillColor(ColorUtil.BELOW_LINE);
    set1.setFillAlpha(10);

    set2 = LineDataSet(values1, "DataSet 2");
    set2.setDrawValues(false);
    set2.setLineWidth(1);
    set2.setDrawCircles(false);
    set2.setColor1(ColorUtil.TOP_LINE);
    set2.setHighlightEnabled(false);
    set2.setDrawFilled(true);
    // set color of filled area
    set2.setFillColor(ColorUtil.TOP_LINE);
    set2.setFillAlpha(10);

    // create a dataset and give it a type
    set3 = LineDataSet(values2, "DataSet 3");
    set3.setDrawValues(true);
    set3.setValueFormatter(FormatDrawValue(AppUtil.getSuffixYAxis(title)));
    set3.setLineWidth(2);
    set3.setDrawCircleHole(false);
    set3.setHighLightColor(Colors.transparent);
    set3.setCircleSize(3);
    set3.setColor1( AppUtil.getColorExplain(title));
    set3.setCircleColor( AppUtil.getColorExplain(title));

    set3.enableDashedLine(10, 5, 0);
    set3.setFormLineWidth(1);
    set3.setFormLineDashEffect(DashPathEffect(10, 5, 0));
    set3.setFormSize(15);

    set4 = LineDataSet(values3, "DataSet 4");
    set4.setDrawValues(true);
    set4.setValueFormatter(FormatDrawValue(AppUtil.getSuffixYAxis(title)));
    set4.setLineWidth(2);
    set4.setDrawCircleHole(false);
    set4.setHighLightColor(Colors.transparent);
    set4.setCircleSize(3);
    set4.setColor1(Colors.grey);
    set4.setCircleColor(Colors.grey);

    set4.enableDashedLine(10, 5, 0);
    set4.setFormLineWidth(1);
    set4.setFormLineDashEffect(DashPathEffect(10, 5, 0));
    set4.setFormSize(15);

    List<ILineDataSet> dataSets = List();
    dataSets.add(set1); // add the data sets
    dataSets.add(set2); // add the data sets
    dataSets.add(set4); // add the data sets
    dataSets.add(set3); // add the data sets

    // create a data object with the data sets
    lineChartController.data = LineData.fromList(dataSets);
    lineChartController.marker = CustomMarker(backColor: Colors.grey[700], textColor: Colors.white, title: title);
    lineChartController.setScaleMinima(2, 1);

    setState(() {});
  }
}