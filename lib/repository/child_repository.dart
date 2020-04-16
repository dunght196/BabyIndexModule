
import 'package:babyindexmodule/model/child_response.dart';
import 'package:babyindexmodule/repository/child_api_provider.dart';

class ChildRepository {
  ChildApiProvider _apiProvider = ChildApiProvider();

  Future<ChildResponse> getChild(){
    return _apiProvider.getChild();
  }
}