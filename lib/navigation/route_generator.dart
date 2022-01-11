
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it_books/models/book.dart';
import 'package:it_books/navigation/routes.dart';
import 'package:it_books/screens/book_list_screen.dart';
import 'package:it_books/screens/book_screen.dart';
import 'package:it_books/screens/search_screen.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){

    switch(settings.name){
      case Routes.searchScreen:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case Routes.bookScreen:
        if(settings.arguments != null){
          Book book = settings.arguments as Book;
          return MaterialPageRoute(builder: (_) => BookScreen(book: book));
        } else {
          return MaterialPageRoute(builder: (_) => const BookScreen());
        }
      case Routes.bookListScreen:
        if(settings.arguments != null) {
          List<dynamic> books = settings.arguments as List<dynamic>;
          return MaterialPageRoute(
              builder: (_) => BookListScreen(books: books));
        }else{
          return MaterialPageRoute(
              builder: (_) => BookListScreen());
        }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}