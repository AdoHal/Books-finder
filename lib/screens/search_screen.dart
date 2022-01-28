import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_books/models/book.dart';
import 'package:it_books/models/book_list_args.dart';
import 'package:it_books/navigation/routes.dart';
import 'package:it_books/services/providers/rest_service_provider.dart';
import 'package:it_books/services/rest_services.dart';
import 'package:it_books/widgets/toast_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final bookTerm = TextEditingController();
  final scrollController = ScrollController();
  late final RestService service;

  @override
  void initState() {
    super.initState();
    service = context.read<RestServiceProvider>().newRestService();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book finder"), automaticallyImplyLeading: false,),
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
                    const Text("Search with TypeAhead",
                      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                    ),
                    TypeAheadField(
                      key: const Key("typeahead-field"),
                      minCharsForSuggestions: 2,
                      textFieldConfiguration: const TextFieldConfiguration(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                              border: OutlineInputBorder()
                          )
                      ),
                      suggestionsCallback: (pattern) async {
                        return await service.getBooks(pattern);
                      },
                      errorBuilder: (BuildContext context, error){
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Something went wrong."
                              " Check your internet connection.",
                            style: TextStyle(color: Colors.red),),
                        );
                      },
                      itemBuilder: (context, dynamic suggestion) {
                        return ListTile(
                          key: const Key("title"),
                          title: Text(suggestion['title']),
                          subtitle: Text(suggestion['subtitle']),
                        );
                      },
                      onSuggestionSelected: (dynamic suggestion) async {
                        Book book = await service.getBookInfo(suggestion["isbn13"]);
                        if(book.isbn13.compareTo("error")==1){
                          ToastWidget().showToast("", Colors.red, Colors.white, Toast.LENGTH_LONG);
                        }
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
                    const Text("Search with TextField",
                      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                    ),
                    TextField(
                      key: const Key("text-field-for-search"),
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
                      key: const Key("search-button"),
                        onPressed: () async {
                          service.booksMap.clear();

                          String numOfBooks = await service.getNumberOfBooks(bookTerm.text);

                          if(numOfBooks.compareTo("error")==1){
                            ToastWidget().showToast("", Colors.red, Colors.white, Toast.LENGTH_LONG);
                          }else{
                            List books = await service.getBooksByPage(1,
                                bookTerm.text);

                            if(books.isEmpty){
                              BookListScreenArguments args = BookListScreenArguments(bookTerm.text, books, int.parse(numOfBooks));
                              Navigator.pushNamed(
                                  context, Routes.bookListScreen, arguments: args);
                            }else if(books[0]==false){
                              ToastWidget().showToast("", Colors.red, Colors.white, Toast.LENGTH_LONG);
                            }else{
                              BookListScreenArguments args = BookListScreenArguments(bookTerm.text, books, int.parse(numOfBooks));
                              Navigator.pushNamed(
                                  context, Routes.bookListScreen, arguments: args);
                            }
                          }
                        }, child: const Text("Search")),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
