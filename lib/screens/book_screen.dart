
import 'package:flutter/material.dart';
import 'package:it_books/models/book.dart';
import 'package:url_launcher/url_launcher.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  const BookScreen({Key? key,required this.book}) : super(key: key);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book info"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(widget.book.imageUrl, fit: BoxFit.fitWidth,),
              IconButton(onPressed: (){
                _launchURL(widget.book.bookUrl);
              }, icon: const Icon(Icons.shopping_cart, color: Colors.lightBlue, size: 40,)),
              customCard("Title: ", widget.book.title, false),
              customCard("Subtitle: ", widget.book.subtitle, false),
              customCard("Authors: ", widget.book.authors, false),
              customCard("Publisher: ", widget.book.publisher, false),
              customCard("isbn10: ", widget.book.isbn10, false),
              customCard("isbn13: ", widget.book.isbn13, false),
              customCard("Pages: ", widget.book.pages.toString(), false),
              customCard("Year: ", widget.book.year.toString(), false),
              customCard("Rating: ", widget.book.rating.toString(), false),
              customCard("Description: ", widget.book.desc, false),

            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {

    await launch(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Widget customCard(String title, String subtitle, bool clicable){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold),),
            Flexible(child: Text(subtitle)),
          ],
        ),
      ),
    ),
  );
}
