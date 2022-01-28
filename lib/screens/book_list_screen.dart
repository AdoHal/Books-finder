import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_books/models/book.dart';
import 'package:it_books/navigation/routes.dart';
import 'package:it_books/services/providers/rest_service_provider.dart';
import 'package:it_books/services/rest_services.dart';
import 'package:it_books/widgets/toast_widget.dart';
import 'package:provider/provider.dart';

class BookListScreen extends StatefulWidget {

  final String term;
  final int numOfBooks;
  List books;
  BookListScreen({Key? key, required this.term, required this.books, required this.numOfBooks}) : super(key: key);

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> with AutomaticKeepAliveClientMixin<BookListScreen> {

  @override
  bool get wantKeepAlive => true;

  late final RestService service;
  late ScrollController _controller;

  int page=1;
  int numOfPages=0;
  bool showTopButton = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    service = context.read<RestServiceProvider>().getRestService();
    numOfPages= (widget.numOfBooks/10).ceil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        key: const Key("book-list-screen"),
        title: const Text("Books list"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.books.isNotEmpty ? Column(
          children: [
            Expanded(
              flex: 9,
              child: Scrollbar(
                thickness: 5,
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: ListView.separated(
                      itemCount: widget.books.length,
                      scrollDirection: Axis.vertical,
                      controller: _controller,
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          key: const Key("item-inside-listview"),
                          child: Container(
                            key: Key(index.toString()),
                            height: 50,
                            color: Colors.lightBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                  child: Text(
                                    '${widget.books[index]["title"]}',
                                    textAlign: TextAlign.center,)),
                            ),
                          ),
                          onTap: () async {
                            Book book = await service
                                .getBookInfo(widget.books[index]["isbn13"]);
                            if(book.isbn13.compareTo("error")==1){
                              ToastWidget().showToast("", Colors.red, Colors.white, Toast.LENGTH_LONG);
                            }else {
                              Navigator
                                  .pushNamed(context,
                                  Routes.bookScreen,
                                  arguments: book);
                            }
                          },
                        );
                      }
                  ),
                ),
              )
            ),
          showTopButton ? Expanded(
                flex:1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    key: const Key("go-to-top-button"),
                    onPressed: () {
                      _controller.animateTo(
                          0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease);
                      },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                    ),
                    child: const Text(
                      "Go to the top.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
            ) : Container()
          ],
        ) : const Center(
          key: Key("no-items-found"),
          child: Text("No items found."),)
      ),
    );


  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        if(page<numOfPages){
          page+=1;
          loadMore(page);
        }
    }

    if(_controller.offset > 0){
      setState(() {
        showTopButton = true;
      });
    }

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        showTopButton = false;
      });
    }
  }

  Future<void> loadMore(page) async {
    List tmpBooks = await service.getBooksByPage(page, widget.term);
    if(tmpBooks[0]!=false){
      widget.books.addAll(tmpBooks);
      setState(() {
        showTopButton= true;
      });
    }else{
      ToastWidget().showToast(
          "Couldn't load more books. Check your internet connection and try again.",
          Colors.red, Colors.white, Toast.LENGTH_LONG);
    }
  }

}


