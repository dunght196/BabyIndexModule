import 'package:babyindexmodule/home.dart';
import 'package:babyindexmodule/state_loading_data.dart';
import 'package:babyindexmodule/util/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detail_indexbaby_screen.dart';
import 'model/index_baby.dart';

class IndexBabyScreen extends StatefulWidget {
  _IndexBabyState createState() => _IndexBabyState();
}

class _IndexBabyState extends State<IndexBabyScreen> {
   var databaseReference = Firestore.instance;
   String _guuId;
   String _relativeId;

   bool isLoading = true;

   @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
     String guuId = await AppUtil.getGuuId();
     String relativeId = await AppUtil.getRelativeId();
     setState(() {
       _guuId = guuId;
       _relativeId = relativeId;
       isLoading = false;
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0.0,
          title: Text('Chỉ số của bé')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          color: Colors.blue[100],
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Center(child: Text('Ngày'))),
              Expanded(child: Center(child: Text('Cân nặng'))),
              Expanded(child: Center(child: Text('Chiều cao'))),
              Expanded(child: Center(child: Text('Chu vi đầu'))),
            ],
          ),
        ),
        StreamBuilder(
          stream: isLoading ? Stream.empty() : databaseReference.collection(_guuId).document(_relativeId).collection('date').snapshots() ,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return BuildLoadingWidget();
            return _buildList(context, snapshot.data.documents);
          },
        )
      ],
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Expanded(
        child: ListView.builder(
            itemCount: snapshot.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(context, snapshot, index);
            }));
  }

  Widget _buildListItem(
      BuildContext context, List<DocumentSnapshot> data, int position) {
    final index = IndexBaby.fromSnapshot(data[position]);
    var rangeWeight = 0;
    var rangeHeight = 0;
    var rangePerimeter = 0;
    if (position > 0) {
      final indexBefore = IndexBaby.fromSnapshot(data[position - 1]);
      rangeWeight = int.parse(index.weight) - int.parse(indexBefore.weight);
      rangeHeight = int.parse(index.height) - int.parse(indexBefore.height);
      rangePerimeter = int.parse(index.perimeter) - int.parse(indexBefore.perimeter);
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute( DetailIndexBabyScreen(indexBaby: index)));
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Center(child: Text(index.date))),
            Expanded(child: compareIndex(index.weight, rangeWeight)),
            Expanded(child: compareIndex(index.height, rangeHeight)),
            Expanded(child: compareIndex(index.perimeter, rangePerimeter)),
          ],
        ),
      ),
    );
  }

  Widget compareIndex(String value, int rangeValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rangeValue == 0
          ? <Widget>[Text(value)]
          : <Widget>[
              Text(value),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                      rangeValue > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: rangeValue > 0 ? Colors.green : Colors.red,
                      size: 20),
                  Text(
                    rangeValue.abs().toString(),
                    style: TextStyle(fontSize: 10, color: rangeValue > 0 ? Colors.green : Colors.red),
                  )
                ],
              )
            ],
    );
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
