
import 'package:babyindexmodule/model/child_response.dart';
import 'package:babyindexmodule/repository/child_repository.dart';
import 'package:rxdart/subjects.dart';

class ChildBloc {
  final ChildRepository _repository = ChildRepository();
  final BehaviorSubject<ChildResponse> _subject = BehaviorSubject<ChildResponse>();

  Future<ChildResponse> getChild() async {
    ChildResponse response = await _repository.getChild();
//    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ChildResponse> get subject => _subject;
}

final childBloc = ChildBloc();