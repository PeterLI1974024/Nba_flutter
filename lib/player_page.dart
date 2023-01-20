import 'package:flutter/material.dart';
import 'dart:convert';
import 'models/player.dart';
import 'package:http/http.dart' as http;

class PlayerPage extends StatefulWidget {
  PlayerPage({this.teamId});
  final teamId;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  ScrollController scrollController = ScrollController();
  int pageNumber = 1;
  List<Player> players = [];
  List<Player> filteredPlayers = [];

  Future getPlayers() async {
    String requestedUrl =
        'https://www.balldontlie.io/api/v1/players?page=$pageNumber&per_page=100';
    var response = await http.get(Uri.parse(requestedUrl));
    var jsonData = jsonDecode(response.body);

    for (var eachPlayer in jsonData['data']) {
      final player = Player(
        name: eachPlayer['first_name'] + ' ' + eachPlayer['last_name'],
        position: eachPlayer['position'],
        id: eachPlayer['team']['id'],
        conference: eachPlayer['team']['conference'],
      );
      players.add(player);
    }

    for (var player in players) {
      if (player.id == widget.teamId) {
        filteredPlayers.add(player);
      }
    }
    print(filteredPlayers.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Info'),
        backgroundColor: Color.fromARGB(255, 85, 91, 79),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: getPlayers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: filteredPlayers.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.man),
                          title: Text(filteredPlayers[index].name),
                          subtitle: Text(
                            filteredPlayers[index].conference,
                          ),
                          onTap: () {
                            print('pressed');
                          },
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
