

class Book {
  late String title;
  late String subtitle;
  late String authors;
  late String publisher;
  late String isbn10;
  late String isbn13;
  late int pages;
  late int year;
  late int rating;
  late String desc;
  late String price;
  late String imageUrl;
  late String bookUrl;

  Book();

  Book.fromJson(Map<String, dynamic> json) :
      title = json["title"],
        subtitle = json["subtitle"],
        authors = json["authors"],
        publisher = json["publisher"],
        isbn10 = json["isbn10"],
        isbn13 = json["isbn10"],
        pages = int.parse(json["pages"]),
        year = int.parse(json["year"]),
        rating = int.parse(json["rating"]),
        desc = json["desc"],
        price = json["price"],
        imageUrl = json["image"],
        bookUrl = json["url"];

}