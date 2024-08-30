import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poke/domain/models/item_details.dart';
import 'package:poke/domain/services/pokemon_service.dart';

class Items extends StatefulWidget {
  final PokemonService pokemonService;

  // constructeur
  const Items({super.key, required this.pokemonService});

  @override
  State<Items> createState() => _ItemsState();
}

// état associé au StatefulWidget Items
class _ItemsState extends State<Items> {
  // limite du nombre d'éléments par page
  static const int _limit = 20;

  // offset pour la pagination
  int _offset = 0;

  // pour savoir s'il y a une page suivante
  bool _hasNextPage = true;

  // chargement initial
  bool _isFirstLoadRunning = false;

  // chargement supplémentaire
  bool _isLoadMoreRunning = false;

  // liste des éléments chargés
  List<ItemDetails> _items = [];

  // fonction pour charger les premiers éléments
  void _firstLoad() async {
    setState(() {
      // début du chargement initial
      _isFirstLoadRunning = true;
    });
    try {
      // récupération des éléments en appelant le pokemonService
      final itemPage = await widget.pokemonService
          .getItemDetailsByPage(limit: _limit, offset: _offset);
      setState(() {
        // mise à jour de la liste d'éléments
        _items = itemPage;
      });
    } catch (error) {
      if (kDebugMode) {
        // message d'erreur en mode debug
        print('Something went wrong');
      }
    }
    setState(() {
      // fin du chargement initial
      _isFirstLoadRunning = false;
    });
  }

  // controller pour le scroll
  late ScrollController _controller;

  // fonction pour charger plus d'éléments lors du scroll
  void _loadMore() async {
    // s'il y a une page suivante &
    if (_hasNextPage &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        // début du chargement supplémentaire
        _isLoadMoreRunning = true;
      });
      // mise à jour de l'offset
      _offset += _limit;
      try {
        // récupération des éléments en appelant le pokemonService avec l'offset modifié
        final itemPage = await widget.pokemonService
            .getItemDetailsByPage(limit: _limit, offset: _offset);
        setState(() {
          // ajout des nouveaux éléments en gardant aussi ceux d'avant
          _items = [..._items, ...itemPage];
        });
        // pas de page suivante si moins d'éléments que la limite
        if (itemPage.length < _limit) {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      setState(() {
        // fin du chargement supplémentaire
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // chargement initial des éléments
    _firstLoad();
    // initialisation du controller de scroll
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    // suppression du listener lors de la destruction
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Item Details",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                Expanded(
                    child: ListView.builder(
                        // controller
                        controller: _controller,
                        // nombre d'éléments dans la liste
                        itemCount: _items.length,
                        itemBuilder: (BuildContext context, index) {
                          final item = _items[index];
                          return ExpansionTile(
                            leading: Image.network(item.spriteUrl),
                            title: Text(item.name),
                            children: <Widget>[
                              ListTile(title: Text(item.effect)),
                              ListTile(
                                  title: Text('Category: ${item.category}')),
                            ],
                          );
                        })),
                if (_isLoadMoreRunning)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ]));
  }
}