import 'package:flutter_test/flutter_test.dart';
import 'package:it_books/services/providers/rest_service_provider.dart';
import 'package:it_books/services/rest_services.dart';

void main(){
  test("Test RestServiceProvider", (){
    RestServiceProvider provider = RestServiceProvider();
    RestService service = provider.newRestService();
    expect(service, provider.getRestService());
  });
}