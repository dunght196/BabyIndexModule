import 'dart:async';

import 'package:babyindexmodule/bloc/child_bloc.dart';
import 'package:babyindexmodule/model/child_response.dart';
import 'package:babyindexmodule/state_loading_data.dart';
import 'package:babyindexmodule/util/route_transition.dart';
import 'package:babyindexmodule/util/string.dart';
import 'package:babyindexmodule/wonderweek_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'util/app_util.dart';
import 'build_chart_index.dart';
import 'dummy_data.dart';
import 'model/child.dart';
import 'model/index_baby.dart';
import 'index_baby_screen.dart';

enum StateChild {LOADING, SUCCESS, ERROR, EMTY}

class Home extends StatefulWidget {
  static final heightTextField = 40.0;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final tftWeight = TextEditingController();
  final tftHeight = TextEditingController();
  final tftPerimeter = TextEditingController();
  final tftDate = TextEditingController();

  String relativeId;
  String guuId;
  String name;
  String gender;
  String birthDay;
  List<Child> dataChild = List();
  Entry markerBaby;

  var _stateChild = StateChild.LOADING;
  var databaseReference;
  DateTime _date = DateTime.now();
  var txtDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<DocumentSnapshot> listSnapshot = List();
  ChildResponse _childResponse;
  String _accessToken = "";

  static const MethodChannel methodChannel = MethodChannel('flutter.io/baby');
  StreamController<Entry> _controllerStream = StreamController<Entry>.broadcast();

  @override
  void initState() {
    super.initState();
    runMultipleFutures();
  }

