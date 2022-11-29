import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_api_food/unsearch_field.dart';
import 'package:google_place/google_place.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final _formKey = GlobalKey<FormState>(); // form key
  final TextEditingController searchController = TextEditingController();
  late FocusNode myFocusNode;
  bool isDelayed = false;

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        isDelayed = true;
      });
    });
    String apiKey = ''; // USE YOUR API KEY
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  void autoCompleteSearch(String value) async {
    // var result = await googlePlace.autocomplete.get(
    //   value,
    //   region: 'th',
    //   types: 'restaurant|cafe',
    //   location: const LatLon(13.75336, 100.50483),
    // );
    var result = await googlePlace.autocomplete.get(
      value,
      region: 'Bangkok',
      types: 'restaurant',
      location: const LatLon(13.736717, 100.523186),
      origin: const LatLon(13.736717, 100.523186),
      radius: 20000,
      components: [
        Component('country', 'th'),
      ],
      strictbounds: true,
    );
    if (result != null && result.predictions != null && mounted) {
      // ignore: avoid_print
      // print(result.predictions?.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final unSearchField = UnSearchField().unSearchField;
    final searchField = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: const Color.fromARGB(86, 199, 199, 199),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          autofocus: true,
          enabled: true,
          controller: searchController,
          keyboardType: TextInputType.text,
          onSaved: (value) {
            searchController.text = value!;
          },
          textInputAction: TextInputAction.search,
          style: const TextStyle(
            fontFamily: 'SukhumvitSet',
            fontSize: 18,
          ),
          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce!.cancel();
            }
            _debounce = Timer(const Duration(seconds: 1), () {
              if (value.isNotEmpty) {
                autoCompleteSearch(value);
              }
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Search Restaurants",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () async {
                await SystemSound.play(SystemSoundType.click);
              },
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // key: homeScaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              await SystemSound.play(SystemSoundType.click).then(
                (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 131, 177, 247),
          ),
          centerTitle: true,
          title: const Text(
            'Food BKK',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 6, 44, 14),
                fontSize: 18,
                fontFamily: 'SukhumvitSet'),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'search',
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: isDelayed ? searchField : unSearchField,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      predictions[index].description.toString(),
                      style: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    indent: 15,
                    endIndent: 15,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
