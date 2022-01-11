import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:it_books/models/book.dart';
import 'package:it_books/navigation/routes.dart';
import 'package:it_books/services/rest_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final bookTerm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book finder"), automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Search with TypeAhead", style: TextStyle(color: Colors.lightBlue, fontSize: 20),),
                    TypeAheadField(
                      textFieldConfiguration: const TextFieldConfiguration(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                              border: OutlineInputBorder()
                          )
                      ),
                      suggestionsCallback: (pattern) async {
                        return await RestService().getBooks(pattern);
                      },
                      itemBuilder: (context, dynamic suggestion) {
                        return ListTile(
                          title: Text(suggestion['title']),
                          subtitle: Text(suggestion['subtitle']),
                        );
                      },
                      onSuggestionSelected: (dynamic suggestion) async {
                        Book book = await RestService().getBookInfo(suggestion["isbn13"]);
                        Navigator.pushNamed(context, Routes.bookScreen, arguments: book);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Search with TextField", style: TextStyle(color: Colors.lightBlue, fontSize: 20),),
                    TextField(
                      controller: bookTerm,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder()
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          List books = await RestService().getBooks(
                              bookTerm.text);
                          Navigator.pushNamed(
                              context, Routes.bookListScreen, arguments: books);
                        }, child: Text("Search")),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