  @override
  void dispose() {
    tftWeight.dispose();
    tftHeight.dispose();
    tftPerimeter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: null,
        ),
        titleSpacing: 0.0,
        title: Text('Thêm chỉ số cho bé'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 7),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_createRoute(IndexBabyScreen()));
                },
                child: Text(
                  'Tất cả chỉ số',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          )
        ],
      ),
      body: widgetBuilder(),
    );
  }

  Widget widgetBuilder() {
    if(_stateChild == StateChild.LOADING) {
      return BuildLoadingWidget();
    }else if(_stateChild == StateChild.SUCCESS) {
      return _buildHome();
    }else if(_stateChild == StateChild.EMTY) {
      return Center(
        child: RaisedButton(child: Text('Thêm bé mới'),),
      );
    }else {
      return Center(child: Text('Đã có lỗi xảy ra'),);
    }
  }

  Widget _buildHome() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Text('Bé'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                height: Home.heightTextField,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    Icon(gender == 'male' ? Icons.accessibility : Icons.pregnant_woman),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: GestureDetector(
                          onTap: () {
                            _showDropdownChild();
                          },
                          child: Text(name)
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 0, 0),
                child: Text('Cân nặng'),
              ),
              _buidFormIndex('kg', tftWeight),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 0, 0),
                child: Text('Chiều cao'),
              ),
              _buidFormIndex("cm", tftHeight),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 0, 0),
                child: Text('Chu vi đầu'),
              ),
              _buidFormIndex("cm", tftPerimeter),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 0, 0),
                child: Text('Ngày'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildFormDate(),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    addIndexBaby(context);
                  },
                  child: RaisedButton(
                    child: Text('Thêm'),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildLine(),
        _buildWonderWeek(),
        _buildLine(),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: BuildChartIndex(
            Strings.WEIGHT,
            DummyData.createBelowLineWeightBoy(),
            DummyData.createTopLineWeightBoy(),
            listSnapshot,
            birthDay,
          ),
        ),
        _buildLine(),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: BuildChartIndex(
            Strings.HEIGHT,
            DummyData.createBelowLineHeightBoy(),
            DummyData.createTopLineHeightBoy(),
            listSnapshot,
            birthDay,
          ),
        ),
        _buildLine(),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: BuildChartIndex(
            Strings.PERIMETER,
            DummyData.createBelowLinePerimeterBoy(),
            DummyData.createTopLinePerimeterBoy(),
            listSnapshot,
            birthDay,
          ),
        ),
      ],
    );
  }

  Widget _buidFormIndex(String index, TextEditingController _controller) {
    return Stack(
      children: <Widget>[
        Container(
          height: Home.heightTextField,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey[300])),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey[300])),
            ),
            controller: _controller,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 40,
            height: Home.heightTextField,
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Center(child: Text(index)),
          ),
        )
      ],
    );
  }

  Widget _buildFormDate() {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: Home.heightTextField,
          decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          child: Center(child: Icon(Icons.calendar_today, size: 15)),
        ),
        Expanded(
            child: GestureDetector(
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            height: Home.heightTextField,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                border: Border.all(color: Colors.grey[350])),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(DateFormat('dd-MM-yyyy').format(_date)),
                )),
          ),
        )),
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 20,
      color: Colors.grey[200],
    );
  }

  Widget _buildWonderWeek() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12, top: 12),
          child: Text('Wonder Week',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12, top: 10),
          child: Text('Thời điểm nhõng nhẽo của trẻ'),
        ),
        BuildWonderWeek(markerBaby, _controllerStream),
        BuildNoteWonderWeek(),
      ],
    );
  }

  void addIndexBaby(BuildContext context) async {
    IndexBaby mapData = IndexBaby(
        tftDate.text, tftHeight.text, tftWeight.text, tftPerimeter.text);
    await databaseReference
        .document(txtDate)
        .setData(mapData.toJson());
    Navigator.of(context).push(_createRoute(IndexBabyScreen()));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2016),
      initialDate: DateTime.now(),
      lastDate: DateTime(2021),
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        txtDate = DateFormat('dd-MM-yyyy').format(_date);
      });
    }
  }

  Future<List<DocumentSnapshot>> getIndexList() async {
    QuerySnapshot querySnapshot = await databaseReference.getDocuments();
    return querySnapshot.documents;
  }

  Future runMultipleFutures() async {
    var futures = List<Future>();
    futures.add(_getDataFromNative());
    futures.add(_initStateChild());
    await Future.wait(futures);
  }

  Entry getOffsetMarkerBaby(String birthDay) {
    var date1 = DateTime.parse(birthDay);
    var date2 = DateTime.now();
    final difference = date2.difference(date1).inDays;
    var week = num.parse((difference / 7).toStringAsFixed(2));
    var offsetYBaby = (week/7).floor().toDouble();
    var offsetXBaby = week - (7*offsetYBaby);
    return Entry(x: offsetXBaby, y: 12-offsetYBaby);
  }

  Future _getDataFromNative() async {
    String accesToken;
    try {
      final String result = await methodChannel.invokeMethod('getDataFromNative');
      accesToken = result;
      debugPrint("Acesstoke: $accesToken");
    } on PlatformException catch (e){
      debugPrint("Error get data from native: $e");
    }
    setState(() {
      if(accesToken != null ) {
        _accessToken = accesToken;
        AppUtil.setGuuToken(_accessToken);
      }
    });
  }

  Future _initStateChild() async {
    childBloc.getChild().then((results){
      setState(() {
        _childResponse = results;
        if(_childResponse != null && _childResponse.data.isNotEmpty) {
          dataChild.clear();
          dataChild.addAll(_childResponse.data);
          Child child = dataChild[0];
          guuId = child.guuId;
          relativeId = child.relativeId;
          name = child.name;
          gender = child.gender;
          birthDay = child.birthday;
          markerBaby = getOffsetMarkerBaby(birthDay);
          AppUtil.setGuuId(guuId);
          AppUtil.setRelativeId(relativeId);
          // Get data chart
          databaseReference = Firestore.instance.collection(guuId).document(relativeId).collection('date');
          getIndexList().then((results){
            setState(() {
              listSnapshot.clear();
              listSnapshot.addAll(results);
              _stateChild = StateChild.SUCCESS;
            });
          });
        }else if(_childResponse != null && _childResponse.data.isEmpty) {
          setState(() {
            _stateChild = StateChild.EMTY;
          });
        }else {
          setState(() {
            _stateChild = StateChild.ERROR;
          });
        }
      });
    });
  }

  _showDropdownChild() async {
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(65, 150, 100, 100),
        items: dataChild.map((item) =>
            PopupMenuItem<Child>(
              child: Text(item.name), value: item,
            )
        ).toList()
    );

    if(result != null) {
      setState(() {
        guuId = result.guuId;
        relativeId = result.relativeId;
        name = result.name;
        gender = result.gender;
        birthDay = result.birthday;
        markerBaby = getOffsetMarkerBaby(birthDay);
        _controllerStream.add(markerBaby);
        AppUtil.setGuuId(guuId);
        AppUtil.setRelativeId(relativeId);
        databaseReference = Firestore.instance.collection(guuId).document(relativeId).collection('date');
        getIndexList().then((results){
          setState(() {
            listSnapshot.clear();
            listSnapshot.addAll(results);
          });
        });
      });
    }
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

