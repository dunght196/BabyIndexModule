import 'package:babyindexmodule/util/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'model/index_baby.dart';

class DetailIndexBabyScreen extends StatefulWidget {
  final IndexBaby indexBaby;

  DetailIndexBabyScreen({Key key, @required this.indexBaby});

  @override
  _DetailIndexBabyState createState() => _DetailIndexBabyState(indexBaby);
}

class _DetailIndexBabyState extends State<DetailIndexBabyScreen> {
  final IndexBaby indexBaby;

  final tftWeight = TextEditingController();
  final tftHeight = TextEditingController();
  final tftPerimeter = TextEditingController();
  final tftDate = TextEditingController();

  var databaseReference;

  _DetailIndexBabyState(this.indexBaby);

  @override
  void initState() {
    super.initState();
    tftHeight.text = indexBaby.height;
    tftWeight.text = indexBaby.weight;
    tftPerimeter.text = indexBaby.perimeter;
    tftDate.text = indexBaby.date;
    initData();
  }

  initData() async {
    String guuId = await AppUtil.getGuuId();
    String relativeId = await AppUtil.getRelativeId();
    setState(() {
      databaseReference = Firestore.instance.collection(guuId).document(relativeId).collection('date');
    });
  }

  @override
  void dispose() {
    tftWeight.dispose();
    tftHeight.dispose();
    tftPerimeter.dispose();
    tftDate.dispose();
    super.dispose();
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
          title: Text('Cập nhật chỉ số cho bé')),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(23, 23, 23, 0),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: Text('Bé'),
                ),
                Container(
//              width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  height: Home.heightTextField,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    children: [
                      Icon(Icons.accessibility),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('Dũng'),
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
                _buildFormDate(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: ()  {
                      transactionDelete(indexBaby, context);
                    },
                    child: Container(
                      height: 50,
                      color: Colors.red[500],
                      child: Center(
                        child: Text(
                          'Xóa',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: () {
                      transactionUpdate(indexBaby, context);
                    },
                    child: Container(
                      height: 50,
                      color: Colors.blue[500],
                      child: Center(
                        child: Text('Cập nhật',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
//                      contentPadding: EdgeInsets.symmetric(vertical: 50),
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
          child: Container(
            height: Home.heightTextField,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
//                      contentPadding: EdgeInsets.symmetric(vertical: 50),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    borderSide: BorderSide(color: Colors.grey[300])),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    borderSide: BorderSide(color: Colors.grey[300])),
              ),
              controller: tftDate,
            ),
          ),
        ),
      ],
    );
  }

  Future transactionDelete(IndexBaby indexBaby, BuildContext context) async {
    DocumentReference df = databaseReference.document(indexBaby.date);
    await df.delete();
    Navigator.pop(context);
  }

  Future transactionUpdate(IndexBaby indexBaby, BuildContext context) async {
    var dateOld = indexBaby.date;
    var dateNew = tftDate.text;
    IndexBaby mapData = IndexBaby(dateNew, tftHeight.text, tftWeight.text, tftPerimeter.text);
    DocumentReference df = databaseReference.document(dateOld);
    await df.delete();
    DocumentReference df1 = databaseReference.document(dateNew);
    if(mapData != null ) await df1.setData(mapData.toJson());
    Navigator.pop(context);
  }
}
