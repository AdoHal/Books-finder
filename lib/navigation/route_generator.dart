
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it_books/models/book.dart';
import 'package:it_books/models/book_list_args.dart';
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
        if(settings.arguments != null && settings.arguments is Book){
          Book book = settings.arguments as Book;
          return MaterialPageRoute(builder: (_) => BookScreen(book: book));
        } else {
          return _errorRoute();
        }
      case Routes.bookListScreen:
        if(settings.arguments != null && settings.arguments is BookListScreenArguments) {
          BookListScreenArguments args= settings.arguments as BookListScreenArguments;
          return MaterialPageRoute(
              builder: (_) => BookListScreen(term: args.term, books: args.books, numOfBooks: args.numOfBooks,));
        }else{
          return _errorRoute();
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
          child: Text('Something went wrong'),
        ),
      );
    });
  }
}