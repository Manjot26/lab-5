import 'package:flutter/material.dart';
import 'pokemon_service.dart';

void main() {
  runApp(const PokemonBattleApp());
}

class PokemonBattleApp extends StatefulWidget {
  const PokemonBattleApp({super.key});

  @override
  _PokemonBattleAppState createState() => _PokemonBattleAppState();
}

class _PokemonBattleAppState extends State<PokemonBattleApp> {
  final PokemonService _pokemonService = PokemonService();
  List<Map<String, dynamic>> _pokemonCards = [];
  String _winner = "";

  void _loadPokemonCards() async {
    try {
      List<Map<String, dynamic>> cards = await _pokemonService.getRandomPokemonCards();
      setState(() {
        _pokemonCards = cards;
        _winner = _determineWinner(cards);
      });
    } catch (e) {
      setState(() {
        _winner = "Failed to load Pokémon.";
      });
    }
  }

  String _determineWinner(List<Map<String, dynamic>> cards) {
    if (cards.length < 2) return "Not enough cards!";
    return (cards[0]['hp'] > cards[1]['hp'])
        ? "${cards[0]['name']} wins!"
        : (cards[0]['hp'] < cards[1]['hp'])
            ? "${cards[1]['name']} wins!"
            : "It's a tie!";
  }

  @override
  void initState() {
    super.initState();
    _loadPokemonCards();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Pokémon Battle")),
        body: Center(
          child: _pokemonCards.isEmpty
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPokemonCard(_pokemonCards[0]),
                    const SizedBox(height: 20),
                    const Text("VS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildPokemonCard(_pokemonCards[1]),
                    const SizedBox(height: 20),
                    Text(_winner, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadPokemonCards,
                      child: const Text("Battle Again"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPokemonCard(Map<String, dynamic> card) {
    return Column(
      children: [
        Image.network(card['image'], height: 200),
        Text("${card['name']} (HP: ${card['hp']})", style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
