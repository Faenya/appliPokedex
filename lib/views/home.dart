import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke/components/home_button.dart';

import '../components/poke_nav_bar.dart';
import '../config/colors.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pokémon Land",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Container(
        //alignment: Alignment.center,
        color: PokedexColors.grayScale[100],
        child: const Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              child: Opacity(
                opacity: 0.7,
                child: Image(
                  alignment: Alignment.bottomCenter,
                  /*fit: BoxFit.cover,*/
                  image: AssetImage("lib/assets/images/background.jpeg"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeButton(name: "Login", path: '/login'),
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "or",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  HomeButton(name: "Register", path: '/register'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const PokeNavBar(index: 4),
    );
  }
}