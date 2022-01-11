import 'package:flutter/material.dart';
import 'package:it_books/models/book.dart';
import 'package:url_launcher/url_launcher.dart';

class BookScreen extends StatefulWidget {
  final Book? book;
  const BookScreen({Key? key, this.book}) : super(key: key);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Book info"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(widget.book!.imageUrl, fit: BoxFit.fitWidth,),
              IconButton(onPressed: (){
                _launchURL(widget.book!.bookUrl);
              }, icon: const Icon(Icons.shopping_cart, color: Colors.lightBlue, size: 40,)),
              CustomCard("Title: ", widget.book!.title, false),
              CustomCard("Subtitle: ", widget.book!.subtitle, false),
              CustomCard("Authors: ", widget.book!.authors, false),
              CustomCard("Publisher: ", widget.book!.publisher, false),
              CustomCard("isbn10: ", widget.book!.isbn10, false),
              CustomCard("isbn13: ", widget.book!.isbn13, false),
              CustomCard("Pages: ", widget.book!.pages.toString(), false),
              CustomCard("Year: ", widget.book!.year.toString(), false),
              CustomCard("Rating: ", widget.book!.rating.toString(), false),
              CustomCard("Description: ", widget.book!.desc, false),

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

Widget CustomCard(String title, String subtitle, bool clicable){
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
