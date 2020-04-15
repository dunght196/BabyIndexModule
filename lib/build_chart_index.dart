import 'package:babyindexmodule/table_index_data.dart';
import 'package:babyindexmodule/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/poolable/point.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/utils/painter_utils.dart';
import 'package:mp_chart/mp/core/utils/utils.dart';
import 'package:mp_chart/mp/core/value_formatter/default_value_formatter.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
import 'package:mp_chart/mp/core/view_port.dart';

import 'app_util.dart';
import 'check_valid_guess_baby.dart';
import 'color_util.dart';
import 'index_baby.dart';
import 'index_baby_screen.dart';
import 'chart_detail_fullscreen.dart';

class BuildChartIndex extends StatefulWidget {

  final String title;
  final String dateOfBirth;
  final List<Entry> dataBelowLine;
  final List<Entry> dataTopLine;
  final List<DocumentSnapshot> snapShot;

  BuildChartIndex(this.title, this.dataBelowLine, this.dataTopLine, this.snapShot, this.dateOfBirth);

  @override
  State<StatefulWidget> createState() {
    return _BuildChartIndexState(title, dataBelowLine, dataTopLine, snapShot, dateOfBirth);
  }
}

class _BuildChartIndexState extends State<BuildChartIndex> {
  final String title;
  final String dateOfBirth;
  final List<Entry> dataBelowLine;
  final List<Entry> dataTopLine;
  LineChartController lineChartController;
  final List<DocumentSnapshot> snapShot;
  List<Entry> dataIndex = List();
  List<Entry> dataGuess = List();

  _BuildChartIndexState(this.title, this.dataBelowLine, this.dataTopLine, this.snapShot, this.dateOfBirth);

