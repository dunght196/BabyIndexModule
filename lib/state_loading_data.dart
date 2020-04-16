import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
//        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
}

class BuildErrorWidget extends StatelessWidget {
  final String error;

  BuildErrorWidget(this.error);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
