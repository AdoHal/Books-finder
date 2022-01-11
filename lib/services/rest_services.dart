import 'dart:convert';

import 'package:it_books/models/book.dart';
import 'package:http/http.dart' as http;

class RestService {
  final String url = "api.itbook.store";

  Future<List> getBooks(String term) async {

    if(term.isEmpty){
      return Future.value([]);
    }
    var uri = Uri.https(url, "/1.0/search/$term");

    final response = await http.get(uri);
    print(response.body);


    return json.decode(utf8.decode(response.bodyBytes))['books'] as List<dynamic>;
  }

  Future<Book> getBookInfo(String isbn13) async {
    Book book;
    var uri = Uri.https(url, "/1.0/books/$isbn13");
    print(uri);

    final response = await http.get(uri);
    book = Book.fromJson(jsonDecode(response.body));

    return book;
  }

}