import 'package:cloud_firestore/cloud_firestore.dart';

class IndexBaby {
  final String height;
  final String weight;
  final String perimeter;
  final String date;

  IndexBaby(this.date, this.height, this.weight, this.perimeter);

  IndexBaby.fromSnapshot(DocumentSnapshot snapshot)
      : height = snapshot['height'],
        weight = snapshot['weight'],
        perimeter = snapshot['perimeter'],
        date = snapshot.documentID;

  Map<String, dynamic> toJson() => {
        'height': height,
        'weight': weight,
        'perimeter': perimeter
      };
}

class IndexFetus {
  final String gestationalWeek;
  final String long;
  final String weight;

  IndexFetus(this.gestationalWeek, this.long, this.weight);
}
