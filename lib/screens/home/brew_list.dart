import 'package:brew_crew/model/brew.dart';
import 'package:brew_crew/screens/home/brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewList extends StatefulWidget {
  const BrewList({super.key});

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final brew = Provider.of<List<Brew>>(
        context); //I need to use the provider of because the brew is already controlled by StreamProvider to access the Firestore data (brew documents)
    return ListView.builder(
        itemCount: brew.length,
        itemBuilder: (context, index) {
          return BrewTile(brew: brew[index]);
        });
  }
}
