import 'dart:collection';
import 'dart:convert';
import 'package:it_books/models/book.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class RestService {
  final String url = "api.itbook.store";

  HashMap booksMap = HashMap<String, int>();
  DefaultCacheManager defaultCacheManager = DefaultCacheManager();


  Future<List> getBooks(String term) async {
    List books=[];

    if(term.isEmpty){
      return Future.value([]);
    }
    var uri = Uri.https(url, "/1.0/search/$term");

    //WITHOUT CACHE
    //final response = await http.get(uri);

    //WITH CACHE
    try {
      final response = await defaultCacheManager.getSingleFile(uri.toString());

      books.addAll(json.decode(
          utf8.decode(response.readAsBytesSync()))['books']);
      return books;
    }catch(e){
      books.add(false);
      return books;
    }
  }

  Future<List> getBooksByPage(int page, String term) async {
    List books=[];

    var uri = Uri.https(url, "/1.0/search/$term/$page");

    //WITHOUT CACHE
    /*final response = await http.get(uri);
    books.addAll(json.decode(utf8.decode(response.bodyBytes))['books']);*/

    //WITH CACHE
    try{
      final response = await defaultCacheManager.getSingleFile(uri.toString());
      books.addAll(json.decode(utf8.decode(response.readAsBytesSync()))['books']);

      List tmpBooks= List.from(books);

      for (var book in tmpBooks) {
        if(!booksMap.containsKey(book["isbn13"])){
          booksMap[book["isbn13"]]=1;
        } else{
          books.remove(book);
        }
      }
    }catch(e){
      books.add(false);
      books.add(e.toString());
    }

    return books;
  }

  Future<String> getNumberOfBooks(String term) async {
    var uri = Uri.https(url, "/1.0/search/$term");
    try{
      final response = await defaultCacheManager.getSingleFile(uri.toString());
      return json.decode(utf8.decode(response.readAsBytesSync()))['total'];
    }catch(e){
      return "error";
    }

  }

  Future<Book> getBookInfo(String isbn13) async {
    Book book;
    var uri = Uri.https(url, "/1.0/books/$isbn13");

    //WITHOUT CACHE
    /*final response = await http.get(uri);
    book = Book.fromJson(jsonDecode(response.body));*/

    //WITH CACHE
    try {
      final response = await defaultCacheManager.getSingleFile(
          uri.toString());
      book = Book.fromJson(jsonDecode(response.readAsStringSync()));
    }catch(e){
      Book book = Book();
      book.isbn13="error";
      return book;
    }


    return book;
  }

}