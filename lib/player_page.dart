import 'package:flutter/material.dart';
import 'package:httpapp/player_card.dart';
import 'dart:convert';
import 'models/player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayerPage extends StatefulWidget {
  var spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );
  PlayerPage({this.teamId});
  final teamId;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
  int pageNumber = 1;
  List<Player> players = [];
  List<Player> filteredPlayers = [];
  Map<String, dynamic> jsonData = {};
  int statusCode = 200;

  Future getPlayers() async {
    String requestedUrl =
        'https://www.balldontlie.io/api/v1/players?page=$pageNumber&per_page=100';

    try {
      final response = await http.get(Uri.parse(requestedUrl));
      statusCode = response.statusCode;
      jsonData = Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      print(e);
    }

    for (var eachPlayer in jsonData['data']) {
      final player = Player(
          name: eachPlayer['first_name'] + ' ' + eachPlayer['last_name'],
          position: eachPlayer['position'],
          id: eachPlayer['team']['id'],
          conference: eachPlayer['team']['conference'],
          picture: eachPlayer['postition']);
      players.add(player);
    }

    for (var player in players) {
      if (player.id == widget.teamId) {
        filteredPlayers.add(player);
      }
    }

    filteredPlayers = filteredPlayers.toSet().toList();
  }

  Widget _buildPlayerTile(Player player) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: const Icon(Icons.man),
          title: Text(player.name),
          subtitle: Text(player.conference),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlayerCard();
            }));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player List'),
        backgroundColor: Color.fromARGB(255, 85, 91, 79),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: getPlayers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done &&
                  filteredPlayers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (statusCode != 200) {
                return const Center(
                    child: Text("No data",
                        style: TextStyle(color: Colors.red, fontSize: 20.0)));
              }

              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 8.0)),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      filteredPlayers.map((e) => _buildPlayerTile(e)).toList(),
                      semanticIndexCallback: (_, index) {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 205, 196, 170),
                      ),
                      child: isLoading
                          ? const Center(
                              child: SpinKitWanderingCubes(
                              color: Color.fromARGB(
                                255,
                                93,
                                114,
                                69,
                              ),
                              size: 30,
                            ))
                          : const Text(
                              "Load more",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                      onPressed: () async {
                        isLoading = true;
                        pageNumber += 1;
                        setState(() {});
                        getPlayers();
                        await Future.delayed(Duration(seconds: 1));
                        isLoading = false;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
