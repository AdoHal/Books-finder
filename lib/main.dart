import 'package:flutter/material.dart';
import 'package:it_books/navigation/route_generator.dart';
import 'package:it_books/navigation/routes.dart';
import 'package:it_books/services/providers/rest_service_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => RestServiceProvider())
          ],
          child: const MyApp()),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.searchScreen,
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
    );

  }
}

