import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:it_books/models/book.dart';
import 'package:it_books/navigation/route_generator.dart';
import 'package:it_books/navigation/routes.dart';
import 'package:it_books/services/providers/rest_service_provider.dart';
import 'package:it_books/services/rest_services.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'fixtures/reader.dart';
import 'screens_tests.mocks.dart';



@GenerateMocks([RestService, RestServiceProvider])
void main(){

  late RestService mockRestService;
  late RestServiceProvider mockRestServiceProvider;

  mockRestService = MockRestService();
  mockRestServiceProvider = MockRestServiceProvider();

  const String urlRight = 'https://api.itbook.store/1.0/search/mongodb';
  const String urlEmpty = 'https://api.itbook.store/1.0/search/xjk';

  setUp(() {

    when(mockRestService.getNumberOfBooks("right")).thenAnswer((_) => Future.value("20"));
    when(mockRestService.getNumberOfBooks("wrong")).thenAnswer((_) => Future.value("error"));
    when(mockRestService.getNumberOfBooks("")).thenAnswer((_) => Future.value("0"));

    when(mockRestService.getBooksByPage(1, "right"))
        .thenAnswer((_) =>
        Future.value(json.decode(fixture('books_right.json')) as List<dynamic>));

    when(mockRestService.getBooksByPage(2, "right"))
        .thenAnswer((_) =>
        Future.value(json.decode(fixture('books_right.json')) as List<dynamic>));

    when(mockRestService.getBooks("right"))
        .thenAnswer((_) =>
        Future.value(json.decode(fixture('books_right.json')) as List<dynamic>));

    when(mockRestService.getBooksByPage(1, "wrong"))
        .thenAnswer((_) => Future.value([false, "test"]));

    when(mockRestService.getBooksByPage(1, ""))
        .thenAnswer((_) => Future.value([]));

    when(mockRestService.booksMap).thenAnswer((_) => HashMap<String, int>());
    Book book = Book.fromJson(json.decode(fixture('book_info.json')));
    when(mockRestService.getBookInfo("9781484206485"))
        .thenAnswer((_) => Future.value(book));

    when(mockRestServiceProvider.getRestService()).thenAnswer((_) => mockRestService);
    when(mockRestServiceProvider.newRestService()).thenAnswer((_) => mockRestService);

  });

  Widget createSearchScreenWithMockedRestService(){
    return ChangeNotifierProvider<RestServiceProvider>(
      create: (context) => mockRestServiceProvider,
      child: const MaterialApp(
          initialRoute: Routes.searchScreen,
          onGenerateRoute: RouteGenerator.generateRoute
      ),
    );
  }

  testWidgets('Test the widgets on the search screen', (WidgetTester tester) async {
    await tester.pumpWidget(createSearchScreenWithMockedRestService());
    await tester.pumpAndSettle();

    expect(find.byType(TypeAheadField), findsOneWidget);
    expect(find.byKey(const Key("text-field-for-search")), findsOneWidget);
    expect(find.byKey(const Key('search-button')), findsOneWidget);
  });

  group('Test the searching with search button', (){

    testWidgets('with empty text', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchScreenWithMockedRestService());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("text-field-for-search")), "");
      await tester.tap(find.byKey(const Key('search-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("book-list-screen")), findsOneWidget);
      expect(find.byKey(const Key("no-items-found")), findsOneWidget);
    });

    testWidgets('with right text', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchScreenWithMockedRestService());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("text-field-for-search")), "right");
      await tester.tap(find.byKey(const Key('search-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("book-list-screen")), findsOneWidget);
      expect(find.byKey(const Key("no-items-found")), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('with wrong text', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchScreenWithMockedRestService());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("text-field-for-search")), "wrong");
      await tester.tap(find.byKey(const Key('search-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("book-list-screen")), findsNothing);
      expect(find.byKey(const Key("no-items-found")), findsNothing);
      expect(find.byKey(const Key("text-field-for-search")), findsOneWidget);
      expect(find.byKey(const Key('search-button')), findsOneWidget);
    });
  });

  group("Test scrolling", (){
    testWidgets('scrolling down', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchScreenWithMockedRestService());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("text-field-for-search")), "right");
      await tester.tap(find.byKey(const Key('search-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("book-list-screen")), findsOneWidget);
      expect(find.byKey(const Key("no-items-found")), findsNothing);
      expect(find.byKey(const Key("0")), findsOneWidget);

      await tester.scrollUntilVisible(find.byKey(const Key("10")), 500, scrollable: find.byType(Scrollable));
      expect(find.byKey(const Key("10")), findsOneWidget);
    });

    testWidgets('scrolling down and up', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchScreenWithMockedRestService());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("text-field-for-search")), "right");
      await tester.tap(find.byKey(const Key('search-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("book-list-screen")), findsOneWidget);
      expect(find.byKey(const Key("no-items-found")), findsNothing);
      expect(find.byKey(const Key("0")), findsOneWidget);

      await tester.scrollUntilVisible(find.byKey(const Key("10")), 500, scrollable: find.byType(Scrollable));
      expect(find.byKey(const Key("10")), findsOneWidget);

      await tester.scrollUntilVisible(find.byKey(const Key("0")), -500, scrollable: find.byType(Scrollable));
      expect(find.byKey(const Key("0")), findsOneWidget);

    });

    testWidgets('button appearing and disappearing', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchScreenWithMockedRestService());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("text-field-for-search")), "right");
      await tester.tap(find.byKey(const Key('search-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("book-list-screen")), findsOneWidget);
      expect(find.byKey(const Key("no-items-found")), findsNothing);
      expect(find.byKey(const Key("0")), findsOneWidget);

      await tester.scrollUntilVisible(find.byKey(const Key("10")), 500, scrollable: find.byType(Scrollable));
      expect(find.byKey(const Key("go-to-top-button")), findsOneWidget);

      await tester.scrollUntilVisible(find.byKey(const Key("0")), -500, scrollable: find.byType(Scrollable));
      expect(find.byKey(const Key("go-to-top-button")), findsNothing);


    });

    testWidgets('using button to go up', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchScreenWithMockedRestService());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("text-field-for-search")), "right");
      await tester.tap(find.byKey(const Key('search-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("book-list-screen")), findsOneWidget);
      expect(find.byKey(const Key("no-items-found")), findsNothing);
      expect(find.byKey(const Key("0")), findsOneWidget);

      await tester.scrollUntilVisible(find.byKey(const Key("10")), 500, scrollable: find.byType(Scrollable));

      expect(find.byKey(const Key("go-to-top-button")), findsOneWidget);
      await tester.tap(find.byKey(const Key("go-to-top-button")));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("0")), findsOneWidget);
      expect(find.byKey(const Key("10")), findsNothing);
    });
  });


  testWidgets('Test book info.', (WidgetTester tester) async {
    mockNetworkImagesFor(() async => {
      await tester.pumpWidget(createSearchScreenWithMockedRestService()),
      await tester.pumpAndSettle(),

      await tester.enterText(find.byKey(const Key("text-field-for-search")), "right"),
      await tester.tap(find.byKey(const Key('search-button'))),
      await tester.pumpAndSettle(),

      expect(find.byKey(const Key("book-list-screen")), findsOneWidget),
      expect(find.byKey(const Key("no-items-found")), findsNothing),
      expect(find.byKey(const Key("0")), findsOneWidget),

      await tester.tap(find.byKey(const Key("0"))),
      await tester.pumpAndSettle(),

      expect(find.byType(Card), findsNWidgets(10)),

    });
  });



}