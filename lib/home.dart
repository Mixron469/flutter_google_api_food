import 'package:flutter/material.dart';
import 'package:flutter_google_api_food/home_backround.dart';
import 'package:flutter_google_api_food/unsearch_field.dart';
import 'package:flutter_google_api_food/search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>(); // form key
  final TextEditingController searchController =
      TextEditingController(); // editing controller

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final unSearchField = UnSearchField().unSearchField;

    return Scaffold(
      body: home_background(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.1),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Food BKK",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 10, 111, 170),
                      fontSize: 48,
                      fontFamily: 'SukhumvitSet'),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.1),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchResultPage(),
                    ),
                  );
                },
                child: Hero(
                  tag: 'search',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: unSearchField,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
