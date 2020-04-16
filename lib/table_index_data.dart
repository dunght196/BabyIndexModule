
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dummy_data.dart';
import 'model/index_baby.dart';

class TableIndexDataScreen extends StatelessWidget {

  final double heightTitle = 55;
  final double heightItem = 45;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title: Text('Chỉ số tiêu chuẩn'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'THAI NHI'),
              Tab(text: 'BÉ TRAI'),
              Tab(text: 'BÉ GÁI'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[200], Colors.pink[100]]
            ),
          ),
          child: TabBarView(
            children: [
              _buildTabFetus(context),
              _buildTabBaby(context, DummyData.createDataBoyBaby()),
              _buildTabBaby(context, DummyData.createDataGirlBaby()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabFetus(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleFetus(),
        _buildListFetus(context, DummyData.createDataFetus()),
      ],
    );
  }

  Widget _buildTabBaby(BuildContext context, List<IndexBaby> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleBoyBaby(),
        _buildListBaby(context, data),
      ],
    );
  }

  Widget _buildTitleFetus() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildBorderTitle('Tuần thai')
        ),
        Expanded(
          flex: 2,
          child: _buildBorderTitle('Chiều dài (cm)')
        ),
        Expanded(
          flex: 2,
          child: _buildBorderTitle('Cân nặng (g)')
        )
      ],
    );
  }

  Widget _buildTitleBoyBaby() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: _buildBorderTitle('Tháng tuổi')
        ),
        Expanded(
            flex: 3,
            child: _buildBorderTitle('Chiều cao (cm)')
        ),
        Expanded(
            flex: 3,
            child: _buildBorderTitle('Cân nặng (kg)')
        ),
        Expanded(
            flex: 3,
            child: _buildBorderTitle('Chu vi đầu (cm)')
        ),
      ],
    );
  }

  Widget _buildListFetus(BuildContext context, List<IndexFetus> data) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItemFetus(context, data[index], index);
        },
      ),
    );
  }

  Widget _buildItemFetus(BuildContext context, IndexFetus indexFetus, int index) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildBorderItem(indexFetus.gestationalWeek)
        ),
        Expanded(
          flex: 2,
          child: _buildBorderItem(indexFetus.long)
        ),
        Expanded(
          flex: 2,
          child: _buildBorderItem(indexFetus.weight)
        )
      ],
    );
  }

  Widget _buildListBaby(BuildContext context, List<IndexBaby> data) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItemBaby(context, data[index]);
        },
      ),
    );
  }

  Widget _buildItemBaby(BuildContext context, IndexBaby indexBaby) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: _buildBorderItem(indexBaby.date)
        ),
        Expanded(
            flex: 3,
            child: _buildBorderItem(indexBaby.height)
        ),
        Expanded(
            flex: 3,
            child: _buildBorderItem(indexBaby.weight)
        ),
        Expanded(
            flex: 3,
            child: _buildBorderItem(indexBaby.perimeter)
        )
      ],
    );
  }
  
  Widget _buildBorderItem(String value) {
    return Container(
      height: heightItem,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey[300], width: 1),
              right: BorderSide(color: Colors.grey[300], width: 1)
          )
      ),
      child: Center(child: Text(value),),
    );
  }

  Widget _buildBorderTitle(String title) {
    return Container(
      height: heightTitle,
      decoration: BoxDecoration(
//          color: Colors.blue[200],
          border: Border(
              right: BorderSide(color: Colors.grey[300], width: 1),
              bottom: BorderSide(color: Colors.grey[300], width: 1),
          )
      ),
      child: Center(child: Text(title)),
    );
  }

}