  @override
  void initState() {
    super.initState();
    initDataIndex();
    _initControllerLineChart();
    _initLineChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(title),
                )),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TableIndexDataScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text('Bảng chỉ số chuẩn'),
              ),
            ),
          ],
        ),
        Container(
          height: 400,
          child: LineChart(lineChartController),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.red,
              width: 8,
              height: 8,
              margin: EdgeInsets.only(left: 45),
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
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(color: Colors.grey, width: 1.0))),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IndexBabyScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Chi tiết'),
                        Icon(Icons.navigate_next),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 38,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChartDetailFullScreen(
                                title: title,
                                dataBelowLine: dataBelowLine,
                                dataTopLine: dataTopLine,
                                dataGuess: dataGuess,
                                dataIndex: dataIndex,
                              )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Xem toàn màn hình'),
                        Icon(Icons.navigate_next),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _initControllerLineChart() {
    var desc = Description()..enabled = false;
    lineChartController = LineChartController(
        backgroundColor: Colors.transparent,
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..drawGridLines = (true)
            ..setLabelCount2(6, true)
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

  void initDataIndex() {
//    List<IndexBaby> lsIndexBaby = List();
//    for(var x in snapShot) {
//      IndexBaby index = IndexBaby.fromSnapshot(x);
//      lsIndexBaby.add(index);
//    }
    List lsIndexBaby = snapShot.map((item) => IndexBaby.fromSnapshot(item)).toList();

    bool isDataGuess = false;
    switch(title) {
      case AppUtil.HEIGHT:
        List check = lsIndexBaby.where((item) => !CheckValidGuessData.isValidGuessBoyHeight(getMonthIndex(item.date), double.parse(item.height))).toList();
        isDataGuess =  (check.length > 0) ? false : true;
        break;
      case AppUtil.WEIGHT:
        List check = lsIndexBaby.where((item) => !CheckValidGuessData.isValidGuessBoyWeight(getMonthIndex(item.date), double.parse(item.weight))).toList();
        isDataGuess =  (check.length > 0) ? false : true;
        break;
      case AppUtil.PERIMETER:
        List check = lsIndexBaby.where((item) => !CheckValidGuessData.isValidGuessBoyPerimeter(getMonthIndex(item.date), double.parse(item.perimeter))).toList();
        isDataGuess =  (check.length > 0) ? false : true;
        break;
      default:
        break;
    }

    for(int i=1; i<=lsIndexBaby.length; i++) {
      switch(title) {
        case AppUtil.HEIGHT:
          var startHeight = double.parse(lsIndexBaby[0].height);
          var lastHeight = double.parse(lsIndexBaby[lsIndexBaby.length-1].height);
          var subHeight = lastHeight - startHeight;
          //Check valid guess data
          if(subHeight > 0 && isDataGuess) {
            var startMonth = getMonthIndex(lsIndexBaby[0].date);
            var lastMonth = getMonthIndex(lsIndexBaby[lsIndexBaby.length-1].date);
            var subMonth = lastMonth - startMonth;
            var averageHeight = subHeight/(lsIndexBaby.length-1);
            var averageMonth = subMonth/(lsIndexBaby.length-1);
            var xOffset = num.parse((lastMonth + (i*averageMonth)).toStringAsFixed(1));
            var yOffset = num.parse((lastHeight + (i*averageHeight)).toStringAsFixed(1));
            Entry entryGess = Entry(x: xOffset, y: yOffset);
            if(entryGess != null ) dataGuess.add(entryGess);
          }
          Entry entry = Entry(
              x: getMonthIndex(lsIndexBaby[i-1].date),
              y: double.parse((lsIndexBaby[i-1].height)),
              data: lsIndexBaby[i-1].date
          );
          if(entry != null) {
            dataIndex.add(entry);
          }
          break;
        case AppUtil.WEIGHT:
          var startWeight = double.parse(lsIndexBaby[0].weight);
          var lastWeight = double.parse(lsIndexBaby[lsIndexBaby.length-1].weight);
          var subWeight = lastWeight - startWeight;
          //Check valid guess data
          if(subWeight > 0 && isDataGuess) {
            var startMonth = getMonthIndex(lsIndexBaby[0].date);
            var lastMonth = getMonthIndex(lsIndexBaby[lsIndexBaby.length-1].date);
            var subMonth = lastMonth - startMonth;
            var averageWeight = subWeight/(lsIndexBaby.length-1);
            var averageMonth = subMonth/(lsIndexBaby.length-1);
            var xOffset = num.parse((lastMonth + (i*averageMonth)).toStringAsFixed(1));
            var yOffset = num.parse((lastWeight + (i*averageWeight)).toStringAsFixed(1));
            Entry entryGess = Entry(x: xOffset, y: yOffset);
            if(entryGess != null ) dataGuess.add(entryGess);
          }
          Entry entry = Entry(
              x: getMonthIndex(lsIndexBaby[i-1].date),
              y: double.parse((lsIndexBaby[i-1].weight)),
              data: lsIndexBaby[i-1].date
          );
          if(entry != null) {
            dataIndex.add(entry);
          }
          break;
        case AppUtil.PERIMETER:
          var startPerimeter = double.parse(lsIndexBaby[0].perimeter);
          var lastPerimeter = double.parse(lsIndexBaby[lsIndexBaby.length-1].perimeter);
          var subPerimeter = lastPerimeter - startPerimeter;
          //Check valid guess data
          if(subPerimeter > 0 && isDataGuess) {
            var startMonth = getMonthIndex(lsIndexBaby[0].date);
            var lastMonth = getMonthIndex(lsIndexBaby[lsIndexBaby.length-1].date);
            var subMonth = lastMonth - startMonth;
            var averagePerimeter = subPerimeter/(lsIndexBaby.length-1);
            var averageMonth = subMonth/(lsIndexBaby.length-1);
            var xOffset = num.parse((lastMonth + (i*averageMonth)).toStringAsFixed(1));
            var yOffset = num.parse((lastPerimeter + (i*averagePerimeter)).toStringAsFixed(1));
            Entry entryGess = Entry(x: xOffset, y: yOffset);
            if(entryGess != null ) dataGuess.add(entryGess);
          }
          Entry entry = Entry(
              x: getMonthIndex(lsIndexBaby[i-1].date),
              y: double.parse((lsIndexBaby[i-1].perimeter)),
              data: lsIndexBaby[i-1].date
          );
          if(entry != null) {
            dataIndex.add(entry);
          }
          break;
      }
    }

    if(dataGuess.isNotEmpty) {
      switch(title) {
        case AppUtil.HEIGHT:
          dataGuess.add(
              Entry(
                  x: getMonthIndex(lsIndexBaby[lsIndexBaby.length-1].date),
                  y: double.parse(lsIndexBaby[lsIndexBaby.length-1].height))
          );
          break;
        case AppUtil.WEIGHT:
          dataGuess.add(
              Entry(
                  x: getMonthIndex(lsIndexBaby[lsIndexBaby.length-1].date),
                  y: double.parse(lsIndexBaby[lsIndexBaby.length-1].weight))
          );
          break;
        case AppUtil.PERIMETER:
          dataGuess.add(
              Entry(
                  x: getMonthIndex(lsIndexBaby[lsIndexBaby.length-1].date),
                  y: double.parse(lsIndexBaby[lsIndexBaby.length-1].perimeter))
          );
          break;
      }
      dataGuess.sort((a,b) => a.y.compareTo(b.y));
    }
  }

  double getMonthIndex(String dateIndex) {
    var date1 = getValidDateFormat(dateOfBirth);
    var date2 = getValidDateFormat(dateIndex);
    final difference = date2.difference(date1).inDays;
    return num.parse((difference / 30).toStringAsFixed(1));
  }

  DateTime getValidDateFormat(String date) {
    DateFormat inputFormat = DateFormat("dd-MM-yyyy");
    DateTime dateTime = inputFormat.parse(date);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    DateTime dateTime2 = outputFormat.parse(dateTime.toString());
    return dateTime2;
  }

}

class CustomMarker implements IMarker {
  Entry _entry;
  // ignore: unused_field
  Highlight _highlight;
  double _dx = 0.0;
  double _dy = 0.0;

  DefaultValueFormatter _formatter;
  Color _textColor;
  Color _backColor;
  double _fontSize;
  String _title;

  CustomMarker({Color textColor, Color backColor, double fontSize, title: String})
      : _textColor = textColor,
        _backColor = backColor,
        _title = title,
        _fontSize = fontSize {
    _formatter = DefaultValueFormatter(0);
    this._textColor ??= ColorUtils.PURPLE;
    this._backColor ??= ColorUtils.WHITE;
    this._fontSize ??= Utils.convertDpToPixel(10);
    this._title ??= "";
  }

  @override
  void draw(Canvas canvas, double posX, double posY) {
    TextPainter painter = PainterUtils.create(
        null,
        "${_entry.y}${AppUtil.getSuffixYAxis(_title)}-${_entry.x}thg",
        _textColor,
        _fontSize);
    Paint paint = Paint()
      ..color = _backColor
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    MPPointF offset = getOffsetForDrawingAtPoint(posX, posY);

    canvas.save();
    // translate to the correct position and draw
//    canvas.translate(posX + offset.x, posY + offset.y);
    painter.layout();
    Offset pos = calculatePos(
        posX + offset.x, posY + offset.y, painter.width, painter.height);
    canvas.drawRRect(
        RRect.fromLTRBR(pos.dx - 5, pos.dy - 5, pos.dx + painter.width + 5,
            pos.dy + painter.height + 5, Radius.circular(5)),
        paint);
    painter.paint(canvas, pos);
    canvas.restore();
  }

  Offset calculatePos(double posX, double posY, double textW, double textH) {
    return Offset(posX - textW / 2, posY - textH / 2);
  }

  @override
  MPPointF getOffset() {
    return MPPointF.getInstance1(_dx, _dy);
  }

  @override
  MPPointF getOffsetForDrawingAtPoint(double posX, double posY) {
    return getOffset();
  }

  @override
  void refreshContent(Entry e, Highlight highlight) {
    _entry = e;
    highlight = highlight;
  }
}

class FormatXAxisValue extends ValueFormatter {

  String _suffix;

  FormatXAxisValue(String suffix) {
    this._suffix = suffix;
  }

  @override
  String getFormattedValue1(double value) {
    return value.toStringAsFixed(0) + _suffix;
  }
}

class FormatDrawValue extends ValueFormatter {

  String _suffix;

  FormatDrawValue(String suffix) {
    this._suffix = suffix;
  }

  @override
  String getFormattedValue1(double value) {
    return value.toStringAsFixed(1) + _suffix;
  }

}