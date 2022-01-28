import 'package:flutter/cupertino.dart';
import 'package:it_books/services/rest_services.dart';

class RestServiceProvider extends ChangeNotifier {
  late RestService _service;

  RestService getRestService() {
    return _service;
  }

  RestService newRestService(){
    _service = RestService();
    return _service;
  }
}