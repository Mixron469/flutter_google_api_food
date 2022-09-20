import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnSearchField {
  final TextEditingController searchController =
      TextEditingController(); // editing controller

  get unSearchField => Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: const Color.fromARGB(86, 199, 199, 199),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            autofocus: false,
            controller: searchController,
            readOnly: true,
            enabled: false,
            style: const TextStyle(
              fontFamily: 'SukhumvitSet',
              fontSize: 18,
            ),
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
}
