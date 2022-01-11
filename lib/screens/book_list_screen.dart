import 'package:flutter/material.dart';
import 'package:it_books/models/book.dart';
import 'package:it_books/navigation/routes.dart';
import 'package:it_books/services/rest_services.dart';

class BookListScreen extends StatefulWidget {
  final List? books;
  const BookListScreen({Key? key, this.books}) : super(key: key);

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Books list"),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: widget.books!.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  height: 50,
                  color: Colors.lightBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                        child: Text('Entry ${widget.books![index]["title"]}', textAlign: TextAlign.center,)),
                  ),
                ),
                onTap: () async {
                  Book book = await RestService().getBookInfo(widget.books![index]["isbn13"]);
                  Navigator.pushNamed(context, Routes.bookScreen, arguments: book);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